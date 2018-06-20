import Foundation
import CobSpec
import Server

public class Main {

    public init(){}

    public func prepareAppForServer() throws {
        let utility = try CLIUtility()
        let port = utility.getPortNumber()
        let directory = utility.getDirectory()
        createWritableFiles()

        let routes = getRoutes()

        if (directory == nil) {
            print("Error: No Public Directory Found")
        } else {
            let server = Server(parser: Parser(directory: directory!), port: port, responder: Responder(), router: Router(routes: routes))
            print("Your server is running on port: \(port) with the following directory: \(directory!)")
            try server.startServer()
        }
    }

    private func createWritableFiles() {
        let files = ["data.txt", "requestLog.txt"]
        for file in files {
            let filePath = NSURL.fileURL(withPathComponents: [file])
            let path: String = filePath!.path
            if (!FileManager.default.fileExists(atPath: path)) {
                FileManager.default.createFile(atPath: path, contents: Data(), attributes: nil)
            }
        }
    }
    
    private func getRoutes() -> [String: [String: Any]] {
        let allRoutes = Routes.allValues
        var routes: [String: [String: Any]] = ["":["":""]]
        for route in allRoutes {
            routes[route.rawValue] = ["routeHandler": route.routes, "allowedActions": route.routeActions]
        }
        return routes
    }

}

try Main().prepareAppForServer()
