import Foundation
import Request

public class PartialContent: Route {

    public init(){}

    public func handleRoute(request: Request) -> RouteData {
        var body = readText(request: request)
        var responseLineData = packResponseLine(request: request, statusCode: "200", statusMessage: "OK")
        var headersData = packResponseHeaders(body: body) 
        let rangeValues = request.headers["Range"]!.components(separatedBy: CharacterSet.decimalDigits.inverted).filter {$0 != ""}
        let totalBytes = body.utf8.count
        let totalBytesBaseZero = body.utf8.count - 1
        var rangeStart = body.utf8.count - Int(rangeValues[0])!  
        var startIndex = body.index(body.startIndex, offsetBy: rangeStart)
        let endIndex = body.index(body.endIndex, offsetBy: 0)
        var range = startIndex..<endIndex
        if (request.method != "GET") {
            body = ""
            responseLineData = packResponseLine(request: request, statusCode: "405", statusMessage: "Method Not Allowed")
            headersData = packResponseHeaders(body: body) 
        } else if (request.headers["Range"]!.replacingOccurrences(of: " bytes=", with: "").hasPrefix("-")) {
            let contentRange = "bytes \(rangeStart)-\(totalBytesBaseZero)/\(totalBytes)" 
            body = String(body[range])
            responseLineData = packResponseLine(request: request, statusCode: "206", statusMessage: "Partial Content")
            headersData = packResponseHeaders(body: body, additionalHeaders: ["Content-Range": contentRange]) 
        } else if (request.headers["Range"]!.replacingOccurrences(of: " bytes=", with: "").hasSuffix("-")) {
            rangeStart = Int(rangeValues[0])!  
            let contentRange = "bytes \(rangeStart)-\(totalBytesBaseZero)/\(totalBytes)" 
            startIndex = body.index(body.startIndex, offsetBy: rangeStart)
            range = startIndex..<endIndex
            body = String(body[range])
            responseLineData = packResponseLine(request: request, statusCode: "206", statusMessage: "Partial Content")
            headersData = packResponseHeaders(body: body, additionalHeaders: ["Content-Range": contentRange]) 
        } else {
            let rangeStart = Int(rangeValues[0])  
            let rangeEnd = Int(rangeValues[1])
            var contentRange = "bytes \(rangeStart!)-\(rangeEnd!)/\(totalBytes)" 
            if  (rangeEnd! > totalBytesBaseZero) {
                body = ""
                contentRange = "bytes */\(totalBytes)" 
                responseLineData = packResponseLine(request: request, statusCode: "416", statusMessage: "Range Not Satisfiable")
                headersData = packResponseHeaders(body: body, additionalHeaders: ["Content-Range": contentRange]) 
                return RouteData(responseLine: responseLineData, headers: headersData, body: body) 
            }
            let startIndex = body.index(body.startIndex, offsetBy: rangeStart!)
            let endIndex = body.index(body.endIndex, offsetBy: rangeEnd! - totalBytesBaseZero)
            let range = startIndex..<endIndex
            body = String(body[range])
            responseLineData = packResponseLine(request: request, statusCode: "206", statusMessage: "Partial Content")
            headersData = packResponseHeaders(body: body, additionalHeaders: ["Content-Range": contentRange]) 
        } 
        return RouteData(responseLine: responseLineData, headers: headersData, body: body) 
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

    private func readText(request: Request) -> String {
        let path = NSURL.fileURL(withPathComponents: ["\(request.directory)/partial_content.txt"])
        var fileData: String = String()
        do {
            fileData = try String(contentsOf: path!, encoding: String.Encoding.utf8) 
        } catch {
            print("Error reading text file. \(error)")
        }
        return fileData
    }
}
