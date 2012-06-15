package com.scrollerComponent.core.animator
{
	import com.greensock.TweenLite;
	import com.scrollerComponent.core.bitmapDataScroller.IBitmapDataScroller;
	import com.scrollerComponent.core.timeStepper.ITimeStepper;
	import com.scrollerComponent.core.timeStepper.TimeStepper;
	import flash.geom.Point;
	import org.osflash.signals.Signal;
	
	/**
	 * @author Tal
	 */
	public class AnimatorBase
	{
		
		// private properties
		protected var _left 					: int;
		protected var _right 					: int;
		protected var _top 						: int;
		protected var _bottom 					: int;
		protected var _zeroIndex 				: Point;
		protected var _snapping 				: Boolean;
		protected var _useEnterFrame			: Boolean;
		protected var _vx						: Number = 0;
		protected var _vy						: Number = 0;
		
		protected var _listXPos					: Number = 0;
		protected var _listYPos					: Number = 0;
		protected var _iosLagPercent 			: Number = 1;
		
		protected var _tweening					: Boolean;
		protected var _targetVal				: Number;
		protected var _updateFunction			: Function;
		protected var _scroller					: IBitmapDataScroller;
		protected var _timeStepper				: ITimeStepper;
		protected var _totalLength				: int;
		
		// animated properties		
		protected var _listEase					: Number;
		protected var _snapEasing				: Object;
		protected var _snapDuration				: Number;
		protected var _boundsEasing				: Object;
		protected var _boundsduration			: Number;
		protected var _friction					: Number;
		
		private var _deltaTime					: Number;
		private var _timerSteps				 	: Number;
		
		
		
		/*
		 * Constructor
		 */
		public function AnimatorBase() : void {}
		
	// [ OVERRIDEN METHODS
		
		// check bounds every time the view object moves
		public function checkBounds( scroller : IBitmapDataScroller ) : Boolean  { return false; }
		// check the bounds when the mouse is moving to add lag to mouse movement
		public function iosLagDistance( scroller : IBitmapDataScroller ) : Number { return 1; }
		// caculate bounds
		protected function initiateBounds() : void {}
		
	// ] 	
	
		// nitiate the animator
		public function initiate() : void 
		{ 
			initiateBounds(); 
			_updateFunction = ( _snapping ) ? updateWithSnap_handler : updateWithoutSnap_handler;
			
			_timeStepper = new TimeStepper();
			_timeStepper.initiateTimer( _updateFunction, render_handler, _timerSteps, 0, _deltaTime, _useEnterFrame );
		}
		
		
	// [ TWEENING PROPERTIES
	
		public function tween( viewObj : IBitmapDataScroller, xVal : int = 0, yVal : int = 0, dur : Number = 1, ease : Object = null ) : void 
		{
			TweenLite.killDelayedCallsTo( viewObj );
			TweenLite.killTweensOf( viewObj );
			_tweening = true;
			
			if( viewObj.xPos == xVal && viewObj.yPos == yVal) { onComplete_handler( viewObj ); return; }
			
			TweenLite.to( viewObj, dur, 
													{ 	xPos : xVal, 
														yPos : yVal, 
														ease : ease, 
														onComplete : onComplete_handler, 
														onCompleteParams : [ viewObj ]
													} );
		}
		
	// ] 
	
	// [ SIGNALS
	
		public function get tweenCompletedSignal() : Signal { return _tweenCompletedSignal; }
		public function set tweenCompletedSignal( signal : Signal ) : void
		{
			_tweenCompletedSignal = signal;
		}
		private var _tweenCompletedSignal : Signal = new Signal();
	
	// ] 
	
	// [ SET PROPERTIES
	
		// set the zero index point
		public function set zeroIndexPoint( point : Point ) : void { _zeroIndex = point; }
		// total list length
		public function set totalLength( totalListLength : int ) : void { _totalLength = totalListLength; }
		// use enterframe or timer
		public function set useEnterFrame( value : Boolean ) : void { _useEnterFrame = value; }
		// set the list easing
		public function set listEasing( value : Number ) : void { _listEase = value; }
		// set the snap tweenlight easing 
		public function set snapEasing( value : Object ) : void { _snapEasing = value; }
		// set the tweenlight snap duration
		public function set snapDuration( value : Number ) : void { _snapDuration = value; }
		// set the bounds tweenlight easing
		public function set boundsEase( value : Object ) : void { _boundsEasing = value; }
		// set the bounds tweenlight duration
		public function set boundsDuration( value : Number ) : void { _boundsduration = value; }
		// set the framerate of the animation timer if not using enter frame
		public function set timestepperDeltaTime( value : Number ) : void { _deltaTime = value; }
		// set the timer delay
		public function set timerDelay( value : Number ) : void { _timerSteps = value; }
		// set snapping
		public function set snapping( snap : Boolean ) : void { _snapping = snap; }
		// set the list friction
		public function set friction( value : Number ) : void { _friction = value; }
		// set the ios lag percentage to simulate ios behaviour
		public function set iosLagPercentage( value : Number ) : void { _iosLagPercent = value; }
		
	// ] 
	
	// [ ANIAMTION ENTER FRAME
	
		public function startAnimation( target : Number, scroller : IBitmapDataScroller ) : void 
		{
			_tweening 		= false;
			_scroller 		= scroller;
			_targetVal 		= target;
			_listXPos 		= _scroller.xPos;
			_listYPos 		= _scroller.yPos;
			_timeStepper.startTimer();
		}
		
		/*
		 * remove listeners
		 */
		public function stopAnimation() : void 
		{
			_tweening = true;
			_timeStepper.stopTimer();
			if( _scroller ) _scroller.render();
			if( _scroller ) _scroller 	= null;
			_targetVal 					= 0;
		}
	
	// ]
	
	// [ HANDLERS
		
		// animate with snap handler
		protected function updateWithSnap_handler() : void {}
		// animate without snap handler
		protected function updateWithoutSnap_handler() : void {}
		// update handler
		protected function render_handler() : void {}
		
		/*
		 * dispatches when finished, in case this is required for a further action
		 */
		public function onComplete_handler( scroller : IBitmapDataScroller ) : void 
		{ 
			scroller.render(); // force  render
			scroller = null;
			stopAnimation();
			tweenCompletedSignal.dispatch();  
		}
	
	 // ]  
	 
		/*
		 * dispose
		 */
		public function dispose() : void
		{
			stopAnimation();
			tweenCompletedSignal.removeAll();
			_timeStepper.dispose();
			
			if( _timeStepper ) _timeStepper = null;
			if( tweenCompletedSignal ) tweenCompletedSignal = null;
		}
	
	}
}
