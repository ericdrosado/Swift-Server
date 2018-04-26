import Foundation
import Routes
import Server
import Utility

let utility = try CLIUtility()
let port = utility.getPortNumber()
let directory = utility.getDirectory()

let files = ["data.txt", "requestLog.txt"]
for file in files {
    let filePath = NSURL.fileURL(withPathComponents: [file])
    let path: String = filePath!.path
    if (!FileManager.default.fileExists(atPath: path)) {
        FileManager.default.createFile(atPath: path, contents: Data(), attributes: nil)
    }
}

let routes = Routes()
let fourOhFour = FourOhFour()
let router = Router(routes: routes.routes, fourOhFour: fourOhFour)

let responder = Responder()
if (directory == nil) {
    print("Error: No Public Directory Found")
} else {
    let server = Server(parser: Parser(directory: directory!), port: port, responder: responder, router: router)
    print("Your server is running on port: \(port) with the following directory: \(directory!)")
    try server.startServer()
}
