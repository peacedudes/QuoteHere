//
//  System.swift
//  QuoteHere
//
//  Created by robert on 12/18/16.
//  Copyright © 2016 Robert Doggett. All rights reserved.
//

import Foundation

/**
 Provide access to CLI program's standard input stream.
 */
class System {
    fileprivate var inputData: String?
    
    /**
     Initialize to override stdIn with string
     */
    convenience init(string: String) {
        self.init()
        inputData = string
    }
    
    /**
     slurp all standard input as string
     */
    var stdIn: String { return inputData == nil ? readStdin() : inputData!  }
    
    // MARK : Internal
    /**
     Read all of stdin to end of file as a String.
     
     This inefficent contortion allows cooked input from terminal or pipes,
     making reading stdin work as a user would expect.
     
     */
    private func readStdin() -> String {
        var inputText: [String] = []
        while let line = readLine(strippingNewline: false) {
            inputText.append(line)
        }
        return inputText.joined(separator: "")
    }
}

public extension String {
    /// Trim final new line character, if present
    public mutating func chomp() {
        self = self.chomped()
    }
    
    /// Trim final new line character, if present, returns a new string
    public func chomped() -> String {
        return self.hasSuffix("\n") ? self.substring(to: index(before: endIndex)) : self
    }
}
