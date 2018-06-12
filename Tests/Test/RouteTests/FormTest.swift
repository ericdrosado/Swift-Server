import XCTest
import Response
import Routes
import Server
import ServerIO

class FormTest: XCTestCase {

    let form = Form(documentIO: DocumentIO())
    let parser = Parser(directory: "./cob_spec/public")
    
    func testHandleRouteWillReturnPOSTResponseData() {
        let request = TestHelper().buildRequest(method: "POST", route: "/form", body: "My=Data")
        let parsedRequest = parser.parseRequest(request: request) 
        let responseData = form.handleRoute(request: parsedRequest)

        let expectedResponseData = ResponseData(statusLine: HTTPStatus.ok.toStatusLine(version: TestHelper().version), 
                                                headers: Headers().getHeaders(body: "", route: "/form"), 
                                                body: "")

        XCTAssertTrue(expectedResponseData == responseData) 
    }

    func testHandleRouteWillReturnPUTResponseData() {
        let request = TestHelper().buildRequest(method: "PUT", route: "/form", body: "My=Data")
        let parsedRequest = parser.parseRequest(request: request) 
        let responseData = form.handleRoute(request: parsedRequest)

        let expectedResponseData = ResponseData(statusLine: HTTPStatus.ok.toStatusLine(version: TestHelper().version), 
                                                headers: Headers().getHeaders(body: "", route: "/form"), 
                                                body: "")

        XCTAssertTrue(expectedResponseData == responseData) 
    }

    func testHandleRouteWillReturnGETResponseData() {
        let request = TestHelper().buildRequest(method: "GET", route: "/form")
        let parsedRequest = parser.parseRequest(request: request) 
        let responseData = form.handleRoute(request: parsedRequest)

        let expectedResponseData = ResponseData(statusLine: HTTPStatus.ok.toStatusLine(version: TestHelper().version), 
                                                headers: Headers().getHeaders(body: "", route: "/form"), 
                                                body: "")

        XCTAssertTrue(expectedResponseData == responseData) 
    }

    func testHandleRouteWillReturnHEADResponseData() {
        let request = TestHelper().buildRequest(method: "HEAD", route: "/form")
        let parsedRequest = parser.parseRequest(request: request) 
        let responseData = form.handleRoute(request: parsedRequest)

        let expectedResponseData = ResponseData(statusLine: HTTPStatus.ok.toStatusLine(version: TestHelper().version), 
                                                headers: Headers().getHeaders(body: "", route: "/form"), 
                                                body: "")

        XCTAssertTrue(expectedResponseData == responseData) 
    }

}
