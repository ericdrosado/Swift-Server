import XCTest
import Response
import Routes
import Server
import ServerIO

class PatchContentTest: XCTestCase {

    let patchContent = PatchContent(documentIO: DocumentIO())
    let parser = Parser(directory: "./cob_spec/public")
    let file = "patch-content"
    let path = "./cob_spec/public/patch-content"

    override func tearDown() {
        TestHelper().deleteTempFile(file: path)
    }

    func testHandleRouteWillReturnExpectedResponseDataForGetRequest() {
        let body = "default content"
        let request = TestHelper().buildRequest(method: "GET", route: "/\(file)", body: body)
        let parsedRequest = parser.parseRequest(request: request)

        TestHelper().createTempFile(file: path)
        DocumentIO().writePlainText(text: body, path: path)
        let responseData = patchContent.handleRoute(request: parsedRequest)

        let expectedResponseData = ResponseData(statusLine: HTTPStatus.ok.toStatusLine(version: TestHelper().version), 
                                                headers: Headers().getHeaders(body: body, route: "/\(file)"), 
                                                body: body)

        XCTAssertTrue(expectedResponseData == responseData)
    }

    func testHandleRouteWillReturnExpectedResponseDataForPatchRequest() {
        let body = "patched content"
        let request = TestHelper().buildRequest(method: "PATCH", route: "/\(file)", body: body)
        let parsedRequest = parser.parseRequest(request: request)

        TestHelper().createTempFile(file: path)
        DocumentIO().writePlainText(text: body, path: path)
        let responseData = patchContent.handleRoute(request: parsedRequest)

        let expectedResponseData = ResponseData(statusLine: HTTPStatus.noContent.toStatusLine(version: TestHelper().version), 
                                                headers: Headers().getHeaders(body: body, route: "/\(file)"), 
                                                body: body)

        XCTAssertTrue(expectedResponseData == responseData)
    }

}
