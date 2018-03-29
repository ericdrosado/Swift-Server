import Foundation
import Request

public class File1: Route {

        public init(){}

        public func handleRoute(request: Request) -> String {
            let body = readText(request: request) 
            var header = buildHeader(statusCode: "200 OK", contentLength: body.utf8.count)
            if (request.method != "GET") {
                header = buildHeader(statusCode: "405 Method Not Allowed", contentLength: body.utf8.count)
            }
            return header + body

        }

        private func buildHeader(statusCode: String, contentLength: Int, additionalHeaders: String = "") -> String {
            return "HTTP/1.1 \(statusCode)\r\n\(additionalHeaders)Content-Length: \(contentLength)\r\nContent-type: text/html\r\n\r\n" 
                        
        }
            
        private func readText(request: Request) -> String {
            let path = NSURL.fileURL(withPathComponents: ["\(request.directory)/file1"])
            var fileData: String = String()
            do {
                fileData = try String(contentsOf: path!, encoding: String.Encoding.utf8) 
            } catch {
                print("Error reading text file. \(error)")
            }
            return fileData
        }

}
