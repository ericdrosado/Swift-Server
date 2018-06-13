import Foundation
import Request
import Response
import Routes

public class Router {

    let routes: [String: Route]
    let fourOhFour: FourOhFour

    public init(routes: [String: Route], fourOhFour: FourOhFour) {
        self.routes = routes 
        self.fourOhFour = fourOhFour
    }

    public func handleRoute(request: Request) -> ResponseData {
        if (routes.keys.contains(request.path)) {
            return getRouteResponse(request: request)
        } else {
            logNonExistingRoutes(request: request)
            return fourOhFour.handleRoute(request:request) 
        }
    }

    private func getRouteResponse(request: Request) -> ResponseData {
        if let routeActions = RouteActions().routeActions[request.path], let action =  Action(rawValue: request.method){
            if (routeActions.contains(action)) {
                return routes[request.path]!.handleRoute(request: request)
            } else {
                return methodNotAllowed(request: request)
            }
        } else {
            return methodNotAllowed(request: request)
        }

    }

    private func methodNotAllowed(request: Request) -> ResponseData {
        return ResponseData(statusLine: HTTPStatus.notAllowed.toStatusLine(version: request.httpVersion), 
                            headers: Headers().getHeaders(body: "", route: request.path), 
                            body: "")  
    }


    public func logNonExistingRoutes(request: Request) {
        let filePath = NSURL.fileURL(withPathComponents: ["requestLog.txt"])
        if let outputStream = OutputStream(url: filePath!, append: true) { 
            outputStream.open()
            let text = "\(request.method) \(request.path) \(request.httpVersion)"
            outputStream.write(text, maxLength: text.count)
            outputStream.close()
        } else {
            print("Unable to open and write to file")
        }
    }
}
