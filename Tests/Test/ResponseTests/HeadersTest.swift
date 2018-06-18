import XCTest
import Server 

class HeadersTest: XCTestCase {

    let headers = Headers()

    func testGetHeadersWillReturnTheExpectedHeadersForTheCoffeeRoute() {
        let expectedHeaders = ["Content-Length": "12", "Content-Type": "text/html; charset=utf-8"]

        let actualHeaders = headers.getHeaders(body: "I'm a teapot", route: "/coffee")

        XCTAssertEqual(expectedHeaders, actualHeaders)
    }

    func testGetHeadersWillReturnTheExpectedHeadersForTheImageGifRoute() {
        let expectedHeaders = ["Content-Type": "image/gif"]

        let actualHeaders = headers.getHeaders(body: "", route: "/image.gif")

        XCTAssertEqual(expectedHeaders, actualHeaders)
    }

    func testGetHeadersWillReturnTheExpectedHeadersForTheCookieRoute() {
        let expectedHeaders = ["Content-Length": "3", "Content-Type": "text/html; charset=utf-8", "Set-Cookie": "chocolate"]

        let actualHeaders = headers.getHeaders(body: "Eat", route: "/cookie", additionalHeaders: ["Set-Cookie": "chocolate"])

        XCTAssertEqual(expectedHeaders, actualHeaders)
    }

    func testGetHeadersWillReturnTheExpectedHeadersForTheTextFileRoute() {
        let expectedHeaders = ["Content-Length": "0", "Content-Type": "text/plain; charset=utf-8"]

        let actualHeaders = headers.getHeaders(body: "", route: "/text-file.txt")

        XCTAssertEqual(expectedHeaders, actualHeaders)
    }

}
