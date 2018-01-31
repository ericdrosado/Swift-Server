import XCTest
import Server

class ResponseTest: XCTestCase {
    
    let response = Response()
    static let body200 = "<!DOCTYPE html><html><body><h1>Hello World</h1></body></html>"
    static let body404 = "<!DOCTYPE html><html><body><h1>404 Page Not Found</h1></body></html>"
    let header200 = "HTTP/1.1 200 OK\r\nContent-Length: \(body200.utf8.count)\r\nContent-type: text/html\r\n\r\n"
    let header404 = "HTTP/1.1 404 Not Found\r\nContent-Length: \(body404.utf8.count)\r\nContent-type: text/html\r\n\r\n"
    let header200HEAD = "HTTP/1.1 200 OK\r\nContent-Length: 0\r\nContent-type: text/html\r\n\r\n"
    let header404HEAD = "HTTP/1.1 404 Not Found\r\nContent-Length: 0\r\nContent-type: text/html\r\n\r\n"

    func testBuildResponseWillReturnGETResponse() {
        let request = "GET / "  
        let expectedResponse = header200 + ResponseTest.body200            
        XCTAssertEqual(expectedResponse, response.buildResponse(serverRequest: request))
    }

    func testBuildResponseWillReturnHEADResponse() {
        let request = "HEAD / " 
        let expectedResponse = header200HEAD 
        XCTAssertEqual(expectedResponse, response.buildResponse(serverRequest: request))
    }

    func testBuildResponseWillReturn404ResponseWithGET() {
        let request = "GET /test " 
        let expectedResponse = header404 + ResponseTest.body404            
        XCTAssertEqual(expectedResponse, response.buildResponse(serverRequest: request))
    }

    func testBuildResponseWillReturn404ResponseWithHEAD() {
        let request = "HEAD /test " 
        let expectedResponse = header404HEAD 
        XCTAssertEqual(expectedResponse, response.buildResponse(serverRequest: request))
    }

    func testBuildResponseWillReturnGETResponseWithQuery() {
        let request = "GET /hello?noun=Person"
        let expectedResponse = "HTTP/1.1 200 OK\r\nContent-Length: 62\r\nContent-type: text/html\r\n\r\n"
 + "<!DOCTYPE html><html><body><h1>Hello Person</h1></body></html>"
        XCTAssertEqual(expectedResponse, response.buildResponse(serverRequest: request))
    }

}
