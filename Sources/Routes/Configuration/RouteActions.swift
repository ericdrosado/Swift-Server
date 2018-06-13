import Foundation

public class RouteActions {

    public let routeActions: [String: [Action]]


    public init() {
        self.routeActions = ["/": [.get, .head],
                       "/hello": [.get, .head],
                       "/tea": [.get, .head],
                       "/coffee": [.get, .head],
                       "/parameters": [.get, .head],
                       "/cookie": [.get, .head],
                       "/eat_cookie": [.get, .head],
                       "/redirect": [.get, .head],
                       "/form": [.get, .head, .post, .put],
                       "/method_options": [.get, .head, .post, .options, .put],
                       "/method_options2": [.get, .head, .options],
                       "/logs": [.get, .head, .put],
                       "/file1": [.get, .head],
                       "/text-file.txt": [.get, .head],
                       "/image.jpeg": [.get, .head],
                       "/image.png": [.get, .head],
                       "/image.gif": [.get, .head],
                       "/cat-form": [.get, .head, .post],
                       "/cat-form/data": [.get, .head, .put, .delete],
                       "/partial_content.txt": [.get, .head],
                       "/patch-content.txt": [.get, .head, .patch]]
    }
}
