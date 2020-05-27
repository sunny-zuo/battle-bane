package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;

	public class Joystick extends MovieClip {
		
		public static const FIRE:String = "fire"
		
		private var maxRadius: Number;
		private var rotationAngle:Number;
		public var onStage: Boolean = false;

		public function Joystick() {
			GameHandler.stg.addEventListener(TouchEvent.TOUCH_MOVE, updatePos);
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		private function addedToStage(event: Event): void {
			maxRadius = width / 2; // max radius at which the dot will move away from center
		}
		public function updatePos(event: TouchEvent): void {
			if (this == GameHandler.joystickLeft && event.touchPointID == GameHandler.joystickLeftID) {
				var globalPoint: Point = localToGlobal(new Point(0, 0));
				var offsetY: Number = event.stageY - globalPoint.y;
				var offsetX: Number = event.stageX - globalPoint.x;

				//pythagorean theorem below
				var dist: Number = Math.sqrt(Math.pow(offsetX, 2) + Math.pow(offsetY, 2));
				var angle: Number = Math.atan2(offsetY, offsetX); //angle in radians
				rotationAngle = angle;
				if (dist > maxRadius) {
					//out of area where you can drag dot
					joystickDot.x = maxRadius * Math.cos(angle)
					joystickDot.y = maxRadius * Math.sin(angle)
				} else {
					joystickDot.x = offsetX;
					joystickDot.y = offsetY;
				}
			}
			
			else if (this == GameHandler.joystickRight && event.touchPointID == GameHandler.joystickRightID) {
				var globalPoint2: Point = localToGlobal(new Point(0, 0));
				var offsetY2: Number = event.stageY - globalPoint2.y;
				var offsetX2: Number = event.stageX - globalPoint2.x;

				//pythagorean theorem below
				var dist2: Number = Math.sqrt(Math.pow(offsetX2, 2) + Math.pow(offsetY2, 2));
				var angle2: Number = Math.atan2(offsetY2, offsetX2); //angle in radians
				rotationAngle = angle2;
				if (dist2 > maxRadius) {
					//out of area where you can drag dot
					joystickDot.x = maxRadius * Math.cos(angle2)
					joystickDot.y = maxRadius * Math.sin(angle2)
				} else {
					joystickDot.x = offsetX2;
					joystickDot.y = offsetY2;
				}
			}
		}

		public function xOutput(): Number {
			return joystickDot.x / maxRadius;
		}

		public function yOutput(): Number {
			return joystickDot.y / maxRadius
		}
		
		public function angleOutput():Number {
			return rotationAngle * (180/Math.PI);
		}

		public function cleanup(): void {
			GameHandler.stg.removeEventListener(TouchEvent.TOUCH_MOVE, updatePos);
			alpha = 0;
		}

	}

}