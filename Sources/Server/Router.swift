import Foundation
import Request
import Routes

public class Router {

    let routes: [String: Route]
    let fourOhFour: FourOhFour

    public init(routes: [String: Route]) {
        self.routes = routes 
        self.fourOhFour = FourOhFour()
    }

    public func handleRoute(request: Request) -> String {
        if (routes.keys.contains(request.path)) {
            return routes[request.path]!.handleRoute(request: request)
        } else {
            return fourOhFour.handleRoute(request:request) 
        }
    }

}
