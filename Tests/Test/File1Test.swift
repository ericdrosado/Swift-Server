import XCTest
import Request
import Routes
import Server

class File1Test: XCTestCase {

    let parser = Parser(directory: "./cob_spec/public")
    let file1 = File1()
    let status200 = "200 OK"
    
    private func buildRequest(method: String, route: String, body: String = "", additionalHeaders: String = "") -> String {
        return "\(method) \(route) HTTP/1.1\r\n\(additionalHeaders)Cache-Control: no-cache\r\nConnection: keep-alive\r\n\r\n\(body)"
    }

    private func buildResponse(statusCode: String, body: String = "") -> String {
        return "HTTP/1.1 \(statusCode)\r\nContent-Length: \(body.utf8.count)\r\nContent-type: text/html\r\n\r\n\(body)" 
    }

    private func readText(request: Request) -> String {
        let path = NSURL.fileURL(withPathComponents: ["\(request.directory)/file1"])
        var logData: String = String()
            do {
                logData = try String(contentsOf: path!, encoding: String.Encoding.utf8) 
            } catch {
                print("Error reading text file. \(error)")
            }
        return logData
    }
    
    func testHandleRouteWillReturnResponseWithContentsOfFile1InBody() { 
        let request = buildRequest(method: "GET", route: "/file1")    
        let parsedRequest = parser.parseRequest(request: request)
        let body = readText(request: parsedRequest)

        let expectedResponse = buildResponse(statusCode: status200, body: body)

        XCTAssertEqual(expectedResponse, file1.handleRoute(request: parsedRequest))

    }
    
}
