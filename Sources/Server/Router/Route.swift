import Foundation

public protocol Route {

    func handleRoute(request: Request) -> ResponseData

}
