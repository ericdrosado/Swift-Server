import Foundation

public class Routes {

    public init(){}

    public static let routes: [String: Route] = ["/": Root(),
                                                 "/hello": Hello(),
                                                 "/tea": Tea(),
                                                 "/coffee": Coffee(),
                                                 "/parameters": Parameters(),
                                                 "/cookie": Cookie(),
                                                 "/eat_cookie": EatCookie(),
                                                 "/redirect": Redirect(),
                                                 "/form": Form(),
                                                 "/method_options": MethodOptions(),
                                                 "/method_options2": MethodOptions2(),
                                                 "/logs": Logs(),
                                                 "/file1": File1(),
                                                 "/text-file.txt": TextFile(),
                                                 "/image.jpeg": Image(),
                                                 "/image.png": Image(),
                                                 "/image.gif": Image(),
                                                 "/patch-content.txt": PatchContent()]
}
