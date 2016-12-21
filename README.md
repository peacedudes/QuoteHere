# QuoteHere

Quote and escape a block of text, or undo quoting and escaping.

This script makes it easy to escape regular expressions in Swift,
and converts multiple lines of text into a series of Swift-friendly 
concatenated strings.

Inspired by: 
[A Quick Hack to Quote Swift Strings in a Playground](http://gothick.org.uk/2014/12/10/a-quick-hack-to-quote-swift-strings-in-a-playground/)


and: [How to install an OS X System Service](http://brettterpstra.com/howtos/install-an-os-x-system-service/).

Example use:
```
$quoteHere <<EOF >quoted    # 
{
color: "red",
value: "#f00"
}
EOF

$cat quoted     # see what happened
"{\n" +
"    color: \"red\",\n" +
"    value: \"#f00\"\n" +
"}\n"

$quoteHere -u <quoted       # undo the changes
{
color: "red",
value: "#f00"
}
```


QuoteHere convenient to use in a System service, where it
can quote and escape selected text in any document.  Complete
instructions can be found in the short articles linked above,
but here's a summary.

1. Compile the script, and copy it somewhere in your path
```
    swift build
    cp .build/debug/quoteHere /Users/me/bin/quoteHere
```
2. Run Automator to create a new document of type "Service".  Be 
sure to check *Output replaces selected text.*
```
    Service recieves selected [text]    in [any application]
    Input is [entire selection]         [x] Output replaces selected text
```
3. Find "Run Shell Script" from Automator's Utilities actions, add it, 
and enter a line in the workflow that executes the program you created.
```
    /Users/me/bin/quoteHere
```
4. Save the script, choosing a name for your service.  I use *quoteHere*
and a corresponding *unquoteHere* to undo it. The Service becomes available 
immediately in the Services menu of any text editing program.

Your script is stored with other service workflow scripts in ~/Library/Services, 
and can be opened and edited with Automator or deleted from there.

5. Add a keyboard shortcut to make it useful.  I use ⇧⌘V
  - Open System Preferences / Keyboard
  - Select Shortcuts
  - Select Services, and find your service(s) in the Text section
  - Click in the rightmost column, and type the keyboard shortcut you've chosen

You're done.  Now just make an undo Service exactly like the first, but the
the addition of an --unquote argument:
```/usr/local/bin/quoteHere --unquote``` 
This action unquote and unescapes selected text.  I use ⇧⌃⌘V

