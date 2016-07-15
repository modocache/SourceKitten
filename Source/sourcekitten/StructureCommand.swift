//
//  StructureCommand.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-07.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Commandant
import Foundation
import Result
import SourceKittenFramework

struct StructureCommand: CommandType {
    let verb = "structure"
    let function = "Print Swift structure information as JSON"

    struct Options: OptionsType {
        let file: String
        let text: String
        let compilerargs: String

        static func create(file: String) -> (text: String) -> (compilerargs: String) -> Options {
            return { text in { compilerargs in
                self.init(file: file, text: text, compilerargs: compilerargs)
            }}
        }

        static func evaluate(m: CommandMode) -> Result<Options, CommandantError<SourceKittenError>> {
            return create
                <*> m <| Option(key: "file", defaultValue: "", usage: "relative or absolute path of Swift file to parse")
                <*> m <| Option(key: "text", defaultValue: "", usage: "Swift code text to parse")
                <*> m <| Option(key: "compilerargs", defaultValue: "", usage: "Compiler arguments to pass to SourceKit. This must be specified following the '--'")
        }
    }

    func run(options: Options) -> Result<(), SourceKittenError> {
        if !options.file.isEmpty {
            if let file = File(path: options.file) {
                print(Structure(file: file, compilerargs: options.compilerargs))
                return .Success()
            }
            return .Failure(.ReadFailed(path: options.file))
        }
        if !options.text.isEmpty {
            print(Structure(file: File(contents: options.text), compilerargs: options.compilerargs))
            return .Success()
        }
        return .Failure(
            .InvalidArgument(description: "either file or text must be set when calling structure")
        )
    }
}
