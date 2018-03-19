import Foundation
import Request

public class Response {

    let router: Router

    public init(router: Router) {
        self.router = router
    }

    public func buildResponse(request: Request) -> String {
        return router.handleRoute(request: request)
    }
 
}

