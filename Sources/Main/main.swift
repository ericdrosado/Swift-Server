import Foundation
import Server
import Utility

let utility = try CLIUtility()
let port = utility.getPortNumber()

let parser = Parser()
let response = Response(parser: parser) 
let server = Server(port: port, response: response)
try server.startServer()
