import XCTest
import Routes
import Server

class ImageTest: XCTestCase {
   
    let image = Image()
    let parser = Parser(directory: "./cob_spec/public")

    private func buildRequest(method: String, route: String, body: String = "") -> String {
        return "\(method) \(route) HTTP/1.1\r\nCache-Control: no-cache\r\nConnection: keep-alive\r\n\r\n\(body)"
    }

    func testHandleRouteWillReturn404ResponseIfImageFileDoesNotExist() {
        let request = buildRequest(method: "GET", route: "/image1.jpeg")
        let parsedRequest = parser.parseRequest(request: request) 
        let routeData = image.handleRoute(request: parsedRequest)

        XCTAssertEqual("404", routeData.responseLine["statusCode"])
    } 
}
