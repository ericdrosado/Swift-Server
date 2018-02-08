import Server

let parser = Parser()
let response = Response(parser: parser) 
let port: Int
if CommandLine.argc < 2 {
    port = 5000
} else {
    port = Int(CommandLine.arguments[1])!
}
let server = Server(port: port, response: response)
try server.startServer()
