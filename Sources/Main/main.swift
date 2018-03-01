import Foundation
import Server
import Utility

let utility = try CLIUtility()
let port = utility.getPortNumber()

let parser = Parser()
let response = Response() 
let server = Server(parser: parser, port: port, response: response)
try server.startServer()
