package com.example
{
	import com.scrollerComponent.IScrollerComponent;
	import com.scrollerComponent.ScrollerComponent;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class Scroller extends Sprite
	{
		// scroller
		private var _scrollingComponent : IScrollerComponent;
		
		public function Scroller()
		{
			/*
			 *  better results on mobile with TimeStepping,
			 *  NOTE: you can change to enterframe or timer mode, also change the timeStepperDelta
			 *  and timerDelay to get the best visual results
			 */
			// stage.frameRate = 60;
		
			// instantiate Scrolling component with minimal setup values
			_scrollingComponent = new ScrollerComponent();
			_scrollingComponent.properties( new Rectangle( 0, 0, 1024, 300 ) ); 	// pass in the canvas size
			_scrollingComponent.bitmapDataCollection = bitmapDataVect();			// pass in the collection of BitmapData
			_scrollingComponent.initialiseScroller();								// initialise the scoller
			addChild( _scrollingComponent as DisplayObject );						// add to the display list
		}
		
		
		/*
		 * create a vector of Test BitmapData
		 */
		private function bitmapDataVect() : Vector.<BitmapData>
		{
			
			var s 		: Shape;
			var bmd 	: BitmapData;
			var vect	: Vector.<BitmapData> = new Vector.<BitmapData>();
			
			for (var i : int = 0; i < 30; i++) {
				
				s = new Shape();
				s.graphics.beginFill( Math.random() * 0xfffffff );
				s.graphics.drawRect(0, 0, 200, 50 );
				s.graphics.endFill();
				
				bmd = new BitmapData( s.width, s.height );
				bmd.draw( s );
				
				vect.push( bmd );
			}
			return vect;
		}
	}
}
