import Foundation
import Request
import Routes

public class Responder {

    public init(){}

    public func buildResponse(routeData: RouteData) -> String {
        let responseLine = buildResponseLine(routeData: routeData)
        let headers = arrangeResponseHeaders(routeData: routeData)
        return responseLine + headers + "\r\n\(routeData.body)"
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

