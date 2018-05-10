import Foundation
import Request

public class Parser {
    
    private let directory: String

    public init(directory: String) {
        self.directory = directory
    }

    public func parseRequest(request: String) -> Request {
        var (requestLineComponents, requestHeaders, requestBody) = parseRequestMessage(request: request)
        let headers = parseHeaders(requestHeaders: requestHeaders)
        let (path, queries) = parsePath(path: String(requestLineComponents[1]))
        requestLineComponents[1] = path
        let cookie = parseCookie(headers: headers)
        return Request(directory: directory,
                       method: String(requestLineComponents[0]),
                       path: String(requestLineComponents[1]),
                       httpVersion: String(requestLineComponents[2]),
                       queries: queries,
                       body: requestBody,
                       cookie: cookie,
                       headers: headers)
    }

    private func parseRequestMessage(request: String) -> (Array<String>, Array<String>, [String: String]) {
        let majorComponents = request.components(separatedBy: "\r\n\r\n")
        var body = [String(): String()]
        if (majorComponents[1] != "") {
            body = parseBody(rawBody: majorComponents[1])
        }
        let requestComponents = majorComponents[0].components(separatedBy: "\r\n").filter{$0 != ""}
        let requestHeaders: [String] = Array(requestComponents[1..<requestComponents.count]) 
        let requestLineComponents: [String] = Array(requestComponents[0].split(separator: " ").map{String($0)}) 
        return (requestLineComponents, requestHeaders, body)
    }

    private func parseBody(rawBody: String) -> [String: String] {
        var bodyData: [String: String] = [:] 
        if (rawBody.contains("=")) {
            bodyData = parseBodyWithEqualitySign(rawBody: rawBody)
        } else {
            bodyData = ["body": rawBody]
        }
        return bodyData
    }

    private func parseBodyWithEqualitySign(rawBody: String) -> [String: String] {
        var bodyData: [String: String] = [:] 
        let body = rawBody.replacingOccurrences(of: "\"", with: "")  
        let lineData = body.components(separatedBy: "\n")
        for data in lineData {
            let loggedData = data.split(separator: "=")
            bodyData[String(loggedData[0])] = String(loggedData[1])
        }
        return bodyData
    }

    private func parsePath(path: String) -> (String, [String: String]) {
        if (path.contains("?")) {
            let parsedPathWithQueries = path.split(separator: "?").map(String.init) 
            return (parsedPathWithQueries[0], parseAllQueries(parsedQuery: parsedPathWithQueries[1]))
        } else {
            return (path, [:])
        }
    }

    private func parseAllQueries(parsedQuery: String) -> [String: String] {
        var queries: [String: String] = [:]
        let parsedQueries = parsedQuery.split(separator: "&")
        for query in parsedQueries {
            let singleQuery = query.split(separator: "=") 
                queries[String(singleQuery[0])] = String(singleQuery[1]).removingPercentEncoding
        }
        return queries
    }

    private func parseHeaders(requestHeaders: Array<String>) -> [String: String] {
        var headers: [String: String] = [:]
        for header in requestHeaders {
            let singleHeader = header.split(separator: ":")
                headers[String(singleHeader[0])] = String(singleHeader[1])
        }
        return headers
    }

    private func parseCookie(headers: [String:String] ) -> [String: String] {
        if (headers.keys.contains("Cookie")) {
            var cookieCollection: [String: String] = [:]
            let cookieString = headers["Cookie"]! 
            let cookies = cookieString.split(separator: ";")
            for cookie in cookies {
                let parsedCookie = cookie.split(separator: "=")
                cookieCollection[parsedCookie[0].trimmingCharacters(in: .whitespaces)] = parsedCookie[1].trimmingCharacters(in: .whitespaces)
            }
            return cookieCollection
        } else {
            return [:]
        }
    }
}
