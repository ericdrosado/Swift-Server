import Server

let response = Response()
let server = Server(port: 3333, response: response)
try server.startServer()
