import XCTest
import Routes
import Server

class LogsTest: XCTestCase {

    let parser = Parser()
    let logs = Logs()
    let status200 = "200 OK"
    let status401 = "401"
    let authenticationHeader = "WWW-Authenticate: Basic realm= Access to logs"
    let authorizationHeader = "Authorization: Basic YWRtaW46aHVudGVyMg==\r\n"
    
    private func buildRequest(method: String, route: String, body: String = "", additionalHeaders: String = "") -> String {
        return "\(method) \(route) HTTP/1.1\r\n\(additionalHeaders)Cache-Control: no-cache\r\nConnection: keep-alive\r\n\r\n\(body)"
    }

    private func buildResponse(statusCode: String, additionalHeaders: String = "", body: String = "") -> String {
        return "HTTP/1.1 \(statusCode)\r\n\(additionalHeaders)Content-Length: \(body.utf8.count)\r\nContent-type: text/html\r\n\r\n\(body)" 
    }
    
    func testHandleRouteWillReturnResponseWith401AndWWWAuthenticate() { 
        let request = buildRequest(method: "GET", route: "/logs")    
        let expectedResponse = buildResponse(statusCode: status401, additionalHeaders: authenticationHeader)

        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, logs.handleRoute(request: parsedRequest))

    }

    func testHandleRouteWillNotReturn401Response() { 
        let request = buildRequest(method: "GET", route: "/logs", additionalHeaders: authorizationHeader)    
        let responseWith401Status = buildResponse(statusCode: status401, additionalHeaders: authenticationHeader)

        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertNotEqual(responseWith401Status, logs.handleRoute(request: parsedRequest))

    }
    
}
