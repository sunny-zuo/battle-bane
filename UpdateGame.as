package  {
	import flash.display.MovieClip;
	public class UpdateGame extends MovieClip {

		public function UpdateGame() {
			// constructor code
			newVersionInfo.text = "The newest version is " + SplashScreen.newestVersion + " You are using version " + Main.gameVersion;
		}

	}
	
}
