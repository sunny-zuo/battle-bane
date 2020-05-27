package  {
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	public class RespawnScreen extends MovieClip {
		
		private var killerName:String;
		
		public function RespawnScreen(killerNamePass:String) {
			// constructor code
			init(killerNamePass);
		}
		private function init(killerNamePass:String):void {
			this.killerName = killerNamePass;
			this.killerInfoText.text = "Shot by " + killerName;
			this.respawnButton.addEventListener(MouseEvent.CLICK, startRespawn);
			this.mainMenuButton.addEventListener(MouseEvent.CLICK, startMainMenu);
		}
		
		private function startRespawn(event:MouseEvent):void {
			MovieClip(parent).openGameHandler();
			GameHandler.hasConnected = true;
		}
		
		private function startMainMenu(event:MouseEvent):void {
			MovieClip(parent).openSplashScreen();
			GameHandler.hasConnected = false;
		}
	}
	
}
