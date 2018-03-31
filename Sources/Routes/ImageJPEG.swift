import Foundation
import Request

public class ImageJPEG: Route {
    
    public init() {}

    public func handleRoute(request: Request) -> RouteData {
        let body = "" 
        let image = getImage(request: request) 
        let responseLineData = packResponseLine(request: request) 
        let headersData = packResponseHeaders(body: body, request: request)
        return RouteData(responseLine: responseLineData, headers: headersData, body: body, image: image)
    }
    
    private func getImage(request: Request) -> Data {
        let filePath = NSURL.fileURL(withPathComponents: ["\(request.directory)/image.jpeg"])
        var imageData = Data()
        do {
            imageData = try Data(contentsOf: filePath!)
        } catch {
            print("Cannot convert .jpeg image.")
        }
        return imageData
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
        headersData["Content-Type"] = "image/jpeg"
        headersData["Allow"] = "GET" 
        return headersData
    }

}
