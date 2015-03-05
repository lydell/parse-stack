###
Copyright 2013 Simon Lydell

This file is part of parse-stack.

parse-stack is free software: you can redistribute it and/or modify it under the terms of the GNU
Lesser General Public License as published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

parse-stack is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser
General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with parse-stack. If
not, see <http://www.gnu.org/licenses/>.
###

# - Each entry is either a single regexp or an array of regexps.
# - `\x20` matches a space.
# - See also support/support.md
formats = [
	[
		# The at format with function name.
		///
			^\x20+at\x20
			(.+?) # name
			\x20
			\(
				(.*?) # filepath
				(?:
					:
					(\d+) # lineNumber
					:
					(\d+) # columnNumber
				)?
			\)$
			///

		# The at format without function name.
		///
			^\x20+at\x20
			() # empty name, keeping the capture groups order
			(.*?) # filepath
			(?:
				:
				(\d+) # lineNumber
				:
				(\d+) # columnNumber
			)?$
			///
	]

	# The @ format.
	///
		^
		([^@]*) # name
		@
		(\S*)   # filepath
		:
		(\d+)   # lineNumber
		$
		///
	]

newline = /\r\n|\r|\n/

parseStack = (error)->
	return null unless typeof error.stack is "string"
	{stack} = error

	prelude = error.toString()
	if stack[...prelude.length] is prelude
		stack = stack[prelude.length..]

	stackLines = stack.split(newline).filter((stackLine)-> stackLine isnt "")

	for format in formats
		match = matchStackLine(format, stackLines[0])
		break if match
	unless match
		throw new Error "Unkown stack trace format:\n#{stack}"

	for stackLine, index in stackLines
		[match, name, filepath, lineNumber, columnNumber] = matchStackLine(format, stackLine) ? []
		unless match
			throw new Error "Unknown stack trace formatting on stack line #{index+1}:\n#{stackLine}"

		# Every property is either `undefined`, a string or a number.
		name         = ensureType(String, name)
		filepath     = ensureType(String, filepath)
		lineNumber   = ensureType(Number, lineNumber)
		columnNumber = ensureType(Number, columnNumber)
		{name, filepath, lineNumber, columnNumber}

matchStackLine = (format, line)->
	return line.match(format) if format instanceof RegExp
	for re in format
		match = line.match(re)
		break if match
	return match

ensureType = (type, value)-> if value then type(value) else undefined

module.exports = parseStack
