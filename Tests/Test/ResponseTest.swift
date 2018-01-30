import XCTest
import Server

class ResponseTest: XCTestCase {
    
    let response = Response()
    static let body = "<!DOCTYPE html><html><body><h1>Hello World</h1></body></html>"
    static let header = "HTTP/1.1 200 OK\r\nContent-Length: \(body.utf8.count)\r\nContent-type: text/html\r\n\r\n"

    func testBuildResponseWillReturnGETResponse() {
        let request = "GET / "  
        let expectedResponse = response.header200 + Response.body            
        XCTAssertEqual(expectedResponse, response.buildResponse(serverRequest: request))
    }

    func testBuildResponseWillReturnHEADResponse() {
        let request = "HEAD / " 
        let expectedResponse = response.header200 
        XCTAssertEqual(expectedResponse, response.buildResponse(serverRequest: request))
    }

    func testBuildResponseWillReturn404ResponseWithGET() {
        let request = "GET /test " 
        let expectedResponse = response.header404            
        XCTAssertEqual(expectedResponse, response.buildResponse(serverRequest: request))
    }

    func testBuildResponseWillReturn404ResponseWithHEAD() {
        let request = "HEAD /test " 
        let expectedResponse = response.header404 
        XCTAssertEqual(expectedResponse, response.buildResponse(serverRequest: request))
    }

}
