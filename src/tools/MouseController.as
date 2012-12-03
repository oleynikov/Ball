package src.tools{
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	public class MouseController extends MovieClip {
		private var mouseHolder:Object;
		private var mousePosition:Array;
		public function MouseController ():void {
			this.addEventListener (Event.ADDED_TO_STAGE,eventAddedToStage);
		}
		public function get getSpeedHor ():Number {
			var mousePosHorCurr:Number;//Текущая координата курсора
			var mousePosHorDiff:Number;// Разница между предыдущей и текущей координатой
			mousePosHorCurr = this.mouseHolder.mouseX;// Текущая координата мыши
			mousePosHorDiff = mousePosHorCurr - this.mousePosition[0];// Разность координат
			this.mousePosition[0] = mousePosHorCurr;// Текущая координата сохраняется как устаревшая
			return mousePosHorDiff;// Возвращаем разность координат
		}
		public function get getSpeedVert ():Number {
			var mousePosVertCurr:Number = new Number  ;//Текущая координата курсора
			var mousePosVertDiff:Number = new Number  ;// Разница между предыдущей и текущей координатой
			mousePosVertCurr = this.mouseHolder.mouseY;// Текущая координата мыши
			mousePosVertDiff = mousePosVertCurr - this.mousePosition[1];// Разность координат
			this.mousePosition[1] = mousePosVertCurr;// Текущая координата сохраняется как устаревшая
			return mousePosVertDiff;// Возвращаем разность координат
		}
		private function eventAddedToStage (event:Event):void {
			this.mousePosition = new Array();
			this.mousePosition.push ([0],[0]);
			this.mouseHolder = this.parent;
		}
	}
}