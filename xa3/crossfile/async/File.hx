package xa3.crossfile.async;

using tink.CoreApi;
class File {
	
	public static function getContent( path:String ) {
		#if sys
			try {
				return Future.sync( Success( sys.io.File.getContent( path )));
			} catch( e:String ) {
				return Future.sync( Failure( e ));
			}
		#elseif nodejs
			return Future.irreversible( callback ->
				js.node.Fs.readFile( path, ( error, data ) ->
					callback( error == null
						? Success( data.toString())
						: Failure( Std.string( error )))));
		#else
			throw "Error: Platform not supported.";
			return null;
		#end
	}

	public static function saveContent( path:String, content:String ) {
		#if sys
			try {
				sys.io.File.saveContent( path, content );
				return Future.sync( Success( path ));
			} catch( e:String ) {
				return Future.sync( Failure( e ));
			}
		#elseif nodejs
			return Future.irreversible( callback ->
				js.node.Fs.writeFile( path, content, error ->
					callback( error == null
						? Success( path )
						: Failure( Std.string( error )))));
		#else
			throw "Error: Platform not supported.";
		#end
	}

	public static function getContentSync( path:String ) {
		#if sys
			try {
				return Future.sync( Success( sys.io.File.getContent( path )));
			} catch( e:String ) {
				return Future.sync( Failure( e ));
			}
		#elseif nodejs
			try {
				return Future.sync( Success( js.node.Fs.readFileSync( path ).toString()));
			} catch( e:String ) {
				return Future.sync( Failure( e ));
			}
		#else
			throw "Error: Platform not supported.";
		#end
	}

	public static function saveContentSync( path:String, content:String ) {
		#if sys
			try {
				sys.io.File.saveContent( path, content );
				return Future.sync( Success( path ));
			} catch( e:String ) {
				return Future.sync( Failure( e ));
			}
		#elseif nodejs
			try {
				js.node.Fs.writeFileSync( path, content );
				return Future.sync( Success( path ));
			} catch( e:String ) {
				return Future.sync( Failure( e ));
			}
		#else
			throw "Error: Platform not supported.";
		#end
	}


}