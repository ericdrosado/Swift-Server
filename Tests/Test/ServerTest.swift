import XCTest
import Server

class ServerTest: XCTestCase {
    
    let server = Server(port: 3333)
    static let body = "<!DOCTYPE html><html><body><h1>Hello World</h1></body></html>"
    static let header = "HTTP/1.1 200 OK\r\nContent-Length: \(body.utf8.count)\r\nContent-type: text/html\r\n\r\n"

    func testParseRequestWillReturnGETResponse() {
        let request = "GET / " + ServerTest.header
        let methodRequest = server.getRequestMethod(request: request)            
        XCTAssertEqual("GET", methodRequest)
    }

    func testParseRequestWillReturnHeadRequest(){
        let request = "Head / " + ServerTest.header
        let methodRequest = server.getRequestMethod(request: request)            
        XCTAssertEqual("Head", methodRequest)
    }

    func testPrepareResponseWillReturnGETResponse() {
        let response = ServerTest.header + ServerTest.body
        XCTAssertEqual(response, server.prepareResponse(requestMethod: "GET"))
    }

    func testPrepareResponseWillReturnHEADResponse() {
        let response = ServerTest.header  
        XCTAssertEqual(response, server.prepareResponse(requestMethod: "HEAD"))
    }

}
