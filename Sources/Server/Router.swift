import Foundation
import Request
import Routes

public class Router {

    let routes: [String: Route]

    public init(routes: [String: Route]) {
        self.routes = routes 
    }

    public func handleRoute(request: Request) -> String {
        return routes[request.path]!.handleRoute(request: request)
    }

}
