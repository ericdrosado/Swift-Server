import Foundation
import ServerIO

public class Routes {

    let documentIO: DocumentIO
    public let routes: [String: Route]

    public init() {
        self.documentIO = DocumentIO()
        self.routes = ["/": Root(),
                       "/hello": Hello(),
                       "/tea": Tea(),
                       "/coffee": Coffee(),
                       "/parameters": Parameters(),
                       "/cookie": Cookie(),
                       "/eat_cookie": EatCookie(),
                       "/redirect": Redirect(),
                       "/form": Form(documentIO: documentIO),
                       "/method_options": MethodOptions(),
                       "/method_options2": MethodOptions2(),
                       "/logs": Logs(documentIO: documentIO),
                       "/file1": File1(documentIO: documentIO),
                       "/text-file.txt": TextFile(documentIO: documentIO),
                       "/image.jpeg": Image(),
                       "/image.png": Image(),
                       "/image.gif": Image(),
                       "/cat-form": CatForm(),
                       "/cat-form/data": CatForm(),
                       "/partial_content.txt": PartialContent(documentIO: documentIO),
                       "/patch-content.txt": PatchContent(documentIO: documentIO)]
    }

}
