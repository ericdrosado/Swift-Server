import XCTest
import Routes
import Server

class ResponseTest: XCTestCase {
    
    let parser = Parser(directory: "./cob_spec/public")
    static let routes = Routes.routes
    static let fourOhFour = FourOhFour()
    static let router = Router(routes: routes, fourOhFour: fourOhFour)
    let response = Response(router: router)
    let status200 = "200 OK"
    let status404 = "404 Not Found"
    let queries = ["Person", "John", "Doe"]
                           
    private func buildRequest(method: String, route: String, body: String = "") -> String {
        return "\(method) \(route) HTTP/1.1\r\nCache-Control: no-cache\r\nConnection: keep-alive\r\n\r\n\(body)"
    }

    private func buildResponse(statusCode: String, additionalHeaders: String = "", body: String = "") -> String {
        return "HTTP/1.1 \(statusCode)\r\n\(additionalHeaders)Content-Length: \(body.utf8.count)\r\nContent-type: text/html\r\n\r\n\(body)" 
    }

    private func buildHTMLBody(content: String) -> String {
        return "<!DOCTYPE html><html><body><h1>\(content)</h1></body></html>"
    }

    private func createTempFile() {
        let filePath = NSURL.fileURL(withPathComponents: ["data.txt"])
        let path: String = filePath!.path
        FileManager.default.createFile(atPath: path, contents: Data(), attributes: nil)
    }

    private func removeTempFile() {
        do {
            let filePath = NSURL.fileURL(withPathComponents: ["data.txt"])
            try FileManager.default.removeItem(at: filePath!) 
        } catch {
            print("Error temp file was not deleted. \(error)")
        }
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
        createTempFile()

        let request = buildRequest(method: "POST", route: "/form", body: "My=Data")

        let parsedRequest = parser.parseRequest(request: request) 
        let _ = response.buildResponse(request: parsedRequest)
        let dataFromFile = readText() 

        XCTAssertEqual("My=Data", dataFromFile)
        removeTempFile()
    }

    func testBuildResponseWillAlterFileWithPutBody() {
        createTempFile()

        let request1 = buildRequest(method: "POST", route: "/form", body: "My=Foo")
        let parsedRequest1 = parser.parseRequest(request: request1) 
        let _ = response.buildResponse(request: parsedRequest1)

        let request2 = buildRequest(method: "PUT", route: "/form", body: "My=Bar")
        let parsedRequest2 = parser.parseRequest(request: request2) 
        let _ = response.buildResponse(request: parsedRequest2)
        
        let dataFromFile = readText()

        XCTAssertEqual("My=Bar", dataFromFile)
        removeTempFile()
    }

    func testBuildResponseWillReturnOptionsResponseForMethodOptionsRoute() {
        let request = buildRequest(method: "OPTIONS", route: "/method_options")
        let expectedResponse = buildResponse(statusCode: status200, additionalHeaders: "Allow: GET,HEAD,POST,OPTIONS,PUT\r\n")

        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

    func testBuildResponseWillReturnOptionsResponseForMethodOptionsRoute2() {
        let request = buildRequest(method: "OPTIONS", route: "/method_options2")
        let expectedResponse = buildResponse(statusCode: status200, additionalHeaders: "Allow: GET,HEAD,OPTIONS\r\n")

        let parsedRequest = parser.parseRequest(request: request)

        XCTAssertEqual(expectedResponse, response.buildResponse(request: parsedRequest))
    }

}
