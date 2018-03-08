import Foundation

public class Parser {

    public init(){}

    public func parseRequest(request: String) -> Request {
        var (requestLineComponents, requestHeaders, requestBody) = parseRequestMessage(request: request)
        let headers = parseHeaders(requestHeaders: requestHeaders)
        if (requestLineComponents[1].contains("?")) {
            let parsedPathWithQueries = parsePath(path: String(requestLineComponents[1]))
            let queries = parseAllQueries(parsedQuery: parsedPathWithQueries[1])
            return Request(method: String(requestLineComponents[0]), path: parsedPathWithQueries[0], queries: queries) 
        } else if (headers.keys.contains("Cookie")) {
            let cookie = parseCookie(headers: headers)
            return Request(method: String(requestLineComponents[0]), path: String(requestLineComponents[1]), cookie: cookie["type"]!) 
        } else {
            return Request(method: String(requestLineComponents[0]), path: String(requestLineComponents[1]), body: requestBody)
        }
    }

    private func parseRequestMessage(request: String) -> (Array<String>, Array<String>, String) {
        let majorComponents = request.components(separatedBy: "\r\n\r\n")
        let body = majorComponents[1].replacingOccurrences(of: "\"", with: "") 
        let requestComponents = majorComponents[0].components(separatedBy: "\r\n").filter{$0 != ""}
        let requestHeaders: [String] = Array(requestComponents[1..<requestComponents.count]) 
        let requestLineComponents: [String] = Array(requestComponents[0].split(separator: " ").map{String($0)}) 
        return (requestLineComponents, requestHeaders, body)
    }

    private func parsePath(path: String) -> Array<String> {
        return path.split(separator: "?").map(String.init) 
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
        var cookie: [String: String] = [:]
        let cookieString = headers["Cookie"]! 
        let parsedCookie = cookieString.split(separator: "=")
        cookie[String(parsedCookie[0]).trimmingCharacters(in: .whitespaces)] = String(parsedCookie[1]).trimmingCharacters(in: .whitespaces)
        return cookie
    }

}
