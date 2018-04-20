import XCTest
import Routes
import Server
import ServerIO

class FormTest: XCTestCase {

    let form = Form(fileIO: FileIO())
    let parser = Parser(directory: "./cob_spec/public")

    private func buildRequest(method: String, route: String, body: String = "") -> String {
        return "\(method) \(route) HTTP/1.1\r\nCache-Control: no-cache\r\nConnection: keep-alive\r\n\r\n\(body)"
    }

    private func buildRouteData(statusCode: String, statusMessage: String) -> RouteData {
        return RouteData(responseLine: ["httpVersion": "HTTP/1.1", "statusCode": statusCode, "statusMessage": statusMessage], 
                         headers:["Content-Length": "0", "Content-Type": "text/plain; charset=utf-8"],
                         body:"")
    }
    
    func testHandleRouteWillReturnPOSTRouteData() {
        let request = buildRequest(method: "POST", route: "/form", body: "My=Data")
        let parsedRequest = parser.parseRequest(request: request) 
        let routeData = form.handleRoute(request: parsedRequest)

        let expectedRouteData = buildRouteData(statusCode: "200", statusMessage: "OK") 

        XCTAssertTrue(expectedRouteData == routeData) 
    }

    func testHandleRouteWillReturnPUTRouteData() {
        let request = buildRequest(method: "PUT", route: "/form", body: "My=Data")
        let parsedRequest = parser.parseRequest(request: request) 
        let routeData = form.handleRoute(request: parsedRequest)

        let expectedRouteData = buildRouteData(statusCode: "200", statusMessage: "OK") 

        XCTAssertTrue(expectedRouteData == routeData) 
    }

    func testHandleRouteWillReturn405StatusCodeWithGetRequest() {
        let request = buildRequest(method: "GET", route: "/form", body: "My=Data")
        let parsedRequest = parser.parseRequest(request: request) 
        let routeData = form.handleRoute(request: parsedRequest)

        XCTAssertEqual("405", routeData.responseLine["statusCode"]) 
    }

    func testHandleRouteWillReturn405StatusCodeWithHeadRequest() {
        let request = buildRequest(method: "HEAD", route: "/form", body: "My=Data")
        let parsedRequest = parser.parseRequest(request: request) 
        let routeData = form.handleRoute(request: parsedRequest)

        XCTAssertEqual("405", routeData.responseLine["statusCode"]) 
    }

}
