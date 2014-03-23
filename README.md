wsd [![Build Status](https://travis-ci.org/ColdenCullen/wsd.svg?branch=master)](https://travis-ci.org/ColdenCullen/wsd)
===

A whitespace-based D dialect. I should note that this a proof of concept, and no more.

### Running wsd

Running wsd is as simple as passing it the filename and any args you want to pass to `rdmd`. For example:
```
./wsd test1.wsd
```

### wsd Code

wsd code is basically D code, but with 2 fundamental changes:
1. Braces are illegal. Blocks are specified by indenting another level. Currently only hardware tabs are supported, but I'm looking into adding space support. Also, any declaration or block specifier (`if`, `while`, function declarations, etc.) must be followed by a colon. See example for details.
2. Certain keywords (currently `if`, `while`, `for`, and `foreach`) do not allow parenthesis around their conditional expression. Again, see the example for more information

### Sample Code
```d
import std.stdio

void main():
	for int i = 0; i < 10; ++i:
		writeln( i )

	writeln( "Outer code" )

		writeln( "Inside a block" )
```

This outputs the following code:

```d
import std.stdio;

void main()
{
	for( int i = 0; i < 10; ++i )
	{
		writeln( i );
	}

	writeln( "Outer code" );
	{

		writeln( "Inside a block" );
	}
}
```
