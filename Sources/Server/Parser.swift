import Foundation

public class Parser {
    
    public var queries: [String:String]

    public init() {
        self.queries = ["fname": "", "mname": "", "lname": ""]
    }

   public func setDefaultQueries(){
        queries.updateValue("", forKey: "fname")
        queries.updateValue("", forKey: "mname")
        queries.updateValue("", forKey: "lname")
   }

   public func parseRequest(request: String) -> (String, String) {
        let requestComponent = request.components(separatedBy: " ")
            if (requestComponent[1].contains("?")) {
                let path = parsePathForQueries(path: requestComponent[1])
                return (requestComponent[0], path) 
            }
        queries.updateValue("World", forKey: "fname")
        return (requestComponent[0], requestComponent[1])
   }

   private func parsePathForQueries(path: String) -> String {
        let parsedQueries = path.split(separator: "?") 
        parseAllQueries(parsedQuery: String(parsedQueries[1]))
        return String(parsedQueries[0])
   }

   private func parseAllQueries(parsedQuery: String) {
        let parsedQueries = parsedQuery.split(separator: "&")
        for query in parsedQueries {
            let singleQuery = query.split(separator: "=") 
            queries.updateValue(String(singleQuery[1]), forKey: String(singleQuery[0]))
        }
   }

}
