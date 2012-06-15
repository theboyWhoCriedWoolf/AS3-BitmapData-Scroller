package com.scrollerComponent
{
	import com.scrollerComponent.core.animator.IAnimator;
	import com.scrollerComponent.core.bitmapDataScroller.IBitmapDataScroller;
	import com.scrollerComponent.core.eventManagement.EventManager;
	import com.scrollerComponent.core.eventManagement.IEventManager;
	import com.scrollerComponent.core.interaction.IInteractionHandler;
	import com.scrollerComponent.utils.Orientation;
	import com.scrollerComponent.utils.Position;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;


	/**
	 * Abstract Class, Contains all the man animation values for the list component
	 * 
	 * @author Tal
	 */
	public class AbstractScrollerComponent extends Sprite
	{
		protected var _threshold				: Number	= 2;
		protected var _tapSensitivity 			: int 		= 2;
		protected var _easing 					: Number	= 0.2;
		protected var _snapToBoundsDur 			: Number	= 0.5;
		protected var _snapToItemDur 			: Number	= 0.5;
		protected var _velocityBuffer 			: Number 	= 0.06;
		protected var _paddingColour 			: int 		= 0x00000000;
		protected var _paddingAlpha				: Number 	= 0;
		protected var _deltaTime				: Number 	= 30; 
		protected var _timerDelay				: Number	= 30;
		protected var _friction					: Number 	= 0.80;
		protected var _iosSynthesizedLag		: Number	= 0.001;
		protected var _centerSelectedDuration	: Number 	= 0.5; 
		protected var _centerSelectionEase		: Object;
		protected var _snapToBoundsEase 		: Object;
		protected var _snapToItemEase 			: Object;
		protected var _sensitivityRect 			: Rectangle;
		protected var _zeroIndexPoint 			: Point;
		protected var _selectableBounds 		: Rectangle;
		protected var _centerPoint				: Point;
		protected var _useEnterFrame			: Boolean;
		protected var _positionSelectedToCenter : Boolean;
		protected var _startingAtCenterPos		: Boolean;
		// over state properties
		protected var _currentCol 				: int;
		protected var _replacementCol			: int;
		protected var _mask 					: int;
		protected var _addOverstate 			: Boolean;
		
		
	// [ VIEW CONTROLLERS	
	
		/**
		 * Set the Visible area Rectangle of the list component, width and height
		 */
		 public function get canvas() : Rectangle { return _canvas; }
		 public function set canvas( canvasRect : Rectangle ) : void
		 {
		 	_canvas 			= canvasRect;
			_zeroIndexPoint 	= new Point( canvas.width, canvas.height );
		 }
		 private var _canvas : Rectangle = new Rectangle( 0, 0, 100, 100 );
		
		/**
		 * Set the list bounding type. if true the list bounds will be set the the canvas
		 * False - bounds will be set to a single items width and height
		 * True - bounds will be set the the canvas width and height
		 * 
		 * @default true
		 */
		public function get bindToCanvas() : Boolean { return _bindToCanvas; }
		public function set bindToCanvas( bind2Canvas : Boolean ) : void
		{
			_bindToCanvas = bind2Canvas;
		}
		private var _bindToCanvas : Boolean = true;
		
		/**
		 * Set the orientation of the list, verticle or horizontal
		 * this will effect movement and interaction
		 * 
		 * @default Orientation.HORIZONTAL
		 */
		public function get orientation() : String { return _orientation; }
		public function set orientation( viewOrientation : String ) : void
		{
			_orientation = viewOrientation;
		}
		private var _orientation : String = Orientation.HORIZONTAL;
		
		/**
		 * Set the starting position of the list and its items
		 * 
		 * Position.LEFT 	- positions the first list item aigned to the left edge of the bounding area
		 * Position.RIGHT 	- positions the first list item aligned to the right edge of the bounding area
		 * Position.CENTER	- positions the middle item, based on total number of items at the center of the canvas
		 * Position.TOP		- does the same as above but when the orientation is set to HORIZONTAL
		 * Position.BOTTOM	- does the same as above but when the orientation is set to HORIZONTAL
		 * 
		 * @default = Position.LEFT
		 */
		public function get startingPosition() : String { return _startingPosition; }
		public function set startingPosition( position : String ) : void
		{
			_startingPosition = position;
		}
		private var _startingPosition : String = Position.LEFT;
		
		/**
		 * Snap items into place when the list is animated
		 * 
		 * When snapping is true, the list uses easing rather than friction when animating the list
		 * @default true;
		 */
		public function get snapping() : Boolean { return _snapping; }
		public function set snapping( snap : Boolean ) : void
		{
			_snapping = snap;
		}
		private var _snapping : Boolean = true;
		
		/**
		 * Allow the definition of another Interactive object to act as the hit area of the component
		 * @default null
		 */
		public function get listHitArea() : InteractiveObject { return _hitareaObj; }
		public function set listHitArea( hitAreaInteractiveObj : InteractiveObject ) : void
		{
			_hitareaObj = hitAreaInteractiveObj;
		}
		private var _hitareaObj : InteractiveObject = null;
		
		/**
		 * Sets the marginal space between each item in the list
		 * @default 0
		 */
		public function get margin() : int { return _margin; }
		public function set margin( spacingAmount : int ) : void
		{
			_margin = spacingAmount;
		}
		private var _margin : int = 0;
		
		/**
		 * By selecting this option the list item element will scroll one item along at a time only,
		 * regardless of the velocity buffer
		 * 
		 * @default false
		 */
		public function get oneItemAtATime() : Boolean { return _moveByOneOnly; }
		public function set oneItemAtATime( swipeOneOnly : Boolean ) : void
		{
			_moveByOneOnly = swipeOneOnly;
		}
		private var _moveByOneOnly : Boolean = false;
		
		/**
		 * Add selectable state to each list item, will only work if the replaced colour is a full colour
		 * Adds a button like functionality to bitmapData
		 * 
		 * @param currentColour : curent background colour -  must be in 32 bit hex
		 * @param replacementColour : colour to replace bg with -  must be in 32 bit hex
		 * @param mask : amount of threshold to use -  must be in 32 bit hex
		 */
		public function addOverStateFunctionality( currentColour : uint, replacementColour : uint, mask : uint = 0xFFFFFF ) : void
		{
			_currentCol		= currentColour;
			_replacementCol	= replacementColour;
			_mask			= mask;
			_addOverstate	= true;
		}
		
		/**
		 * Set the tap sensitivity / threshold for detecting interaction as a tap or movement
		 * Helps prevent a click/tap detection if the list is moved after a mouseDown event has been detected
		 * 
		 * @default 2
		 */
		public function set tapSensitivity( sensitivity : int ) : void { _tapSensitivity = sensitivity; }
		
		/**
		 * To allow smooth draging of bitmapData into minus values, empty bitmapData ( Padding ) 
		 * is created and placed either side of the items in the list.
		 *  
		 * Makes the padding either side of the list items visible
		 * A colour parameter must be specified to colour the padding
		 * 
		 * @default visibility = false
		 */
		public function makePaddingVisible( paddingColour : int ) : void { _paddingColour = paddingColour; _paddingAlpha = 1; }
		
	// ] 
	
	// [ SETTERS
		
		/**
		 * Defines the Velocity threshold, the amount by with the velocity must exceed to move from the current list item to the next
		 * @default 2
		 */
		public function set threshold( thresHold : Number ) : void { if( thresHold < 0 ) thresHold = 0; _threshold = thresHold; } 
		/**
		 * Defines the Velocity buffer, buffers the velocity amount by the value specified.
		 * When snapping is false, buffer automatically defaults to 1
		 * 
		 * @default 0.06
		 */
		public function set velocityBuffer( buffer : Number ) : void { _velocityBuffer = buffer; }
		/**
		 * Defines the List easing. Used only when snapping is true
		 * 
		 * @default 0.2
		 */
		public function set easing( ease : Number ) : void { if( ease > 1 || ease < 0 ) return; _easing  = ease; };
		/**
		 * Defines the Tweening Duration when snapping list back to the set bounds
		 * 
		 * @default 0.5
		 */
		public function snapToBoundDuration( duration : Number ) : void { _snapToBoundsDur = duration; }
		/**
		 * Defines the List easing when snaping back to within the set bounds
		 * @default {}
		 */
		public function snapToBoundsEase( tweenLiteEaseObj : Object ) : void { _snapToBoundsEase = tweenLiteEaseObj; }	
		/**
		 * Defines the Tween duration when snapping the list component to the nearest item when below the specified
		 * velocity threshold
		 * @default 0.5
		 */
		public function set snapToItemDuration( duration : Number ) : void { _snapToItemDur = duration; }
		/**
		 * Defines the Tween duraion when snapping to a list component item when below the specified velocity threshold
		 */
		public function set snapToItemEase( tweenLiteEaseObj : Object ) : void { _snapToItemEase = tweenLiteEaseObj; }
		/**
		 * Defines the Position list items to a central point, if a point is not specified, one will be calculated based on item dimensions, list
		 * dimensions and visible area
		 * @param centerPoint Point of the first list item to be placed
		 * @default null
		 */
		public function positionSelectedToCenter( centerPoint : Point = null ) : void { _centerPoint = centerPoint; _positionSelectedToCenter = true; }
		/**
		 * Defines the Use enter frame with the timestepper instad of a timer
		 * @default false
		 */
		public function set useEnterFrame( value : Boolean ) : void { _useEnterFrame = value; }
		/**
		 * Defines the deltaTime to be used with the timestepper - set to minimum framerate used
		 * @default 30
		 */
		public function set timeStepperDelta( value : Number ) : void { _deltaTime = value; } 
		/**
		 * Defines the timer delay
		 * @default 30
		 */
		public function set timerDelay( value : Number ) : void { _timerDelay = value; }
		/** 
		 * Defines the  friction applied to the list to ease the movement when snapping is False
		 * @default 0.80
		 */
		public function set friction( value : Number ) : void { _friction = value; }
		/**
		 * Defines an ios style lag when dragging the list component past its bounds.
		 * Applies an offset amount based on the distance from visible bounds to the list edge
		 * @default 0.001
		 */
		public function set iosSynthesizedLag( value : Number ) : void { _iosSynthesizedLag = value; }
		/**
		 * Defines the Tween duration when moving a list item to a center point on tap/click
		 * Only used when moveSelectedToCenter is active
		 * @default 0.5
		 */
		public function set moveToCenterDuration( value : Number ) : void { _centerSelectedDuration = value; }
		/**
		 * Defines the Tween Ease when moving a list item to a center point on tap/click
		 * @default {}
		 */
		public function set moveToCenterEase( value : Object ) : void { _centerSelectionEase = value; }
		
	// ] 
	
	// [ SIGNALS
	
		/**
		 * Dispatches when the list component has finished animating
		 */
		public function get movementCompletedSignal() : Signal { return _movementCompletedSignal; }
		public function set movementCompletedSignal( signal : Signal ) : void
		{
			_movementCompletedSignal = signal;
		}
		private var _movementCompletedSignal : Signal = new Signal();
		
		/**
		 * Dispatches when the list component starts to animate
		 */
		public function get movementStartedSignal() : Signal { return _movementStartedSignal; }
		public function set movementStartedSignal( signal : Signal ) : void
		{
			_movementStartedSignal = signal;
		}
		private var _movementStartedSignal : Signal = new Signal();
		
		/**
		 * Dispatches when an item has been selected
		 */
		public function get itemSelectedSignal() : Signal { return _itemSelectedSignal; }
		public function set itemSelectedSignal( signal : Signal ) : void
		{
			_itemSelectedSignal = signal;
		}
		private var _itemSelectedSignal : Signal = new Signal( int );
	
	// ] 
	
	// [ CLASS SETTERS
		
		/**
		 * Set the Event manager class.
		 * Handles all events used within the list component
		 */
		public function get eventManager() : IEventManager { return _eventManager; }
		public function set eventManager( evntManagerClazz : IEventManager ) : void
		{
			_eventManager = evntManagerClazz;
		}
		private var _eventManager : IEventManager = new EventManager();
		
		/**
		 * Set the BitmapDataScroller class
		 * Handles the drawing of the list data into the view
		 */
		public function get bitmapDataScroller() : IBitmapDataScroller { return _bitmapScroller; }
		public function set bitmapDataScroller( scrollerClazz : IBitmapDataScroller ) : void
		{
			if( _bitmapScroller != null && this.contains( _bitmapScroller as DisplayObject ) ) this.removeChild( _bitmapScroller  as DisplayObject );
			_bitmapScroller = scrollerClazz;
		}
		private var _bitmapScroller : IBitmapDataScroller = null;
		
		/**
		 * Set the animator class
		 * Handles all animation. movement and bounds checking of the list component
		 */
		 public function get animator() : IAnimator { return _animator; }
		 public function set animator( animatorClazz : IAnimator ) : void
		 {
		 	_animator = animatorClazz;
		 }
		 private var _animator : IAnimator = null;
		 
		 /**
		  * Set the interaction handles
		  * Handles all interaction, and movement calculations of the list component
		  */
		 public function get interactionHandler() : IInteractionHandler { return _interactionHandler; }
		 public function set interactionHandler( handler : IInteractionHandler ) : void
		 {
		 	_interactionHandler = handler;
		 }
		 private var _interactionHandler : IInteractionHandler = null;
	
	// ] 
	
		/*
		 * return view
		 */
		public function get view() : DisplayObject { return this as DisplayObject; }
		
		/*
		 * safe remove
		 */
		protected function safeNullify( obj : Object ) : void { if( obj ) obj = null; }
		
	}
}
