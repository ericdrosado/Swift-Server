import XCTest
import Response
import Routes
import Server

class ImageTest: XCTestCase {
   
    let image = Image()
    let parser = Parser(directory: "./cob_spec/public")
    let currentDirectoryParser = Parser(directory: "./")

    private func getImage(path: String) -> [UInt8] {
        var imageData = [UInt8]()
        if let data = NSData(contentsOfFile: path) {
            var buffer = [UInt8](repeating: 0, count: data.length)
            data.getBytes(&buffer, length: data.length)
            imageData = buffer
        }
        return imageData 
    }

    func testHandleRouteWillReturnExpectedResponseDataForJPEGImage() {
        let file = "image.jpeg"
        TestHelper().createTempFile(file: file) 
        let request = TestHelper().buildRequest(method: "GET", route: "/image.jpeg")
        let parsedRequest = currentDirectoryParser.parseRequest(request: request) 
        let responseData = image.handleRoute(request: parsedRequest)

        let expectedResponseData = ResponseData(statusLine: HTTPStatus.ok.toStatusLine(version: TestHelper().version), 
                                                headers: Headers().getHeaders(body: "", route: "/image.jpeg"), 
                                                body: "",
                                                image: getImage(path: "/image.jpeg"))  

        XCTAssertTrue(expectedResponseData == responseData)
        TestHelper().deleteTempFile(file: file)
    }

    func testHandleRouteWillReturnExpectedResponseDataForGIFImage() {
        let file = "image.gif"
        TestHelper().createTempFile(file: "image.gif") 
        let request = TestHelper().buildRequest(method: "GET", route: "/image.gif")
        let parsedRequest = currentDirectoryParser.parseRequest(request: request) 
        let responseData = image.handleRoute(request: parsedRequest)

        let expectedResponseData = ResponseData(statusLine: HTTPStatus.ok.toStatusLine(version: TestHelper().version), 
                                                headers: Headers().getHeaders(body: "", route: "/image.gif"), 
                                                body: "",
                                                image: getImage(path: "/image.gif"))  
        
        XCTAssertTrue(expectedResponseData == responseData)
        TestHelper().deleteTempFile(file: file)
    }

    func testHandleRouteWillReturnExpectedResponseDataForPNGImage() {
        let file = "image.png"
        TestHelper().createTempFile(file: file) 
        let request = TestHelper().buildRequest(method: "GET", route: "/image.png")
        let parsedRequest = currentDirectoryParser.parseRequest(request: request) 
        let responseData = image.handleRoute(request: parsedRequest)

        let expectedResponseData = ResponseData(statusLine: HTTPStatus.ok.toStatusLine(version: TestHelper().version), 
                                                headers: Headers().getHeaders(body: "", route: "/image.png"), 
                                                body: "",
                                                image: getImage(path: "/image.png"))  
        
        XCTAssertTrue(expectedResponseData == responseData)
        TestHelper().deleteTempFile(file: file)
    }

}

