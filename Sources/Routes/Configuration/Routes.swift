import Foundation
import ServerIO

public class Routes {

    let fileIO: FileIO
    public let routes: [String: Route]

    public init() {
        self.fileIO = FileIO()
        self.routes = ["/": Root(),
                       "/hello": Hello(),
                       "/tea": Tea(),
                       "/coffee": Coffee(),
                       "/parameters": Parameters(),
                       "/cookie": Cookie(),
                       "/eat_cookie": EatCookie(),
                       "/redirect": Redirect(),
                       "/form": Form(fileIO: fileIO),
                       "/method_options": MethodOptions(),
                       "/method_options2": MethodOptions2(),
                       "/logs": Logs(fileIO: fileIO),
                       "/file1": File1(fileIO: fileIO),
                       "/text-file.txt": TextFile(),
                       "/image.jpeg": Image(),
                       "/image.png": Image(),
                       "/image.gif": Image(),
                       "/cat-form": CatForm(),
                       "/cat-form/data": CatForm(),
                       "/partial_content.txt": PartialContent(),
                       "/patch-content.txt": PatchContent()]
    }

}
