import Foundation
import Request

public class Image: Route {

    let fourOhFour: FourOhFour
    
    public init() {
        self.fourOhFour = FourOhFour()
    }

    public func handleRoute(request: Request) -> RouteData {
        let body = "" 
        let image = getImage(request: request) 
        if (image == nil) {
            return fourOhFour.handleRoute(request: request)
        }
        let responseLineData = packResponseLine(request: request) 
        let headersData = packResponseHeaders(body: body, request: request)
        return RouteData(responseLine: responseLineData, headers: headersData, body: body, image: image)
    }
    
    private func getImage(request: Request) -> [UInt8]? {
        let filePath = "\(request.directory)\(request.path)"
        if let data = NSData(contentsOfFile: filePath) {
            var buffer = [UInt8](repeating: 0, count: data.length)
            data.getBytes(&buffer, length: data.length)
            return buffer 
        } else {
            return nil
        }
    }

    private func packResponseLine(request: Request) -> [String: String] {
        var responseLineData: [String: String] = [:]
        responseLineData["httpVersion"] = request.httpVersion
        responseLineData["statusCode"] = "200"
        responseLineData["statusMessage"] = "OK"
        return responseLineData
    }

    private func packResponseHeaders(body: String, request: Request) -> [String: String] {
        var headersData: [String: String] = [:]
        headersData["Content-Type"] = getContentType(request: request)
        headersData["Allow"] = "GET" 
        return headersData
    }
    
    private func getContentType(request: Request) -> String {
        return request.path.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ".", with: "/")
    }

}
