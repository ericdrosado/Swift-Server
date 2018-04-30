import XCTest
import Response
import Routes
import Server

class RootTest: XCTestCase {
    
    let parser = Parser(directory: "./cob_spec/public")
    let privateDirectoryParser = Parser(directory: "./Sources")
    let root = Root()
    let version = "HTTP/1.1"

    func testHandleRouteWillReturn200Status() {
        let request = TestHelper().buildRequest(method: "GET", route: "/")
        let parsedRequest = parser.parseRequest(request: request)

        let responseData = root.handleRoute(request: parsedRequest) 

        XCTAssertEqual(Status.status200(version: version), responseData.statusLine)
    }

    func testHandleRouteWillReturn403StatusIfDirectoryIsNotPublic() {
        let request = TestHelper().buildRequest(method: "GET", route: "/")
        let parsedRequest = privateDirectoryParser.parseRequest(request: request)

        let responseData = root.handleRoute(request: parsedRequest) 

        XCTAssertEqual(Status.status403(version: version), responseData.statusLine)
    }

}
