package xa3.crossfile.async;

import haxe.Timer;
import haxe.crypto.Md5;
#if nodejs
import js.node.Fs;
#end

using tink.CoreApi;

typedef ChangedFile = {
	final path:String;
	final content:String;
}

class FileWatcher {
	
	static inline var DELAY = 100;
	
	final md5Previous:Map<String,String> = [];
	final fsWaits:Map<String, Bool> = [];
	
	var changedTrigger:SignalTrigger<ChangedFile>;
	public var changed(default, null):Signal<ChangedFile>;

	public function new() {
		changedTrigger = Signal.trigger();
		changed = changedTrigger.asSignal();
	}
	
	public function watch( path:String ) {
		
		trace( 'Watching for file changes on ${path}' );
		
		#if nodejs
		Fs.watch( path, ( event, filename ) -> {
			if( filename != null && event == "change" ) {
				if( fsWaits[path] != true ) {
					fsWaits.set( path, true );
					Timer.delay(() -> {
						fsWaits.set( path, false );
						final f = xa3.crossfile.async.File.getContent( path );
						f.handle( o -> switch o {
							case Success(data):
								final md5Current = Md5.encode( data );
								if( md5Previous.get( path ) != md5Current ) {
									md5Previous.set( path, md5Current );
									// trace( '${path} file Changed' );
									final f:ChangedFile = { path: path, content: data };
									changedTrigger.trigger( f );
								}
							case Failure(failure):
								trace( 'Error: loading file $path' );
								
						});
					}, 100 );
				}
			}
		});
		#else
		throw "Right now only nodejs is implemented. Sorry."
		#end
	}
}
