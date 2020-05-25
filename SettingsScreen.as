package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	public class SettingsScreen extends MovieClip {
		
		public function SettingsScreen() {
			// constructor code
			init();
		}
		
		private function init():void {
			serverNameInput.restrict = "a-zA-Z0-9";
			serverNameInput.maxChars = 10;
			
			serverNameInput.text = Main.saveData.data.nameOfServer;
			
			if (Main.privateServerEnabled) {
				this.xMark.visible = false;
				this.checkmark.visible = true;
			}
			else {
				this.xMark.visible = true;
				this.checkmark.visible = false;
			}
			
			xMark.addEventListener(MouseEvent.CLICK, changeState);
			checkmark.addEventListener(MouseEvent.CLICK, changeState);
			exitButton.addEventListener(MouseEvent.CLICK, closeThis);
			serverNameInput.addEventListener(KeyboardEvent.KEY_UP, updateServerName);
		}
		
		private function changeState(event:MouseEvent) {
			if (Main.privateServerEnabled) {
				Main.privateServerEnabled = false;
				Main.nameOfServer = "public";
				this.xMark.visible = true;
				this.checkmark.visible = false;
			}
			else if (!Main.privateServerEnabled) {
				Main.privateServerEnabled = true;
				Main.nameOfServer = serverNameInput.text;
				this.xMark.visible = false;
				this.checkmark.visible = true;
			}
			
			Main.updateData();
		}
		
		private function updateServerName (event:KeyboardEvent):void {
			Main.nameOfServer = serverNameInput.text;
			Main.updateData();
		}
		private function closeThis(event:MouseEvent):void {
			Main.nameOfServer = serverNameInput.text;
			Main.updateData();
			
			exitButton.removeEventListener(MouseEvent.CLICK, closeThis);
			xMark.removeEventListener(MouseEvent.CLICK, changeState);
			checkmark.removeEventListener(MouseEvent.CLICK, changeState);
			serverNameInput.removeEventListener(KeyboardEvent.KEY_DOWN, updateServerName);
			
			MovieClip(parent).openPlayerSetup();
		}

	}
	
}
