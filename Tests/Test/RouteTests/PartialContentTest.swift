import XCTest
import Response
import Routes
import Server
import ServerIO

class PartialContentTest: XCTestCase {
    
    let parser = Parser(directory: "./cob_spec/public")
    let partialContent = PartialContent(documentIO: DocumentIO())
    let file = "partial_content.txt"

    override func tearDown() {
        TestHelper().deleteTempFile(file: file)
    }

    private func getRangeHeader(range: String) -> String {
        return "Range: bytes=\(range)\r\n"
    }

    func testHandleRouteWillReturnResponseDataForByteRangePrefixedWithDash() {
        TestHelper().createTempFile(file: file)
        let body = " 206.\n"
        let request = TestHelper().buildRequest(method: "GET", route: "/partial_content.txt", body: "", additionalHeader: getRangeHeader(range: "-6"))
        let parsedRequest = parser.parseRequest(request: request)
        let responseData = partialContent.handleRoute(request: parsedRequest)

        let expectedResponseData = ResponseData(statusLine: Status.status206(version: TestHelper().version), 
                                                headers: Headers().getHeaders(body: body, route: "partial_content.txt", additionalHeaders: ["Content-Range": "bytes 71-76/77"]), 
                                                body: body)
                        
        XCTAssertTrue(expectedResponseData == responseData)
    }

    func testHandleRouteWillReturnRouteDataForByteRangeSuffixedWithDash() {
        TestHelper().createTempFile(file: file)
        let body = " is a file that contains text to read part of in order to fulfill a 206.\n"
        let request = TestHelper().buildRequest(method: "GET", route: "/partial_content.txt", body: "", additionalHeader: getRangeHeader(range: "4-"))
        let parsedRequest = parser.parseRequest(request: request)
        let responseData = partialContent.handleRoute(request: parsedRequest)

        let expectedResponseData = ResponseData(statusLine: Status.status206(version: TestHelper().version), 
                                                headers: Headers().getHeaders(body: body, route: "partial_content.txt", additionalHeaders: ["Content-Range": "bytes 4-76/77"]), 
                                                body: body)

        XCTAssertTrue(expectedResponseData == responseData)
    }

    func testHandleRouteWillReturnRouteDataForByteRangeWithStartAndEndIndex() {
        TestHelper().createTempFile(file: "partial_content.txt")
        let body = "This "
        let request = TestHelper().buildRequest(method: "GET", route: "/partial_content.txt", body: "", additionalHeader: getRangeHeader(range: "0-4"))
        let parsedRequest = parser.parseRequest(request: request)
        let responseData = partialContent.handleRoute(request: parsedRequest)

        let expectedResponseData = ResponseData(statusLine: Status.status206(version: TestHelper().version), 
                                                headers: Headers().getHeaders(body: body, route: "partial_content.txt", additionalHeaders: ["Content-Range": "bytes 0-4/77"]), 
                                                body: body)

        XCTAssertTrue(expectedResponseData == responseData)
    }

    func testHandleRouteWillReturnRouteDataForByteRangeOverContentRange() {
        TestHelper().createTempFile(file: "partial_content.txt")
        let request = TestHelper().buildRequest(method: "GET", route: "/partial_content.txt", body: "", additionalHeader: getRangeHeader(range: "75-80"))
        let parsedRequest = parser.parseRequest(request: request)
        let responseData = partialContent.handleRoute(request: parsedRequest)

        let expectedResponseData = ResponseData(statusLine: Status.status416(version: TestHelper().version), 
                                                headers: Headers().getHeaders(body: "", route: "partial_content.txt", additionalHeaders: ["Content-Range": "bytes */77"]), 
                                                body: "")

        XCTAssertTrue(expectedResponseData == responseData)
    }

}
