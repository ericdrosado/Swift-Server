import Foundation

public class Router {

    let routes: [String: [String: Any]]

    public init(routes: [String: [String: Any]]){
        self.routes = routes
    }

    public func handleRoute(request: Request) -> ResponseData {
        if routes.keys.contains(request.path) {
            return getRouteResponse(request: request)
        } else {
            logNonExistingRoutes(request: request)
            return ResponseData(statusLine: HTTPStatus.notFound.toStatusLine(version: request.httpVersion), 
                                headers: Headers().getHeaders(body: "", route: request.path), 
                                body: "")  
        }
    }

    private func getRouteResponse(request: Request) -> ResponseData {
        if let routeInformation = routes[request.path] {   
            if let route = routeInformation["routeHandler"] as? Route, 
               let routeActions = routeInformation["allowedActions"] as? [Action], 
               let action = Action(rawValue: request.method) {
                if (routeActions.contains(action)) {
                    return route.handleRoute(request: request)
                } else {
                  return methodNotAllowed(request: request)
                }
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


    private func logNonExistingRoutes(request: Request) {
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
