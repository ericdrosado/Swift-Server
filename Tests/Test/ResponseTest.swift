import XCTest
import Server

class ResponseTest: XCTestCase {
    
    let parser = Parser()
    let response = Response()
    static let body200 = "<!DOCTYPE html><html><body><h1>Hello World</h1></body></html>"
    static let body404 = "<!DOCTYPE html><html><body><h1>404 Page Not Found</h1></body></html>"
    let requestHeader = "\r\nCache-Control: no-cache\r\nConnection: keep-alive\r\n\r\n"
    let header200 = "HTTP/1.1 200 OK\r\nContent-Length: \(body200.utf8.count)\r\nContent-type: text/html\r\n\r\n"
    let header404 = "HTTP/1.1 404 Not Found\r\nContent-Length: \(body404.utf8.count)\r\nContent-type: text/html\r\n\r\n"
    let header200HEAD = "HTTP/1.1 200 OK\r\nContent-Length: 0\r\nContent-type: text/html\r\n\r\n"
    let header404HEAD = "HTTP/1.1 404 Not Found\r\nContent-Length: 0\r\nContent-type: text/html\r\n\r\n"

    func testBuildResponseWillReturnGETResponse() {
        let request = "GET / " + requestHeader 
        let expectedResponse = header200 + ResponseTest.body200            

        let parsedRequest = parser.parseRequest(request: request)
        
        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

    func testBuildResponseWillReturnHEADResponse() {
        let request = "HEAD / " + requestHeader 
        let expectedResponse = header200HEAD 

        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

    func testBuildResponseWillReturn404ResponseWithGET() {
        let request = "GET /test " + requestHeader 
        let expectedResponse = header404 + ResponseTest.body404            
        
        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

    func testBuildResponseWillReturn404ResponseWithHEAD() {
        let request = "HEAD /test " + requestHeader
        let expectedResponse = header404HEAD 

        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

    func testBuildResponseWillReturnGETResponseWithQuery() {
        let request = "GET /hello?fname=Person" + requestHeader
        let expectedResponse = "HTTP/1.1 200 OK\r\nContent-Length: 62\r\nContent-type: text/html\r\n\r\n"
 + "<!DOCTYPE html><html><body><h1>Hello Person</h1></body></html>"

        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

    func testBuildResponseWillReturnGETResponseWith2Queries() {
        let request = "GET /hello?mname=Person&lname=Doe" + requestHeader
        let expectedResponse = "HTTP/1.1 200 OK\r\nContent-Length: 66\r\nContent-type: text/html\r\n\r\n"
 + "<!DOCTYPE html><html><body><h1>Hello Person Doe</h1></body></html>"

        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

    func testBuildResponseWillReturnGETResponseWith3Queries() {
        let request = "GET /hello?fname=Person&lname=Doe&mname=John" + requestHeader
        let expectedResponse = "HTTP/1.1 200 OK\r\nContent-Length: 71\r\nContent-type: text/html\r\n\r\n"
 + "<!DOCTYPE html><html><body><h1>Hello Person John Doe</h1></body></html>"

        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

    func testBuildResponseWillReturnProperGETResponseWithQueryAfterAnInitialRequest() {
        let request1 = "GET /hello?fname=Person" + requestHeader
        let request2 = "GET /hello" + requestHeader
        let expectedResponse = header200 + ResponseTest.body200 

        let parsedRequest1 = parser.parseRequest(request: request1)
        _ = response.buildResponse(request: parsedRequest1)
        let parsedRequest2 = parser.parseRequest(request: request2)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest2))
    }

    func testBuildResponseWillReturn418Response() {
        let request = "GET /coffee"
        let expectedResponse = "HTTP/1.1 418\r\nContent-Length: 12\r\nContent-type: text/html\r\n\r\nI'm a teapot"

        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

    func testBuildResponseWillDecodeOperators() {
        let request = "GET /parameters?variable_1=Operators%20%3C%2C%20%3E%2C%20%3D%2C%20!%3D%3B%20%2B%2C%20-%2C%20*%2C%20%26%2C%20%40%2C%20%23%2C%20%24%2C%20%5B%2C%20%5D%3A%20%22is%20that%20all%22%3F"
        let expectedResponse = "HTTP/1.1 200 OK\r\nContent-Length: 127\r\nContent-type: text/html\r\n\r\n<!DOCTYPE html><html><body><h1>variable_1 = Operators <, >, =, !=; +, -, *, &, @, #, $, [, ]: \"is that all\"?</h1></body></html>" 
        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

}
