public struct Request {

     let method: String
     let path: String
     var queries: [String: String] = ["fname": "World"]
     var body: [String: String] = [String(): String()]
     var cookie: String = String()  

     init(method: String, path: String, body: [String: String]) {
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

}
