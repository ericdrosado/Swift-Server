public struct Request {

     let method: String
     let path: String
     var queries: [String: String] = ["greeting": "World"]
     var cookie: String = String()  

     init(method: String, path: String) {
         self.method = method
         self.path = path
     }

     init(method: String, path: String, queries: [String: String]) {
         self.method = method
         self.path = path
         self.queries = queries
     }

     init(method: String, path: String, cookie: String) {
         self.method = method
         self.path = path
         self.cookie = cookie 
     }

     func sortHelloQueries(queries: [String: String]) -> [String: String] {
        var sortedQueries = ["fname": "", "mname": "", "lname": ""]
        for (key, value) in queries {
            sortedQueries.updateValue(value, forKey: key)       
        }
        return sortedQueries
     }

}
