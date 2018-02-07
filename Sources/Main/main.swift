import Server

let parser = Parser()
let response = Response(parser: parser)
let server: Server
if CommandLine.argc < 2 {
    server = Server(port: 5000, response: response)
} else {
    server = Server(port: Int(CommandLine.arguments[1])!, response: response)
}

try server.startServer()
