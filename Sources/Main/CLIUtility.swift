import Foundation
import Utility

public class CLIUtility {

    let defaultDirectory: String
    let arguments: [String]
    let parser: ArgumentParser
    let port: OptionArgument<Int>
    let directory: OptionArgument<String>
    let parsedArguments: ArgumentParser.Result
    
    init() throws {
        self.defaultDirectory = "./cob_spec/public"
        arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())
        parser = ArgumentParser(usage: "<options>", overview: "Please use one of the following options when necessary")
        port = parser.add(option: "--port", shortName: "-p", kind: Int.self, usage: "Enter a port to listen on")
        directory = parser.add(option: "--directory", shortName: "-d", kind: String.self, usage: "Enter a directory")
        parsedArguments = try parser.parse(arguments)
    }

    public func getPortNumber() -> Int {
        return parsedArguments.get(port) ?? 5000
    }

    public func getDirectory() -> String? {
        return parsedArguments.get(directory) ?? getDefaultDirectory()
    }

    public func getDefaultDirectory() -> String? {
        if (!FileManager.default.fileExists(atPath: defaultDirectory)) {
           return defaultDirectory 
        } else {
            return nil
        }
    }

}

