import XCTest
import Routes
import Server

class ImageTest: XCTestCase {
   
    let image = Image()
    let parser = Parser(directory: "./cob_spec/public")
    let currentDirectoryParser = Parser(directory: "./")

    private func buildRequest(method: String, route: String, body: String = "") -> String {
        return "\(method) \(route) HTTP/1.1\r\nCache-Control: no-cache\r\nConnection: keep-alive\r\n\r\n\(body)"
    }

    private func createTempFile(imageFile: String) {
        let filePath = NSURL.fileURL(withPathComponents: [imageFile])
        let path: String = filePath!.path
        FileManager.default.createFile(atPath: path, contents: Data(), attributes: nil)
    }

    private func removeTempFile(imageFile: String) {
        do {
            let filePath = NSURL.fileURL(withPathComponents: [imageFile])
            try FileManager.default.removeItem(at: filePath!) 
        } catch {
            print("Error temp file was not deleted. \(error)")
        }
    }

    private func buildRouteData(imageFile: String) -> RouteData {
        return RouteData(responseLine: ["httpVersion": "HTTP/1.1", "statusCode": "200", 
                                                                "statusMessage": "OK"], 
                         headers:["Content-Type": imageFile.replacingOccurrences(of:".", with:"/"), "Allow": "GET"],
                         body:"",
                         image: getImage(path: "./\(imageFile)"))
    }
    
    private func getImage(path: String) -> Data? {
        let filePath = NSURL.fileURL(withPathComponents: [path])
        var imageData: Data? = Data()
        do {
            imageData = try Data(contentsOf: filePath!)
        } catch {
            imageData = nil
        }
        return imageData
    }

    func testHandleRouteWillReturnRouteData404ResponseIfImageFileDoesNotExist() {
        let request = buildRequest(method: "GET", route: "/image1.jpeg")
        let parsedRequest = parser.parseRequest(request: request) 
        let routeData = image.handleRoute(request: parsedRequest)

        XCTAssertEqual("404", routeData.responseLine["statusCode"])
    } 

    func testHandleRouteWillReturnRouteDataStatus200ForJPEGImageRoute() {
        let request = buildRequest(method: "GET", route: "/image.jpeg")
        let parsedRequest = parser.parseRequest(request: request) 
        let routeData = image.handleRoute(request: parsedRequest)

        XCTAssertEqual("200", routeData.responseLine["statusCode"])
    }

    func testHandleRouteWillReturnRouteDataStatus200ForGIFImageRoute() {
        let request = buildRequest(method: "GET", route: "/image.gif")
        let parsedRequest = parser.parseRequest(request: request) 
        let routeData = image.handleRoute(request: parsedRequest)

        XCTAssertEqual("200", routeData.responseLine["statusCode"])
    }

    func testHandleRouteWillReturnRouteDataStatus200ForPNGImageRoute() {
        let request = buildRequest(method: "GET", route: "/image.png")
        let parsedRequest = parser.parseRequest(request: request) 
        let routeData = image.handleRoute(request: parsedRequest)

        XCTAssertEqual("200", routeData.responseLine["statusCode"])
    }

    func testHandleRouteWillReturnExpectedRouteDataForJPEGImage() {
        createTempFile(imageFile: "image.jpeg") 
        let request = buildRequest(method: "GET", route: "/image.jpeg")
        let parsedRequest = currentDirectoryParser.parseRequest(request: request) 
        let routeData = image.handleRoute(request: parsedRequest)

        let expectedRouteData = buildRouteData(imageFile: "image.jpeg") 

        XCTAssertTrue(expectedRouteData == routeData)
        removeTempFile(imageFile: "image.jpeg")
    }

    func testHandleRouteWillReturnExpectedRouteDataForGIFImage() {
        createTempFile(imageFile: "image.gif") 
        let request = buildRequest(method: "GET", route: "/image.gif")
        let parsedRequest = currentDirectoryParser.parseRequest(request: request) 
        let routeData = image.handleRoute(request: parsedRequest)

        let expectedRouteData = buildRouteData(imageFile: "image.gif") 

        XCTAssertTrue(expectedRouteData == routeData)
        removeTempFile(imageFile: "image.gif")
    }

    func testHandleRouteWillReturnExpectedRouteDataForPNGImage() {
        createTempFile(imageFile: "image.png") 
        let request = buildRequest(method: "GET", route: "/image.png")
        let parsedRequest = currentDirectoryParser.parseRequest(request: request) 
        let routeData = image.handleRoute(request: parsedRequest)

        let expectedRouteData = buildRouteData(imageFile: "image.png") 

        XCTAssertTrue(expectedRouteData == routeData)
        removeTempFile(imageFile: "image.png")
    }
}

extension RouteData: Equatable {
    static public func == (lhs: RouteData, rhs: RouteData) -> Bool {
        return 
            lhs.responseLine == rhs.responseLine &&
            lhs.headers == rhs.headers &&
            lhs.body == rhs.body &&
            lhs.image == rhs.image
    }
}

