import XCTest
import Foundation
import Response

class TestHelper: XCTestCase {

    let version = "HTTP/1.1"

    public func buildRequest(method: String, route: String, body: String = "", additionalHeader: String = "") -> String {
        return "\(method) \(route) HTTP/1.1\r\nCache-Control: no-cache\r\nConnection: keep-alive\r\n\(additionalHeader)\r\n\(body)"
    }

    public func createTempFile(file: String) {
        let filePath = NSURL.fileURL(withPathComponents: [file])
        let path: String = filePath!.path
        FileManager.default.createFile(atPath: path, contents: Data(), attributes: nil)
        if (file == "partial_content.txt") {
            let text = "This is a file that contains text to read part of in order to fulfill a 206."
            do {
                try text.write(to: filePath!, atomically: false,
                encoding: String.Encoding.utf8)
            } catch {
                print("Error writing to file. \(error)")
            }
        }
    }

    public func deleteTempFile(file: String) {
        if (FileManager.default.fileExists(atPath: file)) {
                do {
                    try FileManager.default.removeItem(atPath: file)
                } catch {
                    print("Error deleting file. \(error)")
                }
        }
    }

}

extension ResponseData: Equatable {
    static public func == (lhs: ResponseData, rhs: ResponseData) -> Bool {
        return 
            lhs.statusLine == rhs.statusLine &&
            lhs.headers == rhs.headers &&
            lhs.body == rhs.body &&
            lhs.image == nil && rhs.image == nil || 
            lhs.image! == rhs.image!
    }
}