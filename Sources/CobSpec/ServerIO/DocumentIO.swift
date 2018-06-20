import Foundation

public class DocumentIO {
   
    public init(){}

    public func writeText(text: [String: String], path: String) {
        let filePath = NSURL.fileURL(withPathComponents: [path])
        let formattedText = text.map{ "\($0)=\($1)" }.joined(separator:"\n")
        do {
            try formattedText.write(to: filePath!, atomically: false,
                    encoding: String.Encoding.utf8)
        } catch {
            print("Error writing to file. \(error)")
        }
    }

    public func readText(path: String) -> String {
        if let data = FileManager.default.contents(atPath: path) {
            return String(data: data, encoding: .utf8)! 
        } else {
            return ""
        }
    }

    public func writePlainText(text: String, path: String) {
        let filePath = NSURL.fileURL(withPathComponents: [path])
        do {
            try text.write(to: filePath!, atomically: false, encoding: String.Encoding.utf8)
        } catch {
            print("Error writing to file. \(error)") 
        }
    }

}
