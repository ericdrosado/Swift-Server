import Foundation
import Utility

public class CLIUtility {

    let arguments: [String] 
    let parser: ArgumentParser 
    let port: OptionArgument<Int>
    let parsedArguments: ArgumentParser.Result 

    init() throws {
        arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())
        parser = ArgumentParser(usage: "<options>", overview: "Please use one of the following options when necessary")
        port = parser.add(option: "--port", shortName: "-p", kind: Int.self, usage: "Enter a port to listen on")
        parsedArguments = try parser.parse(arguments)
    }

    public func getPortNumber() -> Int {
        return parsedArguments.get(port) ?? 5000 
    }
}

