package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Bullet extends MovieClip {

		public var creatorName: String;
		private var direction2: Number;
		private var xValue: Number;
		private var yValue: Number;
		public var damage: Number;
		private var _root: MovieClip;

		private var lifeCount:int = 16;
		private var updateCount:int = 0;

		private var vx: Number;
		private var vy: Number;
		
		private var lifeTimer:Timer;

		private var speed: Number = 20;

		public function Bullet(direction2: Number, creatorName: String, xValue: Number, yValue: Number, damage: Number, bulletLifetime:Number) {
			// constructor code
			this.direction2 = direction2 - 90;
			this.xValue = xValue;
			this.yValue = yValue;
			this.creatorName = creatorName;
			this.damage = damage
			this.lifeCount = bulletLifetime;
			init();
		}

		private function init(): void {

			_root = MovieClip(root);
			graphics.beginFill(0x000000);
			graphics.drawCircle(0, 0, 6);
			graphics.endFill();

			this.x = xValue + Math.cos(direction2 * Math.PI / 180);
			this.y = yValue + Math.sin(direction2 * Math.PI / 180);

			vx = Math.cos(direction2 * Math.PI / 180) * speed;
			vy = Math.sin(direction2 * Math.PI / 180) * speed;
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}

		public function updatePos():void {
			this.x += vx;
			this.y += vy;
			updateCount++
			if (updateCount >= lifeCount) {
				this.parent.removeChild(this);
			}
		}
				
		private function removedFromStage(e:Event) {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}

	}

}