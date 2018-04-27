import Foundation
import Request
import Response

public class Image: Route {

    let fourOhFour: FourOhFour
    
    public init() {
        self.fourOhFour = FourOhFour()
    }

    public func handleRoute(request: Request) -> ResponseData {
        let body = "" 
        let image = getImage(request: request) 
        if (image == nil) {
            return fourOhFour.handleRoute(request: request)
        }
        return ResponseData(statusLine: Status.status200(version: request.httpVersion), 
                            headers: Headers().getHeaders(body: body, route: request.path), 
                            body: body,
                            image: image)   
    }
    
    private func getImage(request: Request) -> [UInt8]? {
        let filePath = "\(request.directory)\(request.path)"
        if let data = NSData(contentsOfFile: filePath) {
            var buffer = [UInt8](repeating: 0, count: data.length)
            data.getBytes(&buffer, length: data.length)
            return buffer 
        } else {
            return nil
        }
    }

}
