//
//  main.swift
//  QuoteHere
//
//  Created by robert on 12/18/16.
//  Copyright © 2016 Robert Doggett. All rights reserved.
//


import Foundation

let programName = CommandLine.arguments[0]

fileprivate func usage(mistake: String? = nil) {
    print("Usage: \(programName) [-h|--help] [-u|--unquote]")
    if let mistake = mistake { print(mistake) }
    exit(1)
}

fileprivate func help() {
    let help =
"\(programName) - Quote and escape a block of text.\n" +
"Options:\n" +
"    -u --unquote    restore quoted escaped text to original\n" +
"    -h --help this help\n" +
"    \n" +
"This works as a System service to escape selected text.\n" +
"It turns a multi-lined text heredoc into Swift friendly string.\n" +
"\n" +
"// Example:\n" +
"print(quoteHereDoc(doc: \"a\\nb\\nc\\n\"))\n" +
"\"a\\n\" +\n" +
"\"b\\n\" +\n" +
"\"c\\n\"\n"
    
    print(help)
    exit(0)
}

func main() {
    // Process command line arguments
    var encoding = true
    for arg in CommandLine.arguments[1..<CommandLine.arguments.count] {
        switch arg {
        case "-h", "--help":    help()
        case "-u", "--unquote": encoding = false
        default:                usage(mistake: "unknown argument: \(arg)")
        }
    }
    
    let input = System().stdIn
    let newDoc = encoding ? quoteHereDoc(doc: input) : unquoteHereDoc(doc: input)
    print(newDoc, terminator: "")
}

func test() {
     let doc = "a\n\\t\"b\"\nc\nd\n"
     let quotedDoc = quoteHereDoc(doc: doc)
     let unquotedDoc = unquoteHereDoc(doc: quotedDoc)
     
     print(
     "---original\n" +
     "\(doc)\n" +
     "--- quoted:\n" +
     "\(quotedDoc)\n" +
     "--- unquoted\n" +
     "\(unquotedDoc)\n" +
     "--- same?  " +
     "\(doc == unquotedDoc)  orig size:\(doc.characters.count)  reconstructed:\(unquotedDoc.characters.count)"
     )
}

/**
 Quote a block of text as a heredoc.
 
 This works well as a system service.
 - Parameter doc: the plaintext source to quote
 - Returns: escaped and quoted text replacement
 
 ```
 // Example use:
 print(quoteHereDoc(doc: "a\nb\nc\n"))
 
 "a\n" +
 "b\n" +
 "c\n"
 ```
 */
func quoteHereDoc(doc: String) -> String {
    let input = doc.countOccurances(of: "\n") == 1 ? doc.chomped() : doc
    
    /* From Swift ref: The escaped special characters
     \0 (null character),
     \\ (backslash),
     \t (horizontal tab),
     \n (line feed),
     \r (carriage return),
     \" (double quote) and
     \' (single quote)
     
     The characters we'll handle are [\"'], the simple substititutions
     */
    // quote the backslash and quote characters
    let in1 = input.replacingOccurrences(of: "([\\\\\"\'])", with: "\\\\$1", options: .regularExpression)
    
    // replace newlines with closeQuote +\n openQuote
    let in2 = in1.replacingOccurrences(of: "\\R", with: "\\\\n\" \\+\n\"", options: .regularExpression)
    
    // quote the result string as if it were a single string
    let in3 = "\"" + in2 + "\""
    
    // Remove artifact... without this the final line ends with +\n ""
    let in4 = in3.replacingOccurrences(of: "\\s*\\+\\R\\s*\"\"$", with: "\n", options: .regularExpression)
    return in4
}

/**
 Undo quotes around a block of heredoc text.
 
 This works well as a system service.
 - Parameter doc: the plaintext source to unquote
 - Returns: unescaped and unquoted text replacement
 */
func unquoteHereDoc(doc: String) -> String {
    let input = doc //.chomped()
    
    // unquote all the lines
    let in1 = input.replacingOccurrences(of: "(\\s*)\"(.*?)\\\\n\"\\s*\\+?(\\n|$)", with: "$1$2\n", options: .regularExpression)
    
    // remove backslash from special characters: \\ \" \'
    let in2 = in1.replacingOccurrences(of: "\\\\([\\\\\"\'])", with: "$1", options: .regularExpression)
    
    //  remove enclosing quotes
    let in3 = in2.replacingOccurrences(of: "^\\s*\"(.*)\"\\s*\\Z", with: "$1", options: .regularExpression)
    
    return in3
}
//test()
main()
