import Foundation
import Request

public protocol Route {

    func handleRoute(request: Request) -> String

}
