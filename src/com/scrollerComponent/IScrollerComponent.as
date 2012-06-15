package com.scrollerComponent
{
	import com.scrollerComponent.core.animator.IAnimator;
	import com.scrollerComponent.core.bitmapDataScroller.IBitmapDataScroller;
	import com.scrollerComponent.core.eventManagement.IEventManager;
	import com.scrollerComponent.core.interaction.IInteractionHandler;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	
	/**
	 * @author Tal
	 */
	public interface IScrollerComponent
	{
		
	// [ GETTERS AND SETTERS
		
		// canvas rect
		function get canvas() : Rectangle 
		function set canvas( canvasRect : Rectangle ) : void
		// bind to canvas
		function get bindToCanvas() : Boolean
		function set bindToCanvas( bind2Canvas : Boolean ) : void
		// orientation
		function get orientation() : String
		function set orientation( viewOrientation : String ) : void
		// starting pos
		function get startingPosition() : String
		function set startingPosition( position : String ) : void
		// snapping 
		function get snapping() : Boolean 
		function set snapping( snap : Boolean ) : void
		// hit area
		function get listHitArea() : InteractiveObject 
		function set listHitArea( hitAreaInteractiveObj : InteractiveObject ) : void
		// margin
		function get margin() : int
		function set margin( spacingAmount : int ) : void
		// move one item at a time
		function get oneItemAtATime() : Boolean 
		function set oneItemAtATime( swipeOneOnly : Boolean ) : void
	
	// ] 
	
	// [ SETTERS
		
		// over state
		function addOverStateFunctionality( currentColour : uint, replacementColour : uint, mask : uint = 0xFFFFFF ) : void
		// tap sensitivity
		function set tapSensitivity( sensitivity : int ) : void
		// make padding visible
		function makePaddingVisible( paddingColour : int ) : void
		// threshold
		function set threshold( thresHold : Number ) : void
		// vel buffer
		function set velocityBuffer( buffer : Number ) : void 
		// easing
		function set easing( ease : Number ) : void
		// snap to bounds
		function snapToBoundDuration( duration : Number ) : void
		// snap ease
		function snapToBoundsEase( tweenLiteEaseObj : Object ) : void 
		// snap dur
		function set snapToItemDuration( duration : Number ) : void
		// snap ease
		function set snapToItemEase( tweenLiteEaseObj : Object ) : void
		// center point
		function positionSelectedToCenter( centerPoint : Point = null ) : void
		// use enterframe
		function set useEnterFrame( value : Boolean ) : void
		// delta time
		function set timeStepperDelta( value : Number ) : void
		// timer delay
		function set timerDelay( value : Number ) : void
		// friction
		function set friction( value : Number ) : void
		// ios lag
		function set iosSynthesizedLag( value : Number ) : void
		// center duration
		function set moveToCenterDuration( value : Number ) : void
		// center ease
		function set moveToCenterEase( value : Object ) : void
		
	// ] 
	// [ SIGNALS
		
		// tween completed
		function get movementCompletedSignal() : Signal
		function set movementCompletedSignal( signal : Signal ) : void
		// tween started
		function get movementStartedSignal() : Signal 
		function set movementStartedSignal( signal : Signal ) : void
		// item selected
		function get itemSelectedSignal() : Signal
		function set itemSelectedSignal( signal : Signal ) : void
	// ]
	// [ CLASSES
		
		// event manager
		function get eventManager() : IEventManager 
		function set eventManager( evntManagerClazz : IEventManager ) : void
		// scroller
		function get bitmapDataScroller() : IBitmapDataScroller
		function set bitmapDataScroller( scrollerClazz : IBitmapDataScroller ) : void
		// animator
		function get animator() : IAnimator 
		function set animator( animatorClazz : IAnimator ) : void
		// interaction
		function get interactionHandler() : IInteractionHandler 
		function set interactionHandler( handler : IInteractionHandler ) : void
	// ] 
	
		// pass in list properties
		function properties(
											 viewCanvas 		: Rectangle,
											 objMargin			: int 			= 0,
											 snapping			: Boolean 		= false,
											 bindToCanvas		: Boolean		= true,
											 orientation		: String 		= "horiontal",
											 positioning 		: String 		= "left",
											 useEnterFrame		: Boolean		= false
									) : void
		// view
		function get view() : DisplayObject	
		// set collection
		function set bitmapDataCollection( collection : Vector.<BitmapData> ) : void 
		// move to item
		function moveToItem( id : int ) : void  
		// intialise
		function initialiseScroller() : void 
		// enable
		function enable() : void 
		// disable
		function disable() : void 
		// dispose
		function dispose() : void 
		
	}
}
