import Foundation

public class Parser {
    
   public init(){}

   public func parseRequest(request: String) -> Request {
        let requestComponent = request.components(separatedBy: " ")
            if (requestComponent[1].contains("?")) {
                let parsedPathWithQueries = parsePath(path: requestComponent[1])
                let queries = parseAllQueries(parsedQuery: parsedPathWithQueries[1])
                return Request(method: requestComponent[0], path: parsedPathWithQueries[0], queries: queries) 
            }
        return Request(method: requestComponent[0], path: requestComponent[1])
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
            queries[String(singleQuery[0])] = String(singleQuery[1])
        }
        return queries
   }

}
