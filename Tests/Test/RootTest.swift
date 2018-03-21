import XCTest
import Routes
import Server

class RootTest: XCTestCase {

    let parser = Parser(directory: "./cob_spec/public")
    let root = Root()
    let status200 = "200 OK"
    
    private func buildRequest(method: String, route: String, body: String = "", additionalHeaders: String = "") -> String {
        return "\(method) \(route) HTTP/1.1\r\n\(additionalHeaders)Cache-Control: no-cache\r\nConnection: keep-alive\r\n\r\n\(body)"
    }

    private func buildResponse(statusCode: String, additionalHeaders: String = "", body: String = "") -> String {
        return "HTTP/1.1 \(statusCode)\r\n\(additionalHeaders)Content-Length: \(body.utf8.count)\r\nContent-type: text/html\r\n\r\n\(body)" 
    }
    
    private func prepareBody(body: String) -> String {
        return "<!DOCTYPE html><html><body><h1>\(body)</h1></body></html>"
    }
    
    private func getFilesFromDirectory(directory: String) -> String? {
        do {
            return try FileManager.default.contentsOfDirectory(atPath: directory).joined(separator: "\n")
        } catch {
            print("File could not be read. \(error)")
        }
        return nil 
    }
    
    func testHandleRouteWillReturnResponseWithDirectoryListing() { 
        let request = buildRequest(method: "GET", route: "/")    
        let expectedResponse = buildResponse(statusCode: status200, body: prepareBody(body: getFilesFromDirectory(directory: "./cob_spec/public")!))

        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, root.handleRoute(request: parsedRequest))

    }
    
}
