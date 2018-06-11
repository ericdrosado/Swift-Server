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
            if (RouteActions().routeActions[request.path]!.contains(request.method)) {
                return routes[request.path]!.handleRoute(request: request)
            } else {
                return ResponseData(statusLine: HTTPStatus.notAllowed.toStatusLine(version: request.httpVersion), 
                                    headers: Headers().getHeaders(body: "", route: request.path), 
                                    body: "")  
            }
        } else {
            logNonExistingRoutes(request: request)
            return fourOhFour.handleRoute(request:request) 
        }
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
