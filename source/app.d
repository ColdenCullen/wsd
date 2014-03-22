import wsd;
import io = std.stdio, file = std.file;
import std.process, std.path, std.string;

void main( string[] args )
{
	// If no args given, print help
	if( args.length < 2 )
	{
		io.writeln( "Usage: wsd (filename) [rdmd options]" );
		return;
	}

	// Get name of file to write to
	auto outFileName = args[1].stripExtension ~ ".d";

	// Read file specified
	auto code = file.readText( args[1] );
	// Translate the code
	auto translatedCode = processCode( code );
	// Write resulting code
	file.write( outFileName, translatedCode );

	// Call rdmd on file
	wait( spawnProcess( [ "rdmd", outFileName ] ~ ( args.length > 2 ? args[ 2..$-1 ] : [] ) ) );
}
