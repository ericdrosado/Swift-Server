import Foundation
import Request

public class DocumentIO {
   
    public init(){}

    public func writeText(requestBody: [String: String], path: String) {
        let filePath = NSURL.fileURL(withPathComponents: [path])
        let text = requestBody.map{ "\($0)=\($1)" }.joined(separator:"\n")
        do {
            try text.write(to: filePath!, atomically: false,
                    encoding: String.Encoding.utf8)
        } catch {
            print("Error writing to file. \(error)")
        }
    }

    public func readText(path: String) -> String {
        let filePath = NSURL.fileURL(withPathComponents: [path])
        var data: String = String()
        do {
            data = try String(contentsOf: filePath!, encoding: String.Encoding.utf8) 
        } catch {
            print("Error reading text file. \(error)")
        }
        return data
    }

    public func writePlainText(requestBody: String, path: String) {
        let filePath = NSURL.fileURL(withPathComponents: [path])
        let text = requestBody   
        do {
            try text.write(to: filePath!, atomically: false, encoding: String.Encoding.utf8)
        } catch {
            print("Error writing to file. \(error)") 
        }
    }

}
