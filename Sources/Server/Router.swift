import Foundation
import Request
import Response
import Routes

public class Router {

    let fourOhFour: FourOhFour

    public init(fourOhFour: FourOhFour) {
        self.fourOhFour = fourOhFour
    }

    public func handleRoute(request: Request) -> ResponseData {
        if let _ = Routes(rawValue: request.path) {
            return getRouteResponse(request: request)
        } else {
            logNonExistingRoutes(request: request)
            return fourOhFour.handleRoute(request:request) 
        }
    }

    private func getRouteResponse(request: Request) -> ResponseData {
        if let route = Routes(rawValue: request.path),let action =  Action(rawValue: request.method) {
            let routeActions = route.routeActions 
            if (routeActions.contains(action)) {
                return route.routes.handleRoute(request: request)
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
