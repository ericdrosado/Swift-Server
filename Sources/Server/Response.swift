import Foundation
import Request

public class Response {

    let router: Router
    let status200: String
    let status404: String
    let status404Body: String

    public init(router: Router) {
        self.router = router
        self.status200 = "200 OK"
        self.status404 = "404 Not Found"
        self.status404Body = "404 Page Not Found"
    }

    public func buildResponse(request: Request) -> String {
            return router.handleRoute(request: request)
        }
 
}

