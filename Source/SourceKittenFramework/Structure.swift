//
//  Structure.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-06.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation

/// Represents the structural information in a Swift source file.
public struct Structure {
    /// Structural information as an [String: SourceKitRepresentable].
    public let dictionary: [String: SourceKitRepresentable]

    /**
    Create a Structure from a SourceKit `editor.open` response.
     
    - parameter sourceKitResponse: SourceKit `editor.open` response.
    */
    public init(sourceKitResponse: [String: SourceKitRepresentable]) {
        var sourceKitResponse = sourceKitResponse
        _ = sourceKitResponse.removeValueForKey(SwiftDocKey.SyntaxMap.rawValue)
        dictionary = sourceKitResponse
    }

    /**
    Initialize a Structure by passing in a File and compiler arguments.

    - parameter file: File to parse for structural information.
    - parameter compilerargs: Compiler arguments to pass to SourceKit. This
                              must be specified following the '--'. An empty
                              string by default.
    */
    public init(file: File, compilerargs: String = "") {
        let request = Request.EditorOpen(
            file: file,
            arguments: compilerargs.componentsSeparatedByString(" "))
        self.init(sourceKitResponse: request.send())
    }
}

// MARK: CustomStringConvertible

extension Structure: CustomStringConvertible {
    /// A textual JSON representation of `Structure`.
    public var description: String { return toJSON(toAnyObject(dictionary)) }
}

// MARK: Equatable

extension Structure: Equatable {}

/**
Returns true if `lhs` Structure is equal to `rhs` Structure.

- parameter lhs: Structure to compare to `rhs`.
- parameter rhs: Structure to compare to `lhs`.

- returns: True if `lhs` Structure is equal to `rhs` Structure.
*/
public func ==(lhs: Structure, rhs: Structure) -> Bool {
    return lhs.dictionary.isEqualTo(rhs.dictionary)
}
