import Foundation
import Request
import Routes

public class Responder {

    public init(){}

    public func buildResponse(routeData: RouteData) -> Data {
        let responseLine = buildResponseLine(routeData: routeData)
        let headers = arrangeResponseHeaders(routeData: routeData)
        let response = responseLine + headers + "\r\n\(routeData.body)"
        return convertResponseToBytes(response: response, routeData: routeData)
    }

    private func convertResponseToBytes(response: String, routeData: RouteData) -> Data {
        var buffer = Data(response.utf8)
        if (routeData.image != nil) {
            buffer += routeData.image!
        }
        return buffer     
    }

    private func buildResponseLine(routeData: RouteData) -> String {
        return "\(routeData.responseLine["httpVersion"]!) \(routeData.responseLine["statusCode"]!) \(routeData.responseLine["statusMessage"]!)\r\n"
    }

    private func arrangeResponseHeaders(routeData: RouteData) -> String {
        var arrangedHeaders = ""
        for (key, value) in routeData.headers {
            arrangedHeaders += "\(key): \(value)\r\n"
        }
        return arrangedHeaders
    }
 
}

