import XCTest
import Routes
import Server

class RootTest: XCTestCase {
    
    let parser = Parser(directory: "./cob_spec/public")
    let privateDirectoryParser = Parser(directory: "./Sources")
    let root = Root()
    
    private func buildRequest(method: String, route: String, body: String = "") -> String {
        return "\(method) \(route) HTTP/1.1\r\nCache-Control: no-cache\r\nConnection: keep-alive\r\n\r\n\(body)"
    }

    func testHandleRouteWillReturn200Status() {
        let request = buildRequest(method: "GET", route: "/")
        let parsedRequest = parser.parseRequest(request: request)

        let routeData = root.handleRoute(request: parsedRequest) 

        XCTAssertEqual("200", routeData.responseLine["statusCode"])
    }

    func testHandleRouteWillReturn403StatusIfDirectoryIsNotPublic() {
        let request = buildRequest(method: "GET", route: "/")
        let parsedRequest = privateDirectoryParser.parseRequest(request: request)

        let routeData = root.handleRoute(request: parsedRequest) 

        XCTAssertEqual("403", routeData.responseLine["statusCode"])
    }

    func testHandleRouteWillReturnForbiddenInTheBodyIfDirectoryIsNotPublic() {
        let request = buildRequest(method: "GET", route: "/")
        let parsedRequest = privateDirectoryParser.parseRequest(request: request)

        let routeData = root.handleRoute(request: parsedRequest) 

        XCTAssertEqual("Forbidden", routeData.body)
    }

}
