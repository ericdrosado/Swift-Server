public struct Request {

     let method: String
     let path: String
     var queries: [String: String] = ["greeting": "World"]

     init(method: String, path: String) {
         self.method = method
         self.path = path
     }

     init(method: String, path: String, queries: [String: String]) {
         self.method = method
         self.path = path
         self.queries = sortHelloQueries(queries: queries)
     }

     func sortHelloQueries(queries: [String: String]) -> [String: String] {
        var sortedQueries = ["fname": "", "mname": "", "lname": ""]
        for (key, value) in queries {
            sortedQueries.updateValue(value, forKey: key)       
        }
        return sortedQueries
     }

}
