package src.sprites{



	// ИМПОРТ НЕОБХОДИМЫХ КЛАССОВ
	import src.tools.MouseController;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	


	// КЛАСС - ШАР
	public class Ball extends Sprite {
		
		// ПЕРЕМЕННЫЕ
		private var __radius:uint;								// РАДИУС
		private var __color:uint;								// ЦВЕТ
		private var __alpha:uint;								// ПРОЗРАЧНОСТЬ
		private var __speedHor:Number;							// ГОРИЗОНТАЛЬНАЯ СКОРОСТЬ
		private var __speedVert:Number;							// ВЕРТИКАЛЬНАЯ СКОРОСТЬ
		private var __isMoving:Boolean;							// ШАР ДВИЖЕТСЯ
		private var __weight:Number;							// ВЕС ШАРА
		private var __speedFade:Number;							// УГАСАНИЕ СКОРОСТИ
		private var __maxX:uint;								// НАИБОЛЬШЕЕ Х
		private var __maxY:uint;								// НАИБОЛЬШЕЕ У
		private var __containerWidth:uint;						// ШИРИНА КОНТЕЙНЕРА
		private var __containerHeight:uint;						// ВЫСОТА КОНТЕЙНЕРА
		private var __mouseController:MouseController;				// КОНТРОЛЛЕР МЫШИ
		private var __mouseSpeedHor:Number;						// ГОРИЗОНТАЛЬНАЯ СКОРОСТЬ МЫШИ
		private var __mouseSpeedVert:Number;					// ВЕРТИКАЛЬНАЯ СКОРОСТЬ МЫШИ
		
		// КОНСТАНТЫ
		private const __maxSpeedHor:Number = new Number(10);	// МАКСИМАЛЬНАЯ ГОРИЗОНТАЛЬНАЯ СКОРОСТЬ
		private const __maxSpeedVert:Number = new Number(10);	// МАКСИМАЛЬНАЯ ВЕРТИКАЛЬНАЯ СКОРОСТЬ
		private static const __g:Number = new Number(0.98);		// УСКОРЕНИЕ СВОБОДНОГО ПАДЕНИЯ
		
		// КОНСТРУКТОР
		public function Ball	(	__radius:uint,				// РАДИУС
								 	__speedHor:Number,			// ГОРИЗОНТАЛЬНАЯ СКОРОСТЬ
									__speedVert:Number,			// ВЕРТИКАЛЬНАЯ СКОРОСТЬ
									__speedFade:Number,			// УГАСАНИЕ СКОРОСТИ
									__color:uint,				// ЦВЕТ
									__alpha:uint,				// ПРОЗРАЧНОСТЬ
									__isMoving:Boolean			// ШАР ДВИЖЕТСЯ
								):void {
			this.__radius = __radius;
			this.__color = __color;
			this.__alpha = __alpha;
			this.__speedHor = __speedHor;
			this.__speedVert = __speedVert;
			this.__speedFade = __speedFade;
			this.__isMoving = __isMoving;
			this.__mouseController = new MouseController();
			this.addEventListener (Event.ADDED_TO_STAGE,_EventAddedToStage);
		}

		// РИСУЕМ ШАР
		private function _DrawBall ():void {
			var thisShape:Shape = new Shape();
				thisShape.graphics.beginFill (this.__color,this.__alpha);
				thisShape.graphics.drawCircle (this.__radius,this.__radius,this.__radius);
				thisShape.graphics.endFill ();
			this.addChild (thisShape);
		}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//	СОБЫТИЯ
//
		// ШАР ДОБАВЛЕН НА СЦЕНУ
		private function _EventAddedToStage (event:Event):void {
			this.__maxX = this.parent.width - 2 * this.__radius;
			this.__maxY = this.parent.height - 2 * this.__radius;
			this.parent.addChild (this.__mouseController);
			this._DrawBall ();
			this.addEventListener (Event.ENTER_FRAME,_EventEnterFrame);
			this.addEventListener (MouseEvent.MOUSE_DOWN,_EventMouseDown);
		}
		// НАЧАЛО КАДРА
		private function _EventEnterFrame (event:Event):void {
			this._BallMove();
			this._BallSpeedFade();
		}
		// НАЖАТА МЫШЬ
		private function _EventMouseDown (event:Event):void {
			this._BallPick();
		}
		// ПЕРЕДВИНУТА МЫШЬ
		private function _EventMouseMove (event:Event):void {
			this._BallDragOutCheck ();
			this.__mouseSpeedHor = this.__mouseController.getSpeedHor;
			this.__mouseSpeedVert = this.__mouseController.getSpeedVert;
			if (this.__mouseSpeedHor > this.__maxSpeedHor) {
				this.__mouseSpeedHor = this.__maxSpeedHor;
			}
			else if (this.__mouseSpeedHor<-this.__maxSpeedHor) {
				this.__mouseSpeedHor =  -  this.__maxSpeedHor;
			}
			if (this.__mouseSpeedVert > this.__maxSpeedVert) {
				this.__mouseSpeedVert = this.__maxSpeedVert;
			}
			else if (this.__mouseSpeedVert<-this.__maxSpeedVert) {
				this.__mouseSpeedVert =  -  this.__maxSpeedVert;
			}
		}
		// ОТПУЩЕНА МЫШЬ
		private function _EventMouseUp (event:Event):void {
			this._BallThrow ();
		}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//	МЕТОДЫ
//
		// ДВИГАЕМ ШАР
		private function _BallMove ():void {
			if (this.__isMoving) {
				this._BallEscapeCheck();
				this.x +=  this.__speedHor;
				this.y +=  this.__speedVert;
			}
		}
		// ВЗЯТЬ ШАР В РУКУ
		private function _BallPick ():void {
			this.__isMoving = false;
			this.startDrag ();
			this.addEventListener (MouseEvent.MOUSE_UP,_EventMouseUp);
			this.addEventListener (Event.ENTER_FRAME,_EventMouseMove);
		}
		// БРОСИТЬ ШАР
		private function _BallThrow ():void {
			this.stopDrag ();
			this.__speedHor = this.__mouseSpeedHor;
			this.__speedVert = this.__mouseSpeedVert;
			this.__isMoving = true;
			this.removeEventListener (MouseEvent.MOUSE_UP,_EventMouseUp);
			this.removeEventListener (Event.ENTER_FRAME,_EventMouseMove);
		}
		// УГАСАНИЕ СКОРОСТИ
		private function _BallSpeedFade ():void {
			if (this.__isMoving) {
				if (this.__speedHor > 0) {
					if (this.__speedHor - this.__speedFade > 0) {
						this.__speedHor -=  this.__speedFade;
					}
					else {
						this.__speedHor = 0;
					}
				}
				else if (this.__speedHor < 0) {
					if (this.__speedHor + this.__speedFade < 0) {
						this.__speedHor +=  this.__speedFade;
					}
					else {
						this.__speedHor = 0;
					}
				}
				if (this.__speedVert > 0) {
					if (this.__speedVert - this.__speedFade > 0) {
						this.__speedVert -=  this.__speedFade;
					}
					else {
						this.__speedVert = 0;
					}
				}
				else if (this.__speedVert < 0) {
					if (this.__speedVert + this.__speedFade < 0) {
						this.__speedVert +=  this.__speedFade;
					}
					else {
						this.__speedVert = 0;
					}
				}
			}
		}
		
		
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//	ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
//
		// ВЫХОД ЗА РАМКИ СЦЕНЫ
		private function _BallEscapeCheck ():void {
			if (this.x < 0) {
				this.x = 0;
				this.__speedHor *=  -1;
			}
			else if (this.x>this.__maxX) {
				this.x = this.__maxX;
				this.__speedHor *=  -1;
			}
			if (this.y < 0) {
				this.y = 0;
				this.__speedVert *=  -1;
			}
			else if (this.y>this.__maxY) {
				this.y = this.__maxY;
				this.__speedVert *=  -1;
			}
		}
		// ВЫВОД ЗА РАМКИ СЦЕНЫ
		private function _BallDragOutCheck ():void {
			if (this.x < 0) {
				this._BallThrow ();
				this.x = 0;
			}
			else if (this.x > this.__maxX) {
				this._BallThrow ();
				this.x = this.__maxX;
			}
			if (this.y < 0) {
				this._BallThrow ();
				this.y = 0;
			}
			else if (this.y > this.__maxY) {
				this._BallThrow ();
				this.y = this.__maxY;
			}
		}
	}
}