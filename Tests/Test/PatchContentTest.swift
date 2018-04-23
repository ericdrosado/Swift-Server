import XCTest
import Routes
import Request
import Server
import ServerIO

class PatchContentTest: XCTestCase {

    let patchContent = PatchContent(documentIO: DocumentIO())
    let parser = Parser(directory: "./cob_spec/public")

    private func manageTempFile(file: String) {
        let filePath = NSURL.fileURL(withPathComponents: [file])
            let path: String = filePath!.path
            FileManager.default.createFile(atPath: path, contents: Data(), attributes: nil)

        addTeardownBlock {
            do {
                let filePath = NSURL.fileURL(withPathComponents: [file])
                try FileManager.default.removeItem(at: filePath!) 
            } catch {
                XCTFail("Error while deleting temporary file at \(path): \(error)")
            }
        }
    }

    private func writeText(request: Request, path: URL) {
        if let text = request.body["body"] {  
            do {
                try text.write(to: path, atomically: false,
                encoding: String.Encoding.utf8)
            } catch {
                print("Error writing to file. \(error)") 
            }
        }
    }

    private func buildRequest(method: String, route: String, additionalHeaders: String = "", body: String = "") -> String {
        return "\(method) \(route) HTTP/1.1\r\nCache-Control: no-cache\r\nConnection: keep-alive\(additionalHeaders)\r\n\r\n\(body)"
    }

    func testHandleRouteWillReturn200StatusCodeForGetRequest() {
        let path = "/patch-content"
        let request = buildRequest(method: "GET", route: path, body: "default content")
        let parsedRequest = parser.parseRequest(request: request)
        let file = "\(parsedRequest.directory)\(path)"

        manageTempFile(file: file)
        let filePath = NSURL.fileURL(withPathComponents: [file])
        writeText(request: parsedRequest, path: filePath!)

        let routeData = patchContent.handleRoute(request: parsedRequest)

        XCTAssertEqual("200", routeData.responseLine["statusCode"])
    }

    func testHandleRouteWillReturnExpectedBodyForGetRequest() {
        let path = "/patch-content"
        let request = buildRequest(method: "GET", route: path, body: "default content")
        let parsedRequest = parser.parseRequest(request: request)
        let file = "\(parsedRequest.directory)\(path)"

        manageTempFile(file: file)
        let filePath = NSURL.fileURL(withPathComponents: [file])
        writeText(request: parsedRequest, path: filePath!)
        let routeData = patchContent.handleRoute(request: parsedRequest)

        let expectedBody = "default content"

        XCTAssertEqual(expectedBody, routeData.body)
    }

    func testHandleRouteWillUpdateBodyWithPatchRequest() {
        let path = "/patch-content"
        let request = buildRequest(method: "PATCH", route: path, body: "patched content")
        let parsedRequest = parser.parseRequest(request: request)
        let file = "\(parsedRequest.directory)\(path)"

        manageTempFile(file: file)
        let filePath = NSURL.fileURL(withPathComponents: [file])
        writeText(request: parsedRequest, path: filePath!)
        let routeData = patchContent.handleRoute(request: parsedRequest)

        let expectedBody = "patched content"

        XCTAssertEqual(expectedBody, routeData.body)
    }

    func testHandleRequestWillReturn204StatusCodeForPatchRequest() {
        let path = "/patch-content"
        let request = buildRequest(method: "PATCH", route: path, body: "patched content")
        let parsedRequest = parser.parseRequest(request: request)
        let file = "\(parsedRequest.directory)\(path)"

        manageTempFile(file: file)
        let filePath = NSURL.fileURL(withPathComponents: [file])
        writeText(request: parsedRequest, path: filePath!)
        let routeData = patchContent.handleRoute(request: parsedRequest)

        XCTAssertEqual("204", routeData.responseLine["statusCode"])
    }

    func testHandleRequestWillReturn405StatusCodeIfNotGetOrPatchRequest() {
        let path = "/patch-content"
        let request = buildRequest(method: "PUT", route: path, body: "Test")
        let parsedRequest = parser.parseRequest(request: request)
        let file = "\(parsedRequest.directory)\(path)"

        manageTempFile(file: file)
        let filePath = NSURL.fileURL(withPathComponents: [file])
        writeText(request: parsedRequest, path: filePath!)
        let routeData = patchContent.handleRoute(request: parsedRequest)

        XCTAssertEqual("405", routeData.responseLine["statusCode"])
    }
}
