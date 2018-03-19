import Foundation
import Routes
import Server
import Utility

let utility = try CLIUtility()
let port = utility.getPortNumber()

let filePath = NSURL.fileURL(withPathComponents: ["data.txt"])
let path: String = filePath!.path
if (!FileManager.default.fileExists(atPath: path)) {
   FileManager.default.createFile(atPath: path, contents: Data(), attributes: nil)
}

let routes: [String: Route] = ["/": Root(), "/hello": Hello(), "/tea": Tea(), "/coffee": Coffee()]
let router = Router(routes: routes)
let response = Response(router: router)

let server = Server(parser: Parser(), port: port, response: response, router: router)
try server.startServer()
