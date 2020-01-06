package xa3.crossfile.async;

using tink.CoreApi;
class FileSystem {
	
	public static function createDirectory( path:String ) {
		#if sys
			try {
				sys.FileSystem.createDirectory( path );
				return Future.sync( Success( path ));
			} catch( e:Dynamic ) {
				return Future.sync( Failure( e ));
			}
		#elseif nodejs
			return Future.async( callback -> 
				js.node.Fs.mkdir( path, error ->
					callback( error == null || Std.string( error ).indexOf( "EEXIST" ) != -1
						? Success( path )
						: Failure( Std.string( error ))
					)));
		#else
			throw "Error: Platform not supported.";
		#end
	}
	
	public static function readDirectory( path:String ) {
		#if sys
			try {
				return Future.sync( Success( sys.FileSystem.readDirectory( path )));
			} catch( e:Dynamic ) {
				return Future.sync( Failure( e ));
			}
		#elseif nodejs
			return Future.async( callback -> 
				js.node.Fs.readdir( path, ( error, files ) ->
					callback( error == null 
						? Success( files )
						: Failure( Std.string( error ))
					)));
		#else
			throw "Error: Platform not supported.";
		#end
	}
	
	public static function createDirectorySync( path:String ) {
		#if sys
			try {
				sys.FileSystem.createDirectory( path );
				return Future.sync( Success( path ));
			} catch( e:Dynamic ) {
				return Future.sync( Failure( e ));
			}
		#elseif nodejs
			try {
				js.node.Fs.mkdirSync( path );
				return Future.sync( Success( path ));
			} catch( e:Dynamic ) {
				if( Std.string( e ).indexOf( "EEXIST" ) != -1) return Future.sync( Success( path ));
				return Future.sync( Failure( e ));
			}
		#else
			throw "Error: Platform not supported.";
		#end
	}
	
	public static function existsSync( path:String ) {
		#if sys
			try {
				return Future.sync( Success( sys.FileSystem.exists( path )));
			} catch( e:Dynamic ) {
				return Future.sync( Failure( e ));
			}
		#elseif nodejs
			try {
				return Future.sync( Success( js.node.Fs.existsSync( path )));
			} catch( e:Dynamic ) {
				return Future.sync( Failure( e ));
			}
		#else
			throw "Error: Platform not supported.";
		#end
	}

	public static function readDirectorySync( path:String ) {
		#if sys
			try {
				return Future.sync( Success( sys.FileSystem.readDirectory( path )));
			} catch( e:Dynamic ) {
				return Future.sync( Failure( e ));
			}
		#elseif nodejs
			try {
				return Future.sync( Success( js.node.Fs.readdirSync( path )));
			} catch( e:Dynamic ) {
				return Future.sync( Failure( e ));
			}
		#else
			throw "Error: Platform not supported.";
		#end
	}
	
}