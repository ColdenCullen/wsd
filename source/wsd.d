module wsd;
import std.string, std.stdio;

string processCode( string code )
{
	enum lineSep = "\n";		// Line seperator
	auto result = "";			// Buffer to put result code in
	auto indentifier = "\t";	// The string that constitutes an indent
	uint indentLevel = 0;		// Current level of indentation

	foreach( lineBuffer; code.splitLines )
	{
		// Remove all whitespace right of code and copy out of buffer
		auto line = lineBuffer.stripRight().dup;

		// If not a whitespace line, process
		if( line.length )
		{
			uint lineIndent = 0;		// Buffer to chomp from
			auto chompedLine = line;	// Calculate indentation of line

			// Chomp the line until it doesn't change
			while( line != ( chompedLine = chompedLine.chompPrefix( indentifier ) ) )
			{
				++lineIndent;
				line = chompedLine;
			}

			// If the indentation of this line is greater than expected, start block
			if( lineIndent > indentLevel )
			{
				// Space and print open brace
				foreach( i; 0..indentLevel )
					result ~= indentifier;
				result ~= "{" ~ lineSep;

				indentLevel = lineIndent;
			}
			// If less indentation than expected, end block
			else if( lineIndent < indentLevel )
			{
				// Space and print close brace
				foreach( i; 0..indentLevel-1 )
					result ~= indentifier;
				result ~= "}" ~ lineSep;

				indentLevel = lineIndent;
			}

			// Pad output with appropriate whitespace (for readibility)
			foreach( i; 0..lineIndent )
				result ~= indentifier;

			// If beginning of a block, don't print semicolon
			if( line[$-1] == ':' )
			{
				bool keywordFound = false;
				// If block keyword, wrap condition in parens before continuing
				foreach( keyword; [ "for", "foreach", "while", "if" ] )
				{
					if( line[ 0..keyword.length ] == keyword )
					{
						result ~= keyword ~ "( " ~ line.chompPrefix( keyword ).chomp( ":" ).strip ~ " )";
						keywordFound = true;
						break;
					}
				}

				// If found keyword, skip re-appending the line
				if( !keywordFound )
					result ~= line.chomp( ":" );
			}
			// Else, just an expression that needs a semicolon
			else
			{
				result ~= line ~ ";";
			}
		}

		result ~= lineSep;
	}

	// Close any remaining blocks
	foreach( i; 0..indentLevel )
	{
		foreach( j; 0..indentLevel-1 )
			result ~= indentifier;
		result ~= "}" ~ lineSep;

		--indentLevel;
	}

	return result;
}

unittest
{
	auto wsd = import( "test1.wsd" );

	auto targetCode = import( "test1.d" );

	auto actualCode = processCode( wsd );

	assert( actualCode == targetCode, "Translation failed, output:\n" ~ actualCode ~ "Expected:\n" ~ targetCode );
}
