import Foundation

public struct Request {

     public let method: String
     public let path: String
     public var queries: [String: String] 
     public var body: [String: String] 
     public var cookie: String  

     public init(method: String, path: String, queries: [String: String] = ["fname": "World"], body: [String: String] = [String(): String()], cookie: String = String()) {
         self.method = method
         self.path = path
         self.queries = queries
         self.body = body
         self.cookie = cookie
     }

}
