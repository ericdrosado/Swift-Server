import XCTest
import Server

class ResponseTest: XCTestCase {
    
    let parser = Parser()
    let response = Response()
    let status200 = "200 OK"
    let status404 = "404 Not Found"
    let queries = ["Person", "John", "Doe"]
    
    private func buildRequest(method: String, route: String, body: String="") -> String {
        return "\(method) \(route)\r\nCache-Control: no-cache\r\nConnection: keep-alive\r\n\r\n\(body)"
    }

    private func buildResponse(statusCode: String, body: String="") -> String {
        return "HTTP/1.1 \(statusCode)\r\nContent-Length: \(body.utf8.count)\r\nContent-type: text/html\r\n\r\n\(body)" 
    }

    private func buildHTMLBody(content: String) -> String {
        return "<!DOCTYPE html><html><body><h1>\(content)</h1></body></html>"
    }

    private func readText() -> String {
        let filePath = NSURL.fileURL(withPath: "data.txt")
        var logData: String = String()
            do {
                logData = try String(contentsOf: filePath, encoding: String.Encoding.utf8) 
            } catch {
                print("Error reading data.txt. \(error)")
            }
        return logData
    }

    func testBuildResponseWillReturnGETResponse() {
        let request = buildRequest(method: "GET", route: "/")
        let expectedResponse = buildResponse(statusCode: status200, body: buildHTMLBody(content: "Hello World"))

        let parsedRequest = parser.parseRequest(request: request)
        
        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

    func testBuildResponseWillReturnHEADResponse() {
        let request = buildRequest(method: "HEAD", route: "/")
        let expectedResponse = buildResponse(statusCode: status200)

        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

    func testBuildResponseWillReturn404ResponseWithGET() {
        let request = buildRequest(method: "GET", route: "/fooBar")
        let expectedResponse = buildResponse(statusCode: status404, body: buildHTMLBody(content: "404 Page Not Found"))        

        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

    func testBuildResponseWillReturn404ResponseWithHEAD() {
        let request = buildRequest(method: "HEAD", route: "/foobar")
        let expectedResponse = buildResponse(statusCode: status404) 

        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

    func testBuildResponseWillReturnGETResponseWithQuery() {
        let request = buildRequest(method: "GET", route: "/hello?fname=\(queries[0])")
        let expectedResponse = buildResponse(statusCode: status200, body: buildHTMLBody(content: "Hello \(queries[0])") )

        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

    func testBuildResponseWillReturnGETResponseWith2Queries() {
        let request = buildRequest(method: "GET", route: "/hello?mname=\(queries[0])&lname=\(queries[1])")
        let expectedResponse = buildResponse(statusCode: status200, body: buildHTMLBody(content: "Hello \(queries[0]) \(queries[1])"))

        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

    func testBuildResponseWillReturnGETResponseWith3Queries() {
        let request = buildRequest(method: "GET", route: "/hello?fname=\(queries[0])&lname=\(queries[2])&mname=\(queries[1])")
        let expectedResponse = buildResponse(statusCode: status200, body: buildHTMLBody(content: "Hello \(queries[0]) \(queries[1]) \(queries[2])"))

        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

    func testBuildResponseWillReturnProperGETResponseWithQueryAfterAnInitialRequest() {
        let request1 = buildRequest(method: "GET", route: "/hello?fname=Person")
        let request2 = buildRequest(method: "GET", route: "/hello") 
        let expectedResponse = buildResponse(statusCode: status200, body: buildHTMLBody(content: "Hello World"))

        let parsedRequest1 = parser.parseRequest(request: request1)
        _ = response.buildResponse(request: parsedRequest1)
        let parsedRequest2 = parser.parseRequest(request: request2)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest2))
    }

    func testBuildResponseWillReturn418Response() {
        let request = buildRequest(method: "GET", route: "/coffee")
        let expectedResponse = buildResponse(statusCode: "418", body: "I'm a teapot")

        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

    func testBuildResponseWillDecodeOperators() {
        let request = buildRequest(method: "GET", route: "/parameters?variable_1=Operators%20%3C%2C%20%3E%2C%20%3D%2C%20!%3D%3B%20%2B%2C%20-%2C%20*%2C%20%26%2C%20%40%2C%20%23%2C%20%24%2C%20%5B%2C%20%5D%3A%20%22is%20that%20all%22%3F")
        let expectedResponse = buildResponse(statusCode: status200, body: buildHTMLBody(content: "variable_1 = Operators <, >, =, !=; +, -, *, &, @, #, $, [, ]: \"is that all\"?"))
        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

    func testBuildResponseWillReturnPOSTResponse() {
        let request = buildRequest(method: "POST", route: "/form", body: "My=Data")
        let expectedResponse = buildResponse(statusCode: status200)

        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

    func testBuildResponseWillReturnPUTResponse() {
        let request = buildRequest(method: "PUT", route: "/form", body: "My=Data")
        let expectedResponse = buildResponse(statusCode: status200)

        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

    func testBuildResponseWillPostBodyToFile() {
        let body = "My=Data"
        let request = buildRequest(method: "POST", route: "/form", body: body)

        let parsedRequest = parser.parseRequest(request: request) 
        let _ = response.buildResponse(request: parsedRequest)
        let dataFromFile = readText() 

        XCTAssertEqual(body, dataFromFile)
    }

    func testBuildResponseWillAlterFileWithPutBody() {
        let body = "My=Foo"
        let request = buildRequest(method: "PUT", route: "/form", body: body)

        let parsedRequest = parser.parseRequest(request: request) 
        let _ = response.buildResponse(request: parsedRequest)
        let dataFromFile = readText()

        XCTAssertEqual(body, dataFromFile)
    }

}
