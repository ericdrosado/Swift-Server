import Server

let parser = Parser()
let response = Response(parser: parser)

if CommandLine.argc < 2 {
    let server = Server(port: 5000, response: response)
    try server.startServer()
} else {
    let server = Server(port: Int(CommandLine.arguments[1])!, response: response)
    try server.startServer()
}
