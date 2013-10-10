Description
===========

The following test was run in a number of different browsers, and a screen shot was taken of its
result: <http://jsbin.com/uzogir>. It tries to write the [`stack` property][stack] of an error. If
"undefined" is written the test failed. If a stack trace is written the test passed. The screen
shots also serve to view the differences in formatting of the stack trace.

Only the latest browser versions for the fails were kept. For a few browsers I have not found a
failing version.

For the passes, the oldest versions and the newest (when this was written) were kept. Also, if a
browser have changed their formatting some time, the newest version with the old formatting and the
oldest version with the new formatting are kept, too.

Sometimes the same browser version was tested on several platforms.

[stack]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error/Stack


Results
=======

Formats
-------

I noticed that there seems to be two formats of the stack trace. I call them "the at format" and
"the @ format" (or "at" and "@" for short).

### The at format ###

    ErrorType: message
        functionName at (filepath:line:column)
        at filepath:line:column

### The @ format ###

    functionName@filepath:line
    @filepath:line

Support
-------

### Desktop ###

- Firefox – @ format (with a [limitation](#limitation) in version 13-)
- Chrome – at format
- Opera 12- – @ format (with a [limitation](#limitation))
- Opera 15+ – at format
- Safari 6+ – @ format
- Internet Explorer 10+ – at format

#### Limitation ####

Firefox and Opera used a slight variation of the @ format prior to version 14 and 15, respectively.
Some string representation of the arguments was included inside parenthesis after the function name,
like this: `functionName("john@doe.com", 123)@…`. If one of the arguments contains an '@' symbol,
the file path will be faulty. I don't think it's worth the extra parsing complexity to support these
older browser versions completely.

### Mobile ###

- Android Browser 4+ – at format
- Safari 6+ – @ format

### Other ###

- Node.js – at format

Note that when running Node.js scripts written in CoffeeScript using the `coffee` binary, filepath,
line and column refers to the original CoffeeScript source! The JavaScript line and column is
provided, too. CoffeeScript indents 2 spaces instead of 4. This requires CoffeeScript > 1.6.3.

    ErrorType: message
      functionName at (filepath.coffee:line:column)
      at filepath:line:column

It might be safe too assume that anything not too old using the V8 or SpiderMonkey JavaScript
engines support it.
