import Server

let parser = Parser()
let response = Response(parser: parser)
let server = Server(port: 5000, response: response)
try server.startServer()
