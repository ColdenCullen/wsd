import wsd;
import io = std.stdio, file = std.file, std.path;

void main( string[] args )
{
	// If no args given, print help
	if( args.length < 2 )
	{
		io.writeln( "Usage: wsd [filename].wsd [rdmd options]" );
		return;
	}

	auto outFileName = args[1].dirName ~ args[1].baseName ~ ".d";

	auto code = file.readText( args[1] );
	auto translatedCode = processCode( code );
	file.write( outFileName, translatedCode );
}
