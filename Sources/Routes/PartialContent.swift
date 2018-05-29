import Foundation
import Request
import Response
import ServerIO

public class PartialContent: Route {

    let documentIO: DocumentIO

    public init(documentIO: DocumentIO) {
        self.documentIO = documentIO
    }

    public func handleRoute(request: Request) -> ResponseData {
        let path = "\(request.directory)\(request.path)"
        var body = documentIO.readText(path: path)
        let totalBytes = body.utf8.count
        var status = ""
        var contentRange = ""
        if let range = request.headers["Range"] {
            let (rangeStart, rangeEnd) = setContentRange(range: range, totalBytesBaseZero: totalBytes - 1)
            if (rangeEnd > totalBytes) {
                body = ""
                contentRange = "bytes */\(totalBytes)" 
                status = Status.status416(version: request.httpVersion)
            } else {
                let totalBytesBaseZero = totalBytes - 1
                contentRange = "bytes \(rangeStart)-\(rangeEnd)/\(totalBytes)" 
                let startIndex = body.index(body.startIndex, offsetBy: rangeStart)
                let endIndex = body.index(body.endIndex, offsetBy: rangeEnd - totalBytesBaseZero)
                let range = startIndex..<endIndex
                body = String(body[range])
                status = Status.status206(version: request.httpVersion)
            } 
        } else {
            status = Status.status200(version: request.httpVersion)
        }
        return ResponseData(statusLine: status, 
                            headers: Headers().getHeaders(body: body, route: request.path, additionalHeaders: ["Content-Range": contentRange]), 
                            body: body)     
    }

    private func setContentRange(range: String, totalBytesBaseZero: Int) -> (Int, Int) {
        let rangeDesignation = range.replacingOccurrences(of: "bytes=", with: "") 
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

}
