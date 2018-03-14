import Foundation
import Server
import Utility

let utility = try CLIUtility()
let port = utility.getPortNumber()

let filePath = NSURL.fileURL(withPathComponents: ["data.txt"])
let path: String = filePath!.path
if (!FileManager.default.fileExists(atPath: path)) {
   FileManager.default.createFile(atPath: path, contents: Data(), attributes: nil)
}

let parser = Parser()
let response = Response() 
let server = Server(parser: parser, port: port, response: response)
try server.startServer()
