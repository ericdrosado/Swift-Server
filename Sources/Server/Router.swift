import Foundation
import Request
import Routes

public class Router {

    let routes: [String: Route]
    let fourOhFour: FourOhFour

    public init(routes: [String: Route], fourOhFour: FourOhFour) {
        self.routes = routes 
        self.fourOhFour = fourOhFour
    }

    public func handleRoute(request: Request) -> String {
        if (routes.keys.contains(request.path)) {
            return routes[request.path]!.handleRoute(request: request)
        } else {
            return fourOhFour.handleRoute(request:request) 
        }
    }

}
