package com.scrollerComponent.core.animator
{
	import com.scrollerComponent.core.bitmapDataScroller.IBitmapDataScroller;
	import flash.geom.Point;
	import org.osflash.signals.Signal;
	
	/**
	 * @author Tal
	 */
	public interface IAnimator
	{
		
	// [ PROPERTIES
		
		// tween
		function tween( viewObj : IBitmapDataScroller, xVal : int = 0, yVal : int = 0, dur : Number = 1, ease : Object = null ) : void
		// start the animation
		function startAnimation( target : Number, scroller : IBitmapDataScroller ) : void 
		// stop the animation
		function stopAnimation() : void 
		// check bounds
		function checkBounds( scroller : IBitmapDataScroller ) : Boolean
		// checks bounds without tweening back to bounds, used to add lag to the scrolling list
		function iosLagDistance( scroller : IBitmapDataScroller ) : Number
		//list easing value
		function set listEasing( value : Number ) : void
		// set the snap ease, tweenlight object  to snap item to nearest position
		function set snapEasing( value : Object ) : void
		// set the snapping duration for tweenlight to snap item to nearest position
		function set snapDuration( value : Number ) : void
		// set the tweenlight ease to tween back to bounds
		function set boundsEase( value : Object ) : void
		// set the tweenlight duration to snap back to bounds
		function set boundsDuration( value : Number ) : void
		// use enter frame for movement
		function set useEnterFrame( value : Boolean ) : void
		// set the delta time for timestepper
		function set timestepperDeltaTime( value : Number ) : void 
		// set timer delay
		function set timerDelay( value : Number ) : void
		// set the zero index point
		function set zeroIndexPoint( point : Point ) : void
		// total length of view
		function set totalLength( totalListLength : int ) : void
		// snapping enabled or disabled
		function set snapping( snap : Boolean ) : void
		// set the list friction, only used when snapping is false
		function set friction( value : Number ) : void 
		// set the lagging amount to synthesise ios feel
		function set iosLagPercentage( value : Number ) : void
		// initiate
		function initiate() : void 
		// dispose
		function dispose() : void
		
	// ]
		
		// [ SIGNALS
		
			// tween completed signal
			function get tweenCompletedSignal() : Signal 
			function set tweenCompletedSignal( signal : Signal ) : void
		
		// ]
		
	}
}
