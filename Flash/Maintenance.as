package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	public class Maintenance extends MovieClip {

		public function Maintenance() {
			// constructor code
			exitButton.addEventListener(MouseEvent.CLICK, closeThis);
		}
		
		private function closeThis(event:MouseEvent):void {
			exitButton.removeEventListener(MouseEvent.CLICK, closeThis);
			MovieClip(parent).openSplashScreen();
		}
	}
	
}
