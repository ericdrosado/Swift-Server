import XCTest
import Routes
import Server
import ServerIO

class PartialContentTest: XCTestCase {
    
    let parser = Parser(directory: "./cob_spec/public")
    let partialContent = PartialContent(documentIO: DocumentIO())
    
    private func buildRequest(method: String, route: String, body: String = "", range: String) -> String {
        return "\(method) \(route) HTTP/1.1\r\nCache-Control: no-cache\r\nConnection: keep-alive\r\nRange: bytes=\(range)\r\n\r\n\(body)"
    }

    private func manageTempFile(file: String) {
        let filePath = NSURL.fileURL(withPathComponents: [file])
        let path: String = filePath!.path
        FileManager.default.createFile(atPath: path, contents: Data(), attributes: nil)
        let text = "This is a file that contains text to read part of in order to fulfill a 206."
        do {
            try text.write(to: filePath!, atomically: false,
            encoding: String.Encoding.utf8)
        } catch {
            print("Error writing to data.txt. \(error)")
        }

        addTeardownBlock {
            do {
                let filePath = NSURL.fileURL(withPathComponents: [file])
                try FileManager.default.removeItem(at: filePath!) 
            } catch {
                XCTFail("Error while deleting temporary file at \(path): \(error)")
            }
        }
    }

    private func buildRouteData(body: String, contentLength: String, contentRange: String, statusCode: String, statusMessage: String) -> RouteData {
        return RouteData(responseLine: ["httpVersion": "HTTP/1.1", "statusCode": statusCode, "statusMessage": statusMessage], 
                         headers:["Content-Type": "text/plain; charset=utf-8", "Content-Length": contentLength, "Allow": "GET", "Content-Range": contentRange],
                         body: body)
    }

    func testHandleRouteWillReturnRouteDataForByteRangePrefixedWithDash() {
        manageTempFile(file: "partial_content.txt")
        let request = buildRequest(method: "GET", route: "/partial_content.txt", body: "", range: "-6")
        let parsedRequest = parser.parseRequest(request: request)
        let routeData = partialContent.handleRoute(request: parsedRequest)

        let expectedRouteData = buildRouteData(body: " 206.\n", contentLength: "6", contentRange: "bytes 71-76/77", statusCode: "206", statusMessage: "Partial Content")

        XCTAssertTrue(expectedRouteData == routeData)
    }

    func testHandleRouteWillReturnRouteDataForByteRangeSuffixedWithDash() {
        manageTempFile(file: "partial_content.txt")
        let request = buildRequest(method: "GET", route: "/partial_content.txt", body: "", range: "4-")
        let parsedRequest = parser.parseRequest(request: request)
        let routeData = partialContent.handleRoute(request: parsedRequest)

        let expectedRouteData = buildRouteData(body: " is a file that contains text to read part of in order to fulfill a 206.\n", contentLength: "73", contentRange: "bytes 4-76/77", statusCode: "206", statusMessage: "Partial Content")

        XCTAssertTrue(expectedRouteData == routeData)
    }

    func testHandleRouteWillReturnRouteDataForByteRangeWithStartAndEndIndex() {
        manageTempFile(file: "partial_content.txt")
        let request = buildRequest(method: "GET", route: "/partial_content.txt", body: "", range: "0-4")
        let parsedRequest = parser.parseRequest(request: request)
        let routeData = partialContent.handleRoute(request: parsedRequest)

        let expectedRouteData = buildRouteData(body: "This ", contentLength: "5", contentRange: "bytes 0-4/77", statusCode: "206", statusMessage: "Partial Content")

        XCTAssertTrue(expectedRouteData == routeData)
    }

    func testHandleRouteWillReturnRouteDataForByteRangeOverContentRange() {
        manageTempFile(file: "partial_content.txt")
        let request = buildRequest(method: "GET", route: "/partial_content.txt", body: "", range: "75-80")
        let parsedRequest = parser.parseRequest(request: request)
        let routeData = partialContent.handleRoute(request: parsedRequest)

        let expectedRouteData = buildRouteData(body: "", contentLength: "0", contentRange: "bytes */77", statusCode: "416", statusMessage: "Range Not Satisfiable")

        XCTAssertTrue(expectedRouteData == routeData)
    }
}
