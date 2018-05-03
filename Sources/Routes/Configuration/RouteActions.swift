import Foundation

public class RouteActions {

    public let routeActions: [String: [String]]


    public init() {
        self.routeActions = ["/": ["GET", "HEAD"],
                       "/hello": ["GET", "HEAD"],
                       "/tea": ["GET", "HEAD"],
                       "/coffee": ["GET", "HEAD"],
                       "/parameters": ["GET", "HEAD"],
                       "/cookie": ["GET", "HEAD"],
                       "/eat_cookie": ["GET", "HEAD"],
                       "/redirect": ["GET", "HEAD"],
                       "/form": ["GET", "HEAD", "POST", "PUT"],
                       "/method_options": ["GET", "HEAD", "POST", "OPTIONS", "PUT"],
                       "/method_options2": ["GET", "HEAD", "OPTIONS"],
                       "/logs": ["GET", "HEAD", "PUT"],
                       "/file1": ["GET", "HEAD"],
                       "/text-file.txt": ["GET", "HEAD"],
                       "/image.jpeg": ["GET", "HEAD"],
                       "/image.png": ["GET", "HEAD"],
                       "/image.gif": ["GET", "HEAD"],
                       "/cat-form": ["GET", "HEAD", "POST"],
                       "/cat-form/data": ["GET", "HEAD", "PUT", "DELETE"],
                       "/partial_content.txt": ["GET", "HEAD"],
                       "/patch-content.txt": ["GET", "HEAD", "PATCH"]]
    }
}