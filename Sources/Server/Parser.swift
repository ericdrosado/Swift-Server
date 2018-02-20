import Foundation

public class Parser {

    public init(){}

    public func parseRequest(request: String) -> Request {
        var (requestComponents, requestHeaders) = parseRequest(request: request)
        let headers = parseHeaders(requestHeaders: requestHeaders)
        if (requestComponents[1].contains("?")) {
            let parsedPathWithQueries = parsePath(path: String(requestComponents[1]))
            let queries = parseAllQueries(parsedQuery: parsedPathWithQueries[1])
            return Request(method: String(requestComponents[0]), path: parsedPathWithQueries[0], queries: queries) 
        } else if (headers.keys.contains("Cookie")) {
            let cookie = parseCookie(headers: headers)
            return Request(method: String(requestComponents[0]), path: String(requestComponents[1]), cookie: cookie["type"]!) 
        } else {
            return Request(method: String(requestComponents[0]), path: String(requestComponents[1]))
        }
    }

    private func parseRequest(request: String) -> (Array<Substring>, Array<String>) {
        var requestAndHeaders = request.components(separatedBy: "\r\n")
        let requestComponents = requestAndHeaders[0].split(separator: " ")
        let requestHeaders = parseNonHeaderComponents(requestWithHeaders: requestAndHeaders)
        return (requestComponents, requestHeaders)
    }

    private func parseNonHeaderComponents(requestWithHeaders: Array<String>) -> (Array<String>) {
        var headers = requestWithHeaders
        headers.removeFirst(1)
        headers.removeLast(2) 
        return headers 
    }

    private func parsePath(path: String) -> Array<String> {
        let parsedPathWithQueries = path.split(separator: "?").map(String.init) 
        return parsedPathWithQueries
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
