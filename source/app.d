import wsd;
import io = std.stdio, file = std.file;
import std.process, std.path, std.string;

void main( string[] args )
{
	// If no args given, print help
	if( args.length < 3 )
	{
		io.writeln( "Usage: wsd (build|run) (filename) [rdmd options]" );
		return;
	}

	// Get name of file to write to
	auto outFileName = args[2].stripExtension ~ ".d";

	// Read file specified
	auto code = file.readText( args[2] );
	// Translate the code
	auto translatedCode = processCode( code );
	// Write resulting code
	file.write( outFileName, translatedCode );

	// Call rdmd if specified
	if( args[1].strip == "run" )
		wait( spawnProcess( [ "rdmd", outFileName ] ~ ( args.length > 3 ? args[ 3..$-1 ] : [] ) ) );
}
