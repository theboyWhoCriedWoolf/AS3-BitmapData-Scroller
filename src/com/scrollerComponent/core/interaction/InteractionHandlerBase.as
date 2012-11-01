package com.scrollerComponent.core.interaction
{
	import com.scrollerComponent.core.animator.IAnimator;
	import com.scrollerComponent.core.bitmapDataScroller.IBitmapDataScroller;
	import com.scrollerComponent.core.eventManagement.EventVO;
	import flash.geom.Point;

	/**
	 * @author Tal
	 */
	public class InteractionHandlerBase
	{
		// private properties
		protected var _itemSize 			: int;
		protected var _zeroIndex			: int;
		protected var _index				: int = 0;
		protected var _totalItems			: int;
		protected var _moveOneAtATime 		: Boolean = false;
		protected var _threshold			: Number;
		protected var _totalLength			: Number;
		protected var _snapping				: Boolean;
		protected var _midItemPoint			: Number;
		protected var _oneItemAtaTime		: Boolean;
		protected var _velBuffer 			: Number;
		protected var _tweenToItemDur 		: Number;
		protected var _snapToItemEase		: Object;
		protected var _moveToCenterEase		: Object;
		protected var _centerItemDuration	: Number = 1;
		protected var _currentID			: int = 0;
		protected var _vel					: int = 0;
		protected var _target				: Number;
		protected var _currentSelectedID	: int = -1;
		
	// [ LIST PROPERTIES
		
		/*
		 * moove the list view, extended based on orientation
		 */
		public function moveList( scroller : IBitmapDataScroller, velocity : Number,  animator : IAnimator ) : void 
		{
			_vel = Math.floor( Math.abs( velocity ) * _velBuffer );
			
			if( Math.abs( velocity ) < _threshold )
			{
				tweenToNearestPosition( scroller, animator );
				return;
			}
			
			if( velocity < _threshold )
			{
				if( !_moveOneAtATime )
				{
					_currentID += ( _vel <= 0 ) ?  1 : _vel;
					if( _currentID >= _totalItems - 1 ) _currentID = _totalItems - 1;
				}
				else { _currentID += 1; }
				
			}
			else if( velocity > _threshold )
			{
				if( !_moveOneAtATime )
				{
					_currentID -= ( _vel <= 1 ) ? 0 : _vel;  
					if( _currentID < 0 ) _currentID = 0;
				}
				// else { _currentID -= 1; } 
			}
			
			_target = ( _snapping )? targetPosition( _currentID ) : Math.floor( velocity  * _velBuffer );
			animator.startAnimation( _target, scroller );
			
			_currentSelectedID = _currentID;
		}; 
		
		/*
		 * move the list to center the selected panel in the middle, override
		 */
		public function centerSelectedPanel( scroller : IBitmapDataScroller, animator : IAnimator, eventVO : EventVO, centerPoint : Point ) : void {}
		
		/*
		 * add over state to selected panel
		 */
		public function addSelectedState( scroller : IBitmapDataScroller, eventVO : EventVO ) : void {}
		
		/*
		 * get the target location by calculating the index to go to
		 * and the cords based on the item width and the starting index point
		 */
		public function targetPosition( index : int ) : Number { return _zeroIndex + ( index * _itemSize ); }
		
		/*
		 * return the current selectd ID
		 */
		public function get currentSelectedID() : int { return _currentSelectedID; }
			
		
	// [ SETTERS
	 
		/*
		 * set the total number of items
		 */
		public function set totalNumItems( total : int ) : void { _totalItems = total; }
		// only move one item at a time
		public function set moveOneItemOnly( value : Boolean ) : void { _moveOneAtATime = value; }
		// set the velocity threshold
		public function set threshold( value : Number ) : void { _threshold = value; }
		// set thre item size
		public function set itemSize( size : int ) : void { _itemSize = size; }
		// set the zero based index
		public function set zeroPosition( value : int ) : void { _zeroIndex = value; }
		// set if snapping switched on
		public function set snapping( snap : Boolean ) : void { _snapping = snap; }
		// set if only animating one item at a time
		public function set oneItemAtATime( value : Boolean ) : void { _oneItemAtaTime = value; }
		// set the velocity buffer
		public function set velocityBuffer( value : Number ) : void { _velBuffer = value; }
		// set the tweening to item duration
		public function set tweenItemDuration( value : Number ) : void { _tweenToItemDur = value; } 
		// set the ease to snap item into place if vel below threshold
		public function set snapToItemEase( value : Object ) : void { _snapToItemEase = value; }
		// set the tween duration to center item
		public function set moveToCenterDuration( value : Number ) : void { _centerItemDuration = value; }
		// set the center selected movement ease
		public function set moveToCenterEase( value : Object ) : void { _moveToCenterEase = value; }
	
	// ] 
		
	// [ ANIMATION METHODS
		
		/*
		 * return the id of the current item
		 * at the zero index
		 */
		protected function getIdForAnimation( _pos : Number ) : int 
		{
			var pos : Number =  _pos - _zeroIndex;
			return pos / _totalLength * _totalItems;
		}
		
		/*
		 * get id to move into closest position
		 * to item
		 */
		protected function getIdForSnap( _pos : Number ) : int 
		{
			var pos : Number =  _pos - _midItemPoint;
			return pos / _totalLength * _totalItems; 
		}
		
		/*
		 * move the list to a particular item with the items id
		 */
		public function moveToItem( scroller : IBitmapDataScroller, id : int ) : void {}
		
		/*
		 * return the item id at mouse location
		 */
		public function getSelectedID( listPos : Number, mousePos : Number, centerPointAdditive : int = 0 ) : int 
		{
			var pos : Number = ( listPos - ( _zeroIndex + centerPointAdditive ) ) + mousePos;
			if( pos < 0 ) return -1;
			return pos / _totalLength * _totalItems;
		}
		
		/*
		 * override tween to nearest position for different orientation
		 */
		protected function tweenToNearestPosition( scroller : IBitmapDataScroller, animator : IAnimator ) : void {}
		
	// ]
		
		/*
		 * init
		 */
		public function initialise() : void 
		{
			_totalLength 	= ( _itemSize * _totalItems );
			_midItemPoint	= _zeroIndex - (_itemSize / 2 );
		}
		
		/*
		 * dispose
		 */
		public function dispose() : void 
		{
			_currentSelectedID = -1;
		}
	
	// ] 
	}
}
