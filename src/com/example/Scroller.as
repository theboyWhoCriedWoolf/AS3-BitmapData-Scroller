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
			
			// the component automatically dispatches signals on item selected, movement Started 
			// and movement completed
			// to add the relevant listeners do the following:
			
			_scrollingComponent.itemSelectedSignal.add( itemSelected_handler );
			_scrollingComponent.movementStartedSignal.add( movementStarted_handler );
			_scrollingComponent.movementCompletedSignal.add( movementCompleted_handler );
		}
		
	// [ HANDLERS
		
		/*
		 * handler fired when item on list is selected
		 */
		 private function itemSelected_handler( selectedPanelID : Number ) : void
		 {
		 	// called each time an item is selected
		 }
		
		/*
		 * component movement started handler
		 */
		 private function movementStarted_handler() : void
		 {
			// called when the list starts moving
		 }
		 
		 /*
		  * component movement completed handler
		  */
		 private function movementCompleted_handler() : void
		 {
			// called when the list stops moving
		 }
		
	//  ]
		
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
