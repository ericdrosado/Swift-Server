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
        let filePath = NSURL.fileURL(withPathComponents: [path])
        var data: String = String()
        do {
            data = try String(contentsOf: filePath!, encoding: String.Encoding.utf8) 
        } catch {
            print("Error reading text file. \(error)")
        }
        return data
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
