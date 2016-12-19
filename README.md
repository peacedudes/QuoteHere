# QuoteHere

Quote and escape a block of text, or undo quoting and escaping.

This  script makes it easy to escape regular expressions in Swift,
and also converts a *heredoc* of multiple lines into a series of 
concatenated quoted and escaped Swift friendly strings.

Inspired by: 
[A Quick Hack to Quote Swift Strings in a Playground](http://gothick.org.uk/2014/12/10/a-quick-hack-to-quote-swift-strings-in-a-playground/) and 
[How to install an OS X System Service](http://brettterpstra.com/howtos/install-an-os-x-system-service/).

As a standalone program, quoteHere surrounds each line from
StdIn in quotes, and concatenates all the lines together 
so they can be included directly in a Swift source file.  It
also escapes any backslash and quote characters.

QuoteHere is intended for and most conveniently used as two System
services, to quote and escape or unescape selected text.  More
detailed instructions for doing this are found in the short
articles linked (above), but here's a working summary.

1. Compile the script to an executable somewhere in your path.
```
    swiftc *.swift -o /usr/local/bin/quoteHere
```
2. Run Automator, and create a new document of type "Service".  Be 
sure to check *Output replaces selected text.*
```
    Service recieves selected [text]    in [any application]
    Input is [entire selection]         [x] Output replaces selected text
```
3. Add "Run Shell Script" from Automator's Utilities actions, and 
enter a line in the workflow to run the script you've created.
```
    /usr/local/bin/quoteHere
```
4. Save the script, choosing a name you like.  I use *quoteHere* as the 
name of the service (and *unquoteHere* to undo it).   The Service is 
available immediately in the Services menu of any text handling program.
Service workflow scripts are kept in ~/Library/Services, if you should
want to edit or remove the script.

5. Add a keyboard shortcut to access the service more easily.  I use ⇧⌘V
  - Open System Preferences / Keyboard
  - Select Shortcuts
  - Select Services, and find your service(s) in the Text section
  - Click in the rightmost column, and type the keyboard shortcut you've chosen

You're done.  Create another Service just like the first, with the addition
of the -u (undo) argument:
```/usr/local/bin/quoteHere -u``` 
This action will unquote and unescape the selected text.  I use the shortcut ⇧⌃⌘V

