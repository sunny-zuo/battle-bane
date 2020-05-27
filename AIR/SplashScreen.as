package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	public class SplashScreen extends MovieClip {
		
		public static var loadStatus:String = undefined;
		public static var newestVersion:String;
		
		public function SplashScreen() {
			// constructor code
			init();
		}
		private function init():void {
			playButton.addEventListener(MouseEvent.CLICK, checkStatus);
			this.versionInfo.text = "version: " + Main.gameVersion;
		}
		
		private function checkStatus(event:MouseEvent):void {
			MovieClip(parent).openPlayerSetup();
			
			/* 
			 * Originally, I had the game download a json file from my webserver where it would check its version and ensure the game was
			 * up and running before connecting to the server. This allowed me to notify users of updates, temporarily shut down the game,
			 * and make sure that everyone was playing on a compatible version (semantic versioning was used) to prevent weird bugs.
			 * However, I can't ensure that my site will always be up, and future me looking back at this project has realized that it makes
			 * much more sense to add version checks with the game server (websocket message telling the server about the client's version
			 * and kicking the player if their version is incompatible). The below code is commented out to remove this feature, which also
			 * renders a few of the screens to be useless.
			*/
			
			/*
			var apiURL:String = "https://sunnyzuo.com/battlebane.json"
			var urlRequest: URLRequest = new URLRequest(apiURL); //creates a URLRequest with the url generated above
			var urlLoader: URLLoader = new URLLoader(); //creates a URLLoader
			urlLoader.addEventListener(Event.COMPLETE, loadComplete) //adds an event listener to trigger when it's loaded
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, failedToLoad); //adds an event listener that triggers if it cannot load

			try {
				urlLoader.load(urlRequest); //tries to load from the URL
			} catch (error: Error) {
				trace("load error " + error); //if there's an error, will trace it
			}*/
		}
		/*
		private function loadComplete(event:Event):void {
			var loader: URLLoader = URLLoader(event.target); //sets the URLLoader to the one generated above
			var loadedData:Object = JSON.parse(loader.data);
			
			newestVersion = loadedData.newestVersion;
			var currentVersionSplit:Array = Main.gameVersion.split(".");
			var newestVersionSplit:Array = loadedData.newestVersion.split(".");
			
			if (loadedData.maintenance == "true") {
				//maintenance mode
				MovieClip(parent).openMaintenance();
			}
			else if (currentVersionSplit[0] < newestVersionSplit[0] || currentVersionSplit[1] < newestVersionSplit[1]) {
				//update required
				MovieClip(parent).openUpdateGame();
			}
			else {
				loadStatus = "success";
				MovieClip(parent).openPlayerSetup();
			}
		}
		
		private function failedToLoad (event:IOErrorEvent):void {
			//connection issue
			loadStatus = "failed";
			MovieClip(parent).openConnectionFailed();
		}*/

	}
	
}
