package {
	import flash.display.MovieClip;
	public class MenuHandler extends MovieClip {

		public var splashScreen: SplashScreen;
		public var updateGame: UpdateGame;
		public var connectionFailed: ConnectionFailed;
		public var maintenance: Maintenance;
		public var playerSetup: PlayerSetup;
		public var settingsScreen: SettingsScreen;
		public var gameHandler: GameHandler;
		public var respawnScreen: RespawnScreen;
		public var gameOverlay:GameOverlay;

		public function MenuHandler() {
			// constructor code
		}

		public function openSplashScreen(): void {
			this.removeChildren();
			splashScreen = new SplashScreen();
			splashScreen.x = 0;
			splashScreen.y = 0;
			this.addChild(splashScreen);
		}

		public function openUpdateGame(): void {
			this.removeChildren();
			updateGame = new UpdateGame();
			updateGame.x = 0;
			updateGame.y = 0;
			this.addChild(updateGame);
		}

		public function openConnectionFailed(): void {
			this.removeChildren();
			connectionFailed = new ConnectionFailed();
			connectionFailed.x = 0;
			connectionFailed.y = 0;
			this.addChild(connectionFailed);
		}
		public function openMaintenance(): void {
			this.removeChildren();
			maintenance = new Maintenance();
			maintenance.x = 0;
			maintenance.y = 0;
			this.addChild(maintenance);
		}
		public function openPlayerSetup(): void {
			this.removeChildren();
			playerSetup = new PlayerSetup();
			playerSetup.x = 0;
			playerSetup.y = 0;
			this.addChild(playerSetup);

		}
		public function openSettingsScreen(): void {
			this.removeChildren();
			settingsScreen = new SettingsScreen();
			settingsScreen.x = 0;
			settingsScreen.y = 0;
			this.addChild(settingsScreen);
		}
		public function openGameHandler(): void {
			this.removeChildren();
			gameHandler = new GameHandler();
			gameHandler.x = 0;
			gameHandler.y = 0;
			this.addChild(gameHandler);
		}
		public function openRespawnScreen(killerName: String): void {
			this.removeChildren();
			respawnScreen = new RespawnScreen(killerName);
			respawnScreen.x = 0;
			respawnScreen.y = 0;
			this.addChild(respawnScreen);
		}
		public function openGameOverlay(remove: Boolean = false): void {
			if (remove) {
				this.removeChildren();
				gameOverlay = new GameOverlay();
				gameOverlay.x = 360;
				gameOverlay.y = 240;
				this.addChild(gameOverlay);
			}
			else {
				gameOverlay = new GameOverlay();
				gameOverlay.x = 360;
				gameOverlay.y = 240;
				this.addChild(gameOverlay);
			}
		}
	}
}