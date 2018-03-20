import Foundation

public struct Request {

     public let method: String
     public let path: String
     public let http: String
     public var queries: [String: String] 
     public var body: [String: String] 
     public var cookie: String  
     public var headers: [String: String]

     public init(method: String, path: String, http: String = String(), queries: [String: String] = ["fname": "World"], body: [String: String] = [String(): String()], cookie: String = String(), headers: [String: String] = [String(): String()]) {
         self.method = method
         self.path = path
         self.http = http
         self.queries = queries
         self.body = body
         self.cookie = cookie
         self.headers = headers
     }

}
