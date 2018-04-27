import Foundation
import Request
import Response
import Routes

public class Responder {

    public init(){}

    public func buildResponse(responseData: ResponseData) -> Data {
        let headers = arrangeResponseHeaders(responseData: responseData)
        let response = "\(responseData.statusLine)\r\n" + headers + "\r\n\(responseData.body)"
        return convertResponseToBytes(response: response, responseData: responseData)
    }

    private func convertResponseToBytes(response: String, responseData: ResponseData) -> Data {
        var buffer = Data(response.utf8)
        if (responseData.image != nil) {
            buffer += responseData.image!
        }
        return buffer     
    }

    private func arrangeResponseHeaders(responseData: ResponseData) -> String {
        var arrangedHeaders = ""
        for (key, value) in responseData.headers {
            arrangedHeaders += "\(key): \(value)\r\n"
        }
        return arrangedHeaders
    }
 
}

