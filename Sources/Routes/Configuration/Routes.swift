import ServerIO

public enum Routes: String {
    case root = "/"
    case hello = "/hello"
    case tea = "/tea"
    case coffee = "/coffee"
    case parameters = "/parameters"
    case cookie = "/cookie"
    case eatCookie = "/eat_cookie"
    case redirect = "/redirect"
    case form = "/form"
    case methodOptions = "/method_options"
    case methodOptions2 = "/method_options2"
    case logs = "/logs"
    case file1 = "/file1"
    case textFile = "/text-file.txt"
    case imageJPEG = "/image.jpeg"
    case imagePNG = "/image.png"
    case imageGIF = "/image.gif"
    case catForm = "/cat-form"
    case catFormData = "/cat-form/data"
    case partialContent = "/partial_content.txt"
    case patchContent = "/patch-content.txt"

    public var routes: Route {
        switch self {
            case .root: return Root()
            case .hello: return Hello()
            case .tea: return Tea()
            case .coffee: return Coffee()
            case .parameters: return Parameters()
            case .cookie: return Cookie()
            case .eatCookie: return EatCookie()
            case .redirect: return Redirect()
            case .form: return Form(documentIO: DocumentIO())
            case .methodOptions: return MethodOptions()
            case .methodOptions2: return MethodOptions2() 
            case .logs: return Logs(documentIO: DocumentIO())
            case .file1: return File1(documentIO: DocumentIO())
            case .textFile: return TextFile(documentIO: DocumentIO())
            case .imageJPEG: return Image()
            case .imagePNG: return Image()
            case .imageGIF: return Image()
            case .catForm: return CatForm()
            case .catFormData: return CatForm()
            case .partialContent: return PartialContent(documentIO: DocumentIO())
            case .patchContent: return PatchContent(documentIO: DocumentIO())
        }
    }

    public var routeActions: [Action] {
        switch self {
            case .root: return [.get, .head]
            case .hello: return [.get, .head]
            case .tea: return [.get, .head]
            case .coffee: return [.get, .head] 
            case .parameters: return [.get, .head]
            case .cookie: return [.get, .head]
            case .eatCookie: return [.get, .head]
            case .redirect: return [.get, .head]
            case .form: return [.get, .head, .post, .put]
            case .methodOptions: return [.get, .head, .post, .options, .put] 
            case .methodOptions2: return [.get, .head, .options]
            case .logs: return [.get, .head, .put]
            case .file1: return [.get, .head]
            case .textFile: return [.get, .head]
            case .imageJPEG: return [.get, .head]
            case .imagePNG: return [.get, .head]
            case .imageGIF: return [.get, .head]
            case .catForm: return [.get, .head, .post]
            case .catFormData: return [.get, .head, .put, .delete]
            case .partialContent: return [.get, .head]
            case .patchContent: return [.get, .head, .patch]
        }
    }
}
