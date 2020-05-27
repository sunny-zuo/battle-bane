package {
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.DataEvent;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.display.Graphics;

	import com.worlize.websocket.WebSocket;
	import com.worlize.websocket.WebSocketEvent;
	import com.worlize.websocket.WebSocketMessage;
	import com.worlize.websocket.WebSocketErrorEvent;

	public class GameHandler extends MovieClip {
		public static var hasConnected = false;

		private var player: Player;
		private var healthBar: HealthBar;
		private var bullet: Bullet;
		private var vCam:Vcam;
		private var walls: Walls;

		private var bulletPath: BulletPath = new BulletPath();

		private var bulletCount: int = 3;
		private var bulletLifetime: Number = Main.saveData.data.playerRange;
		private var maxBulletPathLength: Number = 18.75 * bulletLifetime;
		private var ammoIncrease: int;
		private var ammoIncreaseTarget: int = 16 - (Main.saveData.data.playerReload - 16);

		private var charInfo: Array;
		private var chatArray: Array;
		private var bulletInfo: Array;
		private var bulletArray: Array;

		private var bulletPathPreview: Graphics = graphics;

		private var xPos: Number;
		private var yPos: Number;
		
		private var lastHitBy:String = "nullXXXXXXXXXXXXX"

		private var health: Number = Main.saveData.data.playerHealth;
		private var maxHealth: Number = Main.saveData.data.playerHealth;

		private var damage: Number = Main.saveData.data.playerDamage;
		private var speed: Number = Main.saveData.data.playerSpeed;
		private var username: String = Main.saveData.data.playerUsername;
		private var direction: Number;

		private var updateTimer: Timer = new Timer(40);
		private var newSpawn: Boolean;

		private var serverName: String = Main.saveData.data.nameOfServer;
		private var websocket: WebSocket;
		private var startUpdates: Boolean = false;

		private var _root: MovieClip = MovieClip(root);
		
		private var wKey: Boolean = false		
		private var aKey: Boolean = false		
		private var sKey: Boolean = false		
		private var dKey: Boolean = false

		public function GameHandler() {
			// constructor code
			construct();
		}

		private function construct(): void {
			//generates random position for player to spawn
			xPos = Math.random() * 960 + 20;
			yPos = Math.random() * 960 + 20;

			startUpdates = false; //indicate that updates are not started

			//sets player stats to what was generated in PlayerSetup
			health = Main.saveData.data.playerHealth;
			damage = Main.saveData.data.playerDamage;
			speed = Main.saveData.data.playerSpeed;
			bulletLifetime = Main.saveData.data.playerRange;
			maxBulletPathLength = 18.75 * bulletLifetime;
			ammoIncreaseTarget = 16 - (Main.saveData.data.playerReload - 16);
			direction = 0;

			if (maxBulletPathLength > 500) {
				maxBulletPathLength = 500
			}

			//creates arrays for game data
			charInfo = new Array(); //stores the user info, and is broadcasted
			charInfo = [serverName, "gameData", username, xPos, yPos, direction, health, maxHealth, damage];
			bulletArray = new Array(); //stores all bullets in the game
			chatArray = new Array(); //stores chat

			addEventListener(Event.ADDED_TO_STAGE, addedToStage);

			bulletCount = 3; //gives player full bullets when spawned
			newSpawn = true; //notes that the player has just spawned for the code that moves spawn location if player stuck
			addChild(bulletPath);

			//creates new connection to websocket server
			websocket = new WebSocket(Main.serverIP, "*");
			websocket.addEventListener(WebSocketEvent.OPEN, onConnected);
			websocket.addEventListener(WebSocketErrorEvent.CONNECTION_FAIL, handleConnectionFail);
			websocket.connect();
		}

		private function addedToStage(event: Event): void {
			SkyCollisionDetection.registerRoot(this); // sets the root location for collision testing
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown); //movement key events
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp); //movement key events
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage); //clean up event listener
		}

		private function onConnected(event: WebSocketEvent): void {
			if (!hasConnected) {
				websocket.sendUTF(serverName + ",connectData," + username);
				hasConnected = true;
			}
			else {
				websocket.sendUTF(serverName + ",respawnData," + username);
			}
			
			//create overlay
			MovieClip(parent).openGameOverlay();
			
			//enable processing server data & allows bullets to be fired
			websocket.addEventListener(WebSocketEvent.MESSAGE, onIncomingData);
			stage.addEventListener(MouseEvent.MOUSE_UP, fireBullet);		
			websocket.removeEventListener(WebSocketEvent.OPEN, onConnected); //removes this event listener as it is not needed
			//create walls
			walls = new Walls();
			addChild(walls);

			vCam = new Vcam(0, 0, stage.stageWidth, stage.stageHeight);

			//begins the timer that updates the game display
			if (!startUpdates) { //
				updateTimer.start();
				updateTimer.addEventListener(TimerEvent.TIMER, update);
				startUpdates = true;
			}

		}

		private function update(event: TimerEvent): void {
			var canMove: Boolean = true;

			//if bullets aren't at max, increase the reload value
			if (bulletCount < 3) {
				ammoIncrease++;
			}
			//if the reload value meets the reload speed, reset value and add a bullet
			if (ammoIncrease >= ammoIncreaseTarget) {
				ammoIncrease = 0;
				bulletCount++;
			}

			//modify ammo display to reflect available bullet count
			MovieClip(parent).gameOverlay.ammoDisplay.ammoBar.width = (bulletCount * 68) + Math.floor((ammoIncrease / ammoIncreaseTarget) * 68)

			//runs player movement commands if the player exists
			if (Boolean(this.getChildByName(username)) == true) {
				var target2: MovieClip = this.getChildByName(username) as MovieClip; //selects the player

				//determines direction the player is facing
				var globalPoint: Point = target2.localToGlobal(new Point(0, 0));
				var dist_Y: Number = stage.mouseY - globalPoint.y;
				var dist_X: Number = stage.mouseX - globalPoint.x;
				var angle2: Number = Math.atan2(dist_Y, dist_X);
				var degrees: Number = angle2 * 180 / Math.PI;
				charInfo[5] = degrees + 90;

				//if the player just spawned and is colliding with the wall, change spawn location
				while (newSpawn && SkyCollisionDetection.bitmapHitTest(target2, walls)) {
					target2.x = Math.random() * 960 + 20;
					target2.y = Math.random() * 960 + 20;

					if (!SkyCollisionDetection.bitmapHitTest(target2, walls)) {
						charInfo[3] = target2.x;
						charInfo[4] = target2.y;
						newSpawn = false;
					}
				}

				newSpawn = false; //reflect that player has spawned successfully

				//update info of each bullet
				for (var i: int = 0; i < bulletArray.length; i++) {
					if (getChildByName(bulletArray[i])) {
						var target: MovieClip = this.getChildByName(bulletArray[i]) as MovieClip;

						target.updatePos(); //runs movement update for each bullet

						//remove bullet if it hit the wall
						if (SkyCollisionDetection.bitmapHitTest(walls, target)) {
							target.parent.removeChild(target);
							bulletArray.splice(i, 1);
						}

						//remove bullet if hit player
						if (SkyCollisionDetection.bitmapHitTest(target, target2) && target.creatorName != username) {
							charInfo[6] -= target.damage;
							lastHitBy = target.creatorName;
							target.parent.removeChild(target);
							bulletArray.splice(i, 1);

							//deconstructs game if player is dead
							if (charInfo[6] <= 0) {
								//broadcast to other clients that player is dead
								websocket.sendUTF(String([serverName, "deathData", username, target.creatorName]));
								deconstruct(target.creatorName);
								return;
							}
						}
					} else {
						bulletArray.splice(i, 1); //if bullet no longer exists, stop checking it for updates
					}
				}

			}

			websocket.sendUTF(String(charInfo)); //broadcast new character info after all changes are done
		}

		private function updatePlayerMovement() {
			if (Boolean(this.getChildByName(username)) == true) {
				//if the player exists, select it
				var target2: MovieClip = this.getChildByName(username) as MovieClip;
				var xPos = target2.x;
				var yPos = target2.y;
				if (wKey) {
					target2.y = charInfo[4] - speed;
					if (!SkyCollisionDetection.bitmapHitTest(target2, walls)) {
						charInfo[4] -= speed; //change location to be broadcast						}
						target2.y = yPos //changes player location back to where it was
					}
				}
				if (sKey) {
					target2.x = charInfo[3];
					target2.y = charInfo[4] + speed;
					if (!SkyCollisionDetection.bitmapHitTest(target2, walls)) {
						charInfo[4] += speed; //change location to be broadcast						}
						target2.y = yPos //changes player location back to where it was
					}
					target2.x = xPos;
					target2.y = yPos;
				}
				if (aKey) {
					target2.x = charInfo[3] - speed;
					target2.y = charInfo[4];
					if (!SkyCollisionDetection.bitmapHitTest(target2, walls)) {
						charInfo[3] -= speed; //change location to be broadcast						}
						target2.x = xPos //changes player location back to where it was
					}
					target2.x = xPos;
					target2.y = yPos;
				}
				if (dKey) {
					target2.x = charInfo[3] + speed;
					target2.y = charInfo[4];
					if (!SkyCollisionDetection.bitmapHitTest(target2, walls)) {
						charInfo[3] += speed; //change location to be broadcast						}
						target2.x = xPos //changes player location back to where it was
					}
					target2.x = xPos;
					target2.y = yPos;
				}
			}
		}

		private function onIncomingData(event: WebSocketEvent): void {
			//function that runs when data is received
			if (event.message.type === WebSocketMessage.TYPE_UTF8) { //makes sure the data is a string and not binary
				var currentInfo: Array = new Array; //creates an array to store the split data
				currentInfo = event.message.utf8Data.split(","); //splits the data and stores in array
				/*
				[0] = server name
				[1] = type of message (gameData, bullet, deathData)
				
				For players:
				[2] = player name
				[3] = player x value
				[4] = player y value
				[5] = player orientation
				[6] = player current health
				[7] = player max health
				*/
				if (currentInfo[0] != serverName) {
					return; //exits if the data is for a different server
				}

				if (currentInfo[1] == "gameData") {
					if (Boolean(this.getChildByName(currentInfo[2])) == false) {
						player = new Player();
						healthBar = new HealthBar();

						player.x = currentInfo[3];
						player.y = currentInfo[4];

						healthBar.x = player.x;
						healthBar.y = player.y + 21;

						player.rotation = currentInfo[5];
						
						if (currentInfo[2] == username) {
							vCam.swapTarget(player);
						}

						var healthName: String = currentInfo[2] + "Health";

						healthBar.name = healthName;
						healthBar.usernameText.text = currentInfo[2];
						player.name = currentInfo[2];

						addChild(player);
						addChild(healthBar);

						var clearTextTimer1: Timer;

					} else if (Boolean(this.getChildByName(currentInfo[2])) == true) {
						var target: MovieClip = this.getChildByName(currentInfo[2]) as MovieClip;
						
						target.x = currentInfo[3];
						target.y = currentInfo[4];
						target.rotation = currentInfo[5];

						var healthName2: String = currentInfo[2] + "Health";
						var healthTarget: MovieClip = this.getChildByName(healthName2) as MovieClip;
						healthTarget.healthDisplay.width = currentInfo[6] / currentInfo[7] * 40;

						healthTarget.x = target.x;
						healthTarget.y = target.y + 21;

						//target.lastConnection = 0;

						if (currentInfo[2] == username) {
							bulletPath.x = target.x;
							bulletPath.y = target.y;
							bulletPath.bulletPredictionPath.width = 0;
							bulletPath.rotation = (target.rotation - 90);
							bulletPath.alpha = 0.5;
							while (!SkyCollisionDetection.bitmapHitTest(bulletPath, walls) && bulletPath.bulletPredictionPath.width <= maxBulletPathLength) {
								bulletPath.bulletPredictionPath.width += 50;
							}
							bulletPath.bulletPredictionPath.width -= 50;
							while (!SkyCollisionDetection.bitmapHitTest(bulletPath, walls) && bulletPath.bulletPredictionPath.width <= maxBulletPathLength) {
								bulletPath.bulletPredictionPath.width += 10;
							}

							updatePlayerMovement()
						}
					}

				} else if (currentInfo[1] == "bullet") {
					/*
					[0] = server name
					[1] = type of message (gameData, bullet, deathData)
					
					For bullet:
					[2] = direction of bullet
					[3] = creator name
					[4] = x position of bullet
					[5] = y position of bullet
					[6] = damage of bullet
					*/

					bullet = new Bullet(currentInfo[2], currentInfo[3], currentInfo[4], currentInfo[5], currentInfo[6], currentInfo[7]);
					//bullet.cacheAsBitmap = true;
					bullet.x = currentInfo[4];
					bullet.y = currentInfo[5];

					//provides bullet a numeric name and adds it to the array
					var numberingSuccess: Boolean = false;
					var i: int = 1;

					while (!numberingSuccess) {
						if (bulletArray.indexOf(i) < 0) { //if the bullet number does not exist, 
							bullet.name = String(i); //give the new bullet the number as a name
							bulletArray.push(i);
							numberingSuccess = true;
						} else {
							i++ //increase number if current number is not valid
						}
					}
					addChild(bullet); //adds bullet to stage
				} else if (currentInfo[1] == "deathData" && currentInfo[2] != username && Boolean(this.getChildByName(currentInfo[2]))) {
					/* if news of a death is received, remove the player from game
					[2] = name of dead person
					[3] = name of killer
					*/
					var target3: MovieClip = this.getChildByName(currentInfo[2]) as MovieClip; //select player by name
					var healthTarget3: MovieClip = this.getChildByName(currentInfo[2] + "Health") as MovieClip; //select health bar of player
					target3.parent.removeChild(target3); //remove both
					healthTarget3.parent.removeChild(healthTarget3);
					target3 = null;

					var clearTextTimer: Timer

					if (currentInfo[3] == username) {
						chatArray.push("You killed " + currentInfo[2]);
						if ((charInfo[6] / charInfo[7]) < 0.5) {
							charInfo[6] += (charInfo[7] * 0.5)
						} else {
							charInfo[6] = charInfo[7]
						}
						updateText();
						clearTextTimer = new Timer(8000, 1);
						clearTextTimer.start();
						clearTextTimer.addEventListener(TimerEvent.TIMER_COMPLETE, updateTextTimer);
					} else if (currentInfo[3] == "nullXXXXXXXXXXXXX") {
						chatArray.push(currentInfo[2] + " left the game");
						updateText();
						clearTextTimer = new Timer(8000, 1);
						clearTextTimer.start();
						clearTextTimer.addEventListener(TimerEvent.TIMER_COMPLETE, updateTextTimer);
					} else {
						chatArray.push(currentInfo[2] + " was killed by " + currentInfo[3]);
						updateText();
						clearTextTimer = new Timer(8000, 1);
						clearTextTimer.start();
						clearTextTimer.addEventListener(TimerEvent.TIMER_COMPLETE, updateTextTimer);
					}
				} else if (currentInfo[1] == "connectData") {
					chatArray.push(currentInfo[2] + " joined the game");
					updateText();
					clearTextTimer1 = new Timer(8000, 1);
					clearTextTimer1.start();
					clearTextTimer1.addEventListener(TimerEvent.TIMER_COMPLETE, updateTextTimer);
				}
				else if (currentInfo[1] == "respawnData") {
					chatArray.push(currentInfo[2] + " has respawned");
					updateText();
					clearTextTimer1 = new Timer(8000, 1);
					clearTextTimer1.start();
					clearTextTimer1.addEventListener(TimerEvent.TIMER_COMPLETE, updateTextTimer);
				}
			}
		}

		public function fireBullet(event:MouseEvent) {
			//if there is a bullet, fire it
			if (bulletCount > 0) {
				bulletInfo = new Array(); //creates array to store bullet info
				bulletInfo = [serverName, "bullet", charInfo[5], username, charInfo[3], charInfo[4], damage, bulletLifetime];
				websocket.sendUTF(String(bulletInfo)) //sends the bullet info to socket
				bulletCount -= 1; //consumes bullet
			}
		}

		private function deconstruct(killerName: String): void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown); //remove game event listeners		
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);		
			stage.removeEventListener(MouseEvent.MOUSE_UP, fireBullet);

			// deconstruct is run when local player is dead
			updateTimer.stop();
			updateTimer.removeEventListener(TimerEvent.TIMER, update); // stop updates and remove event listener
			websocket.removeEventListener(WebSocketEvent.MESSAGE, onIncomingData); //stop listening for new data

			charInfo = null; //remove charInfo and websocket
			websocket = null;
			MovieClip(parent).openRespawnScreen(killerName); //create respawn screen
		}

		private function handleConnectionFail(event: WebSocketErrorEvent): void {
			trace("Connection Failure: " + event.text); //if connection failed, log error and display that connection failed
			MovieClip(parent).openConnectionFailed();
		}

		private function updateTextTimer(event: TimerEvent): void {
			chatArray.shift();
			updateText();
		}

		private function updateText(): void {
			if (MovieClip(parent).gameOverlay.killedInfo.text != null) {
				MovieClip(parent).gameOverlay.killedInfo.text = "";
				for (var i: int = 0; i < chatArray.length; i++) {
					MovieClip(parent).gameOverlay.killedInfo.appendText(chatArray[i] + "\n")
				}
			}
		}
		private function keyDown(event: KeyboardEvent) {
			if (event.keyCode == 65) { //a key
				aKey = true
			}
			if (event.keyCode == 68) { //d key
				dKey = true
			}
			if (event.keyCode == 87) { //w key
				wKey = true
			}
			if (event.keyCode == 83) { //s key
				sKey = true
			}
		}
		private function keyUp(event: KeyboardEvent) {
			if (event.keyCode == 65) { //a key
				aKey = false
			}
			if (event.keyCode == 68) { //d key
				dKey = false
			}
			if (event.keyCode == 87) { //w key
				wKey = false
			}
			if (event.keyCode == 83) { //s key
				sKey = false
			}

		}

	}
}