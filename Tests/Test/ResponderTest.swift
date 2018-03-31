import XCTest
import Routes
import Server

class ResponderTest: XCTestCase {
    
    let parser = Parser(directory: "./cob_spec/public")
    static let routes = Routes.routes
    static let fourOhFour = FourOhFour()
    let router = Router(routes: routes, fourOhFour: fourOhFour)
    let responder = Responder()
    let status200 = "200 OK"
    let status404 = "404 Not Found"
    let queries = ["Person", "John", "Doe"]
                           
    private func buildRequest(method: String, route: String, body: String = "") -> String {
        return "\(method) \(route) HTTP/1.1\r\nCache-Control: no-cache\r\nConnection: keep-alive\r\n\r\n\(body)"
    }

    private func buildResponse(statusCode: String, additionalHeaders: String = "", body: String = "") -> String {
        return "HTTP/1.1 \(statusCode)\r\nContent-Type: text/html\r\nContent-Length: \(body.utf8.count)\r\n\(additionalHeaders)\r\n\r\n\(body)" 
    }

    private func convertResponseToBytes(response: String) -> Data {
        let buffer = Data(response.utf8)
        return buffer     
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
        let stringResponse = buildResponse(statusCode: status200, additionalHeaders: "Allow: GET, HEAD, OPTIONS")
        let expectedResponse = convertResponseToBytes(response: stringResponse) 

        let parsedRequest = parser.parseRequest(request: request)
        let routeData = router.handleRoute(request: parsedRequest)

        XCTAssertEqual(expectedResponse, responder.buildResponse(routeData: routeData))
    }

    func testBuildResponseWillReturn404ResponseWithGET() {
        let request = buildRequest(method: "GET", route: "/fooBar")
        let stringResponse = buildResponse(statusCode: status404, additionalHeaders: "Allow: GET, HEAD, OPTIONS", body: "Not Found")        
        let expectedResponse = convertResponseToBytes(response: stringResponse) 

        let parsedRequest = parser.parseRequest(request: request)
        let routeData = router.handleRoute(request: parsedRequest)

        XCTAssertEqual(expectedResponse, responder.buildResponse(routeData: routeData))
    }

    func testBuildResponseWillReturn404ResponseWithHEAD() {
        let request = buildRequest(method: "HEAD", route: "/foobar")
        let stringResponse = buildResponse(statusCode: status404, additionalHeaders: "Allow: GET, HEAD, OPTIONS") 
        let expectedResponse = convertResponseToBytes(response: stringResponse) 

        let parsedRequest = parser.parseRequest(request: request)
        let routeData = router.handleRoute(request: parsedRequest)

        XCTAssertEqual(expectedResponse, responder.buildResponse(routeData: routeData))
    }

    func testBuildResponseWillReturnGETResponseWithQuery() {
        let request = buildRequest(method: "GET", route: "/hello?fname=\(queries[0])")
        let expectedResponse = buildResponse(statusCode: status200, additionalHeaders: "Allow: GET, HEAD, OPTIONS", body: "Hello \(queries[0])")

        let parsedRequest = parser.parseRequest(request: request)
        let routeData = router.handleRoute(request: parsedRequest)

        XCTAssertEqual(expectedResponse, responder.buildResponse(routeData: routeData))
    }

    func testBuildResponseWillReturnGETResponseWith2Queries() {
        let request = buildRequest(method: "GET", route: "/hello?mname=\(queries[0])&lname=\(queries[1])")
        let expectedResponse = buildResponse(statusCode: status200, additionalHeaders: "Allow: GET, HEAD, OPTIONS", body: "Hello \(queries[0]) \(queries[1])")

        let parsedRequest = parser.parseRequest(request: request)
        let routeData = router.handleRoute(request: parsedRequest)

        XCTAssertEqual(expectedResponse, responder.buildResponse(routeData: routeData))
    }

    func testBuildResponseWillReturnGETResponseWith3Queries() {
        let request = buildRequest(method: "GET", route: "/hello?fname=\(queries[0])&lname=\(queries[2])&mname=\(queries[1])")
        let expectedResponse = buildResponse(statusCode: status200, additionalHeaders: "Allow: GET, HEAD, OPTIONS", body: "Hello \(queries[0]) \(queries[1]) \(queries[2])")

        let parsedRequest = parser.parseRequest(request: request)
        let routeData = router.handleRoute(request: parsedRequest)

        XCTAssertEqual(expectedResponse, responder.buildResponse(routeData: routeData))
    }

    func testBuildResponseWillReturnProperGETResponseWithQueryAfterAnInitialRequest() {
        let request1 = buildRequest(method: "GET", route: "/hello?fname=Person")
        let request2 = buildRequest(method: "GET", route: "/hello") 
        let expectedResponse = buildResponse(statusCode: status200, additionalHeaders: "Allow: GET, HEAD, OPTIONS", body: "Hello World")

        let parsedRequest1 = parser.parseRequest(request: request1)
        let routeData = router.handleRoute(request: parsedRequest1)
        let _: String = responder.buildResponse(routeData: routeData)
        let parsedRequest2 = parser.parseRequest(request: request2)
        let routeData2 = router.handleRoute(request: parsedRequest2)

        XCTAssertEqual(expectedResponse, responder.buildResponse(routeData: routeData2))
    }

    func testBuildResponseWillReturn418Response() {
        let request = buildRequest(method: "GET", route: "/coffee")
        let expectedResponse = buildResponse(statusCode: "418 I'm a teapot", additionalHeaders: "Allow: GET, HEAD, OPTIONS", body: "I'm a teapot")

        let parsedRequest = parser.parseRequest(request: request)
        let routeData = router.handleRoute(request: parsedRequest)

        XCTAssertEqual(expectedResponse, responder.buildResponse(routeData: routeData))
    }

    func testBuildResponseWillDecodeOperators() {
        let request = buildRequest(method: "GET", route: "/parameters?variable_1=Operators%20%3C%2C%20%3E%2C%20%3D%2C%20!%3D%3B%20%2B%2C%20-%2C%20*%2C%20%26%2C%20%40%2C%20%23%2C%20%24%2C%20%5B%2C%20%5D%3A%20%22is%20that%20all%22%3F")
        let expectedResponse = buildResponse(statusCode: status200, additionalHeaders: "Allow: GET, HEAD, OPTIONS", body: "variable_1 = Operators <, >, =, !=; +, -, *, &, @, #, $, [, ]: \"is that all\"?")
        let parsedRequest = parser.parseRequest(request: request)
        let routeData = router.handleRoute(request: parsedRequest)

        XCTAssertEqual(expectedResponse, responder.buildResponse(routeData: routeData))
    }

    func testBuildResponseWillReturnPOSTResponse() {
        let request = buildRequest(method: "POST", route: "/form", body: "My=Data")
        let expectedResponse = buildResponse(statusCode: status200, additionalHeaders: "Allow: GET, HEAD, PUT, POST, OPTIONS")

        let parsedRequest = parser.parseRequest(request: request)
        let routeData = router.handleRoute(request: parsedRequest)

        XCTAssertEqual(expectedResponse, responder.buildResponse(routeData: routeData))
    }

    func testBuildResponseWillReturnPUTResponse() {
        let request = buildRequest(method: "PUT", route: "/form", body: "My=Data")
        let expectedResponse = buildResponse(statusCode: status200, additionalHeaders: "Allow: GET, HEAD, PUT, POST, OPTIONS")

        let parsedRequest = parser.parseRequest(request: request)
        let routeData = router.handleRoute(request: parsedRequest)

        XCTAssertEqual(expectedResponse, responder.buildResponse(routeData: routeData))
    }

    func testBuildResponseWillPostBodyToFile() {
        createTempFile()

        let request = buildRequest(method: "POST", route: "/form", body: "My=Data")

        let parsedRequest = parser.parseRequest(request: request) 
        let routeData = router.handleRoute(request: parsedRequest)
        let _: String = responder.buildResponse(routeData: routeData)
        let dataFromFile = readText() 

        XCTAssertEqual("My=Data", dataFromFile)
        removeTempFile()
    }

    func testBuildResponseWillAlterFileWithPutBody() {
        createTempFile()

        let request1 = buildRequest(method: "POST", route: "/form", body: "My=Foo")
        let parsedRequest1 = parser.parseRequest(request: request1) 
        let routeData = router.handleRoute(request: parsedRequest1)
        let _: String = responder.buildResponse(routeData: routeData)

        let request2 = buildRequest(method: "PUT", route: "/form", body: "My=Bar")
        let parsedRequest2 = parser.parseRequest(request: request2) 
        let routeData2 = router.handleRoute(request: parsedRequest2)
        let _: String = responder.buildResponse(routeData: routeData2)
        
        let dataFromFile = readText()

        XCTAssertEqual("My=Bar", dataFromFile)
        removeTempFile()
    }

    func testBuildResponseWillReturnOptionsResponseForMethodOptionsRoute() {
        let request = buildRequest(method: "OPTIONS", route: "/method_options")
        let expectedResponse = buildResponse(statusCode: status200, additionalHeaders: "Allow: GET,HEAD,POST,OPTIONS,PUT")

        let parsedRequest = parser.parseRequest(request: request)
        let routeData = router.handleRoute(request: parsedRequest)

        XCTAssertEqual(expectedResponse, responder.buildResponse(routeData: routeData))
    }

    func testBuildResponseWillReturnOptionsResponseForMethodOptionsRoute2() {
        let request = buildRequest(method: "OPTIONS", route: "/method_options2")
        let expectedResponse = buildResponse(statusCode: status200, additionalHeaders: "Allow: GET,OPTIONS,HEAD")

        let parsedRequest = parser.parseRequest(request: request)
        let routeData = router.handleRoute(request: parsedRequest)

        XCTAssertEqual(expectedResponse, responder.buildResponse(routeData: routeData))
    }

}
