package com.scrollerComponent
{
	import com.scrollerComponent.core.animator.HorizontalAnimator;
	import com.scrollerComponent.core.animator.IAnimator;
	import com.scrollerComponent.core.animator.VerticleAnimator;
	import com.scrollerComponent.core.bitmapDataScroller.HorizontalBitmapScroll;
	import com.scrollerComponent.core.bitmapDataScroller.IBitmapDataScroller;
	import com.scrollerComponent.core.bitmapDataScroller.VerticleBitmapScroll;
	import com.scrollerComponent.core.interaction.HorizontalHandler;
	import com.scrollerComponent.core.interaction.IInteractionHandler;
	import com.scrollerComponent.core.interaction.VerticleHandler;
	import com.scrollerComponent.utils.BitmapDataUtils;
	import com.scrollerComponent.utils.GarbageCollector;
	import com.scrollerComponent.utils.Orientation;
	import com.scrollerComponent.utils.Position;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * Contains most of the intialisation methoeds for all the list component
	 * 
	 * @author Tal
	 */
	public class ScrollerComponentBase extends AbstractScrollerComponent
	{
		// private prperties
		private var _itemRect 				: Rectangle;
		private var _totalLengthWithCntr 	: int;
		private var _totalListHeight 		: Number;
		private var _totalListWidth 		: Number;
		
		protected var _totalNumberItems		: int;
		protected var _tapBounds 			: Rectangle;
		protected var _collection 			: Vector.<BitmapData>;

		/**
		 * Set the bitmapData list collection
		 * Pass in a vector of bitmap data list items to be displayed in the list component
		 */
		public function set bitmapDataCollection( collection : Vector.<BitmapData> ) : void 
		{ 
			if( collection === null ) return;
			_collection = collection; 
			_totalNumberItems 		= _collection.length;
			_totalListWidth 		= ( _collection[ 0 ].width * _collection.length );
			_totalListHeight 		= ( _collection[ 0 ].height * _collection.length );
		}
	
	
	// [ INITIATE VIEW PROPERTIES
		
		/*
		 * initiate the bitmap scroller, create padding either side of the collection
		 * add a margin to each item if one is set then pass to bitmapDataScroller
		 */
		protected function initiateBitmapScroller() : void 
		{
			if( bitmapDataScroller == null ) return;
			_itemRect = new Rectangle( 0, 0, ( _collection[ 0 ].width - margin ), ( _collection[ 0 ].height - margin ) ); // set the item rect properties
			
			if( _startingAtCenterPos )
			{
				if( _centerPoint == null ) _centerPoint = new Point( ( canvas.width/2 ) - ( _itemRect.width / 2 ), ( canvas.height / 2 ) - ( _itemRect.height / 2 ) );
			}
			
			BitmapDataUtils.addEmptyDataToCollection(  _collection, canvas,  _paddingColour, _paddingAlpha, ( _startingAtCenterPos )? _centerPoint : null );
			if( margin > 0 ) BitmapDataUtils.addMarginToCollectionItems( _collection, margin );
			bitmapDataScroller.setViewCollection = _collection;
			_collection = null;
		}
		
		/*
		 * initialise the handlers that will be used
		 * to draw, animate and add interaction based on orientation
		 */
		protected function initialiseHandlers( orientation : String ) : void 
		{
			var ScrollClass 	: Class = ( orientation == Orientation.HORIZONTAL ) ? HorizontalBitmapScroll 	: VerticleBitmapScroll;
			var HandlerClass 	: Class = ( orientation == Orientation.HORIZONTAL ) ? HorizontalHandler 		: VerticleHandler;
			var animatorClass 	: Class = ( orientation == Orientation.HORIZONTAL ) ? HorizontalAnimator 		: VerticleAnimator;
			
			instantiateBitmapDataScroller( ScrollClass );
			instantiateInteractionHandler( HandlerClass );
			instantiateAnimator( animatorClass );
		}
		
		/*
		 * calculate the bounds 
		 */
		protected function calculateBounds() : void
		{
			if( !_zeroIndexPoint ) _zeroIndexPoint = new Point( canvas.width, canvas.height );
		}
		
		/*
		 * populate the animator class
		 */
		protected function populateAnimator() : void
		{
			var centerBoundWidth : Number 	= ( !bindToCanvas ) ? ( _zeroIndexPoint.x - ( _itemRect.width + margin ) ) : - margin;
			var centerBoundHeight : Number 	= ( !bindToCanvas ) ? ( _zeroIndexPoint.y - ( _itemRect.height + margin ) ) : - margin;
			// makes sure that is view list is smaller than bounds, to tween to bounds not to object
			var widthToBoundTo : int = (  ( _totalListWidth + centerBoundWidth ) < canvas.width ) ? canvas.width : ( _totalListWidth + centerBoundWidth );
			var heightToBoundTo : int = (  ( _totalListHeight + centerBoundHeight ) < canvas.height ) ? canvas.height : ( _totalListHeight + centerBoundHeight );
			
			_totalLengthWithCntr			= ( orientation == Orientation.VERTICLE ) ? heightToBoundTo : widthToBoundTo;
			animator.listEasing 			= _easing;
			animator.snapDuration 			= _snapToItemDur;
			animator.snapEasing 			= _snapToItemEase;
			animator.boundsEase				= _snapToBoundsEase;
			animator.boundsDuration 		= _snapToBoundsDur;
			animator.snapping				= snapping;
			animator.totalLength 			= _totalLengthWithCntr;
			animator.zeroIndexPoint 		= _zeroIndexPoint;
			animator.useEnterFrame 			= _useEnterFrame;
			animator.timestepperDeltaTime 	= _deltaTime;
			animator.timerDelay 			= _timerDelay;
			animator.friction 				= _friction;
			animator.iosLagPercentage 		= _iosSynthesizedLag;
			animator.initiate();
		}
		
	// ]
	
	// [ ALIGNMENT AND ORIENTAION
	
		// set the alignment of initial view, position the list in differet alignments
		protected function align( alignment : String ) : void 
		{
			if( bitmapDataScroller == null ) return;
			if( canvas == null ) return;
			
			( orientation == Orientation.VERTICLE ) ? bitmapDataScroller.yPos = _zeroIndexPoint.y : bitmapDataScroller.xPos = _zeroIndexPoint.x;
			
			switch( alignment )
			{
				case Position.CENTER :
					var numVisible : int = Math.floor(  ( canvas.width / _itemRect.width ) / 2 );
					var targetPosition : Number = interactionHandler.targetPosition( ( _totalNumberItems/2 ) - numVisible );
					bitmapDataScroller.xPos = ( orientation == Orientation.HORIZONTAL ) ?  targetPosition : 0;
					bitmapDataScroller.yPos = ( orientation == Orientation.HORIZONTAL ) ? 0 : targetPosition;
					break;
				
				case Position.LEFT :
					if( orientation == Orientation.VERTICLE ) return;
					bitmapDataScroller.xPos = _zeroIndexPoint.x;
					break;																
				
				case Position.RIGHT :
					if( orientation == Orientation.VERTICLE  ) return;
					bitmapDataScroller.xPos = _totalLengthWithCntr;
					break;
				
				case Position.TOP :
					if( orientation == Orientation.HORIZONTAL ) return;
					bitmapDataScroller.yPos = _zeroIndexPoint.y;
					break;
			
				case Position.BOTTOM :
					if( orientation == Orientation.HORIZONTAL ) return;
					bitmapDataScroller.yPos = _totalLengthWithCntr;
					break;
			}
		}
		
	
	// ] 
	
	// [ UTILS
		
		/**
		 * Position list component to a particular item based on alignemnt
		 * If left aligned the item id passed will display that item first in the list against the left edge
		 */
		 public function moveToItem( id : int ) : void  
		 { 
			if( interactionHandler == null ) return;
		 	interactionHandler.moveToItem( bitmapDataScroller, id );
		 }
		
		/*
		 * create a point as used often
		 */
		protected function point( xVal : Number = 0, yVal : Number = 0 ) : Point { return new Point( xVal, yVal ); }
		
		/*
		 * create mouse sensitivity bounds rect
		 */
		protected function storeTapBounds( touchPoint : Point ) : void 
		{
			if( _tapBounds ) _tapBounds = null;
			var doubleBuffer : int = ( _tapSensitivity * 2 );
			_tapBounds = new Rectangle( touchPoint.x - _tapSensitivity, touchPoint.y - _tapSensitivity, doubleBuffer, doubleBuffer );
		}
	
		// create the bitmapData scroller
		private function instantiateBitmapDataScroller( Clazz : Class ) : void 
		{
			bitmapDataScroller = new Clazz() as IBitmapDataScroller; 
			bitmapDataScroller.addOverStateFunctionality( _currentCol, _replacementCol, _mask );
			bitmapDataScroller.width = canvas.width;
			bitmapDataScroller.height = canvas.height;
			addChild( bitmapDataScroller as DisplayObject );
		}
		
		// create the interaction handler
		private function instantiateInteractionHandler( Clazz : Class ) : void 
		{
			if( !snapping && _velocityBuffer == 0.06 ) _velocityBuffer = 1; // set the velocity buffer to work without snapping and use friction
			else _velocityBuffer = 0.06;
			
			interactionHandler = new Clazz() as IInteractionHandler; 
			interactionHandler.moveOneItemOnly 			= oneItemAtATime;
			interactionHandler.threshold 				= _threshold;
			interactionHandler.totalNumItems 			= _totalNumberItems;
			interactionHandler.zeroPosition 			= ( orientation === Orientation.HORIZONTAL ) ? canvas.width : canvas.height;
			interactionHandler.itemSize 				= ( orientation === Orientation.HORIZONTAL ) ? ( _collection[ 0 ].width - margin ) : ( _collection[ 0 ].height - margin ); 
			interactionHandler.snapping 				= snapping;
			interactionHandler.velocityBuffer 			= _velocityBuffer;
			interactionHandler.tweenItemDuration 		= _snapToItemDur;
			interactionHandler.snapToItemEase 			= _snapToItemEase;
			interactionHandler.moveToCenterDuration 	= _centerSelectedDuration;
			interactionHandler.moveToCenterEase	 		= _centerSelectionEase;
			interactionHandler.initialise();
		}
		// create animator
		private function instantiateAnimator( Clazz : Class ) : void { animator = new Clazz() as IAnimator; }
		
	// ] 
	
		/**
		 * dispose
		 */
		public function dispose() : void 
		{
			bitmapDataScroller.dispose();
			interactionHandler.dispose();
			eventManager.dispose();
			animator.dispose();
			
			movementStartedSignal.removeAll();
			itemSelectedSignal.removeAll();
			movementCompletedSignal.removeAll();
			
			safeNullify( bitmapDataScroller );
			safeNullify( interactionHandler );
			safeNullify( eventManager );
			safeNullify( animator );
			safeNullify( movementCompletedSignal );
			safeNullify( movementStartedSignal );
			safeNullify( _itemRect );
			safeNullify( _sensitivityRect );
			safeNullify( _selectableBounds );
			safeNullify( _snapToBoundsEase );
			safeNullify( _snapToItemEase );
			
			GarbageCollector.collect();
		}
	
	}
}
