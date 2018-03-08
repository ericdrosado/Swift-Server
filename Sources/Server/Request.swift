public struct Request {

     let method: String
     let path: String
     var body: String = String()
     var queries: [String: String] = ["greeting": "World"]
     var cookie: String = String()  

     init(method: String, path: String, body: String) {
         self.method = method
         self.path = path
         self.body = body
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
