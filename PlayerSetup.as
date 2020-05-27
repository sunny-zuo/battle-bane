package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class PlayerSetup extends MovieClip {

		public function PlayerSetup() {
			// constructor code
			init();
		}
		
		private function init():void {
			usernameText.maxChars = 16;
			usernameText.restrict = "A-Za-z0-9_"
			
			updateDisplay();
			
			this.increaseHealth.addEventListener(MouseEvent.CLICK, addHealth);
			this.increaseDamage.addEventListener(MouseEvent.CLICK, addDamage);
			this.increaseSpeed.addEventListener(MouseEvent.CLICK, addSpeed);
			this.increaseReload.addEventListener(MouseEvent.CLICK, addReload);
			this.increaseRange.addEventListener(MouseEvent.CLICK, addRange);
			
			this.decreaseHealth.addEventListener(MouseEvent.CLICK, subtractHealth);
			this.decreaseDamage.addEventListener(MouseEvent.CLICK, subtractDamage);
			this.decreaseSpeed.addEventListener(MouseEvent.CLICK, subtractSpeed);
			this.decreaseReload.addEventListener(MouseEvent.CLICK, subtractReload);
			this.decreaseRange.addEventListener(MouseEvent.CLICK, subtractRange);
			
			this.settingsButton.addEventListener(MouseEvent.CLICK, openSettings);
			this.enterBattleButton.addEventListener(MouseEvent.CLICK, enterBattle);
			
			this.usernameText.addEventListener(KeyboardEvent.KEY_UP, updateUsername);
			this.serverText.addEventListener(KeyboardEvent.KEY_UP, updateIP);
			this.addEventListener(Event.REMOVED_FROM_STAGE, cleanUp);
		}
		
		private function updateUsername(event:KeyboardEvent):void {
			Main.playerUsername = usernameText.text;
			Main.updateData();
		}
		
		private function updateIP(event:KeyboardEvent):void {
			Main.serverIP = serverText.text;
			Main.updateData();
		}
		private function updateDisplay():void {
			Main.updateData();
			this.statPointInfo.text = "Stat Points Remaining: " + String(Main.statPoints);
			this.healthInfo.text = "Health: " + String(Main.playerHealth.toFixed(0));
			this.damageInfo.text = "Damage: " + String(Main.playerDamage.toFixed(1));
			this.speedInfo.text = "Speed: " + String(Main.playerSpeed.toFixed(1));
			this.reloadInfo.text = "Reload Speed: " + String(Main.playerReload.toFixed(0));
			this.rangeInfo.text = "Range: " + String(Main.playerRange.toFixed(0));
			usernameText.text = Main.saveData.data.playerUsername;
			serverText.text = Main.saveData.data.serverIP;
		}
		
		private function openSettings (event:MouseEvent):void {
			Main.playerUsername = usernameText.text;
			Main.updateData();
			MovieClip(parent).openSettingsScreen();
		}
		
		private function enterBattle (event:MouseEvent):void {
			Main.playerUsername = usernameText.text;
			Main.updateData();
			MovieClip(parent).openGameHandler();
		}
		
		private function cleanUp (event:Event):void {
			this.increaseHealth.removeEventListener(MouseEvent.CLICK, addHealth);
			this.increaseDamage.removeEventListener(MouseEvent.CLICK, addDamage);
			this.increaseSpeed.removeEventListener(MouseEvent.CLICK, addSpeed);
			this.increaseReload.addEventListener(MouseEvent.CLICK, addReload);
			this.increaseRange.addEventListener(MouseEvent.CLICK, addRange);
			
			this.decreaseHealth.removeEventListener(MouseEvent.CLICK, subtractHealth);
			this.decreaseDamage.removeEventListener(MouseEvent.CLICK, subtractDamage);
			this.decreaseSpeed.removeEventListener(MouseEvent.CLICK, subtractSpeed);
			this.decreaseReload.removeEventListener(MouseEvent.CLICK, subtractReload);
			this.decreaseRange.removeEventListener(MouseEvent.CLICK, subtractRange);
			
			this.settingsButton.removeEventListener(MouseEvent.CLICK, openSettings);
			this.enterBattleButton.removeEventListener(MouseEvent.CLICK, enterBattle);
			this.usernameText.removeEventListener(KeyboardEvent.KEY_DOWN, updateUsername);
			this.serverText.removeEventListener(KeyboardEvent.KEY_UP, updateIP);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUp);
		}
		
		// Adding stuff
		private function addHealth(event:MouseEvent):void {
			if (Main.statPoints > 0) {
				Main.playerHealth += 11;
				Main.statPoints -= 1;
				updateDisplay();
			}
			else {
				return;
			}
		}
		
		private function addDamage(event:MouseEvent):void {
			if (Main.statPoints > 0) {
				Main.playerDamage += 1;
				Main.statPoints -= 1;
				updateDisplay();
			}
			else {
				return;
			}
		}
		
		private function addSpeed(event:MouseEvent):void {
			if (Main.statPoints > 0 && Main.playerSpeed < 4.4) {
				Main.playerSpeed += 0.2;
				Main.statPoints -= 1;
				updateDisplay();
			}
			else {
				return;
			}
		}
		
		private function addRange(event:MouseEvent):void {
			if (Main.statPoints > 0) {
				Main.playerRange += 1;
				Main.statPoints -= 1;
				updateDisplay();
			}
			else {
				return;
			}
		}
		
		private function addReload(event:MouseEvent):void {
			if (Main.statPoints > 1 && Main.playerReload < 24) {
				Main.playerReload += 1;
				Main.statPoints -= 2;
				updateDisplay();
			}
			else {
				return;
			}
		}
		
		// Subtracting stuff
		private function subtractHealth(event:MouseEvent):void {
			if (Main.playerHealth > Main.baseHealth) {
				Main.playerHealth -= 11;
				Main.statPoints += 1;
				updateDisplay();
			}
			else {
				return;
			}
		}
		
		private function subtractDamage(event:MouseEvent):void {
			if (Main.playerDamage > Main.baseDamage) {
				Main.playerDamage -= 1;
				Main.statPoints += 1;
				updateDisplay();
			}
			else {
				return;
			}
		}
		private function subtractSpeed(event:MouseEvent):void {
			if (Main.playerSpeed > Main.baseSpeed) {
				Main.playerSpeed -= 0.20;
				Main.statPoints += 1;
				updateDisplay();
			}
			else {
				return;
			}
		}
		
		private function subtractRange(event:MouseEvent):void {
			if (Main.playerRange > Main.baseRange) {
				Main.playerRange -= 1;
				Main.statPoints += 1;
				updateDisplay();
			}
			else {
				return;
			}
		}
		
		private function subtractReload(event:MouseEvent):void {
			if (Main.playerReload > Main.baseReload) {
				Main.playerReload -= 1;
				Main.statPoints += 2;
				updateDisplay();
			}
			else {
				return;
			}
		}

	}
	
}
