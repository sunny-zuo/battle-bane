package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ConnectionFailed extends MovieClip {
				
		public function ConnectionFailed() {
			// constructor code
			exitButton.addEventListener(MouseEvent.CLICK, closeThis);
		}
		
		private function closeThis(event:MouseEvent):void {
			exitButton.removeEventListener(MouseEvent.CLICK, closeThis);
			MovieClip(parent).openSplashScreen();
		}

	}
	
}
