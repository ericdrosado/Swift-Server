import Foundation
import Request
import Response

public protocol Route {

    func handleRoute(request: Request) -> ResponseData

}
