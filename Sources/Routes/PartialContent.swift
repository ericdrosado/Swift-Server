import Foundation
import Request
import ServerIO

public class PartialContent: Route {

    let documentIO: DocumentIO

    public init(documentIO: DocumentIO) {
        self.documentIO = documentIO
    }

    public func handleRoute(request: Request) -> RouteData {
        let path = "\(request.directory)/partial_content.txt"
        var body = documentIO.readText(path: path)
        let totalBytes = body.utf8.count
        let (rangeStart, rangeEnd) = setContentRange(range: request.headers["Range"]!, totalBytesBaseZero: totalBytes - 1)
        if (request.method != "GET") {
            body = ""
            let responseLineData = packResponseLine(request: request, statusCode: "405", statusMessage: "Method Not Allowed")
            let headersData = packResponseHeaders(body: body)
            return RouteData(responseLine: responseLineData, headers: headersData, body: body)
        } else if (rangeEnd > totalBytes) {
            body = ""
            let contentRange = "bytes */\(totalBytes)" 
            let responseLineData = packResponseLine(request: request, statusCode: "416", statusMessage: "Range Not Satisfiable")
            let headersData = packResponseHeaders(body: body, additionalHeaders: ["Content-Range": contentRange]) 
            return RouteData(responseLine: responseLineData, headers: headersData, body: body)
        } else {
            let totalBytesBaseZero = totalBytes - 1
            let contentRange = "bytes \(rangeStart)-\(rangeEnd)/\(totalBytes)" 
            let startIndex = body.index(body.startIndex, offsetBy: rangeStart)
            let endIndex = body.index(body.endIndex, offsetBy: rangeEnd - totalBytesBaseZero)
            let range = startIndex..<endIndex
            body = String(body[range])
            let responseLineData = packResponseLine(request: request, statusCode: "206", statusMessage: "Partial Content")
            let headersData = packResponseHeaders(body: body, additionalHeaders: ["Content-Range": contentRange]) 
            return RouteData(responseLine: responseLineData, headers: headersData, body: body)
        } 
    }

    private func setContentRange(range: String, totalBytesBaseZero: Int) -> (Int, Int) {
        let rangeDesignation = range.replacingOccurrences(of: " bytes=", with: "") 
        let rangeValues = range.components(separatedBy: CharacterSet.decimalDigits.inverted).filter {$0 != ""}
        var rangeStart: Int
        var rangeEnd: Int 
        if (rangeDesignation.hasPrefix("-")) {
            let totalBytes = totalBytesBaseZero + 1
            rangeStart = totalBytes - Int(rangeValues[0])! 
            rangeEnd = totalBytesBaseZero
        } else if (rangeDesignation.hasSuffix("-")) {
            rangeStart = Int(rangeValues[0])!
            rangeEnd = totalBytesBaseZero
        } else {
            rangeStart = Int(rangeValues[0])!
            rangeEnd = Int(rangeValues[1])!
        }
        return (rangeStart, rangeEnd)
    }

    private func packResponseLine(request: Request, statusCode: String, statusMessage: String) -> [String: String] {
        var responseLineData: [String: String] = [:]
        responseLineData["httpVersion"] = request.httpVersion
        responseLineData["statusCode"] = statusCode
        responseLineData["statusMessage"] = statusMessage
        return responseLineData
    }

    private func packResponseHeaders(body: String, additionalHeaders: [String: String]? = nil) -> [String: String] {
        var headersData: [String: String] = [:]
        headersData["Content-Length"] = String(body.utf8.count)
        headersData["Content-Type"] = "text/plain; charset=utf-8"
        headersData["Allow"] = "GET"
        if (additionalHeaders != nil) {
            for (key, value) in additionalHeaders! {
                headersData[key] = value
            }
        }
        return headersData
    }

}
