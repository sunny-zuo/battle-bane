package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.Sprite;
	import flash.net.SharedObject;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import com.mesmotronic.ane.AndroidFullScreen;

	public class Main extends MovieClip {

		//static vars
		public static var gameVersion = "1.1.4";
		public static var serverIP = "ws://127.0.0.1:8080";

		//shared object to persist data across sessions
		public static var saveData: SharedObject = SharedObject.getLocal("yI7QAeS6Zy");

		//other classes
		public static var menuHandler: MenuHandler;

		//timers
		private var loadCheckTimer: Timer;

		//player spec
		public static var playerHealth: Number = 100;
		public static var playerDamage: Number = 10;
		public static var playerSpeed: Number = 3;
		public static var playerRange: Number = 12;
		public static var playerReload: Number = 16;
		public static var statPoints: int = 20;

		public static var nameOfServer: String = "public";
		public static var privateServerEnabled: Boolean = false;
		public static var playerUsername: String;

		public static var baseHealth: Number = 100;
		public static var baseDamage: Number = 10;
		public static var baseSpeed: Number = 3;
		public static var baseRange: Number = 12;
		public static var baseReload: Number = 16;

		public function Main() {
			// constructor code
			init();
		}

		private function init(): void {
			menuHandler = new MenuHandler();
			addChild(menuHandler);
			//loads splash screen
			AndroidFullScreen.stage = stage;
			AndroidFullScreen.fullScreen();

			if (!AndroidFullScreen.showUnderSystemUI()) {
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}

			menuHandler.openSplashScreen();
			initData();
		}

		public static function updateData(): void {
			saveData.data.playerHealth = playerHealth;
			saveData.data.playerDamage = playerDamage;
			saveData.data.playerSpeed = playerSpeed;
			saveData.data.playerRange = playerRange;
			saveData.data.playerReload = playerReload;
			
			saveData.data.statPoints = statPoints;

			saveData.data.nameOfServer = nameOfServer;
			saveData.data.privateServerEnabled = privateServerEnabled;
			saveData.data.playerUsername = playerUsername;
			saveData.data.serverIP = serverIP;

			saveData.flush();
		}
		private function initData(): void {
			if (isNaN(saveData.data.playerHealth)) {
				saveData.data.playerHealth = playerHealth;
			} else {
				playerHealth = saveData.data.playerHealth;
			}
			if (isNaN(saveData.data.playerDamage)) {
				saveData.data.playerDamage = playerDamage;
			} else {
				playerDamage = saveData.data.playerDamage;
			}
			if (isNaN(saveData.data.playerSpeed)) {
				saveData.data.playerSpeed = playerSpeed;
			} else {
				playerSpeed = saveData.data.playerSpeed;
			}
			if (isNaN(saveData.data.playerRange)) {
				saveData.data.playerRange = playerRange;
			} else {
				playerRange = saveData.data.playerRange;
			}
			if (isNaN(saveData.data.playerReload)) {
				saveData.data.playerReload = playerReload;
			} else {
				playerReload = saveData.data.playerReload;
			}
			if (isNaN(saveData.data.statPoints)) {
				saveData.data.statPoints = statPoints;
			} else {
				statPoints = saveData.data.statPoints;
			}
			if (saveData.data.nameOfServer == null) {
				saveData.data.nameOfServer = nameOfServer;
			} else {
				nameOfServer = saveData.data.nameOfServer;
			}
			if (saveData.data.privateServerEnabled) {
				privateServerEnabled = saveData.data.privateServerEnabled;
			}
			if (saveData.data.playerUsername == null && playerUsername == null) {
				playerUsername = "User" + String(Math.floor(Math.random() * 99999));
				saveData.data.playerUsername = playerUsername;
			} else {
				playerUsername = saveData.data.playerUsername;
			}
			
			if (saveData.data.serverIP == null) {
				saveData.data.serverIP = serverIP;
			} else {
				serverIP = saveData.data.serverIP;
			}

			saveData.flush();
		}

	}

}