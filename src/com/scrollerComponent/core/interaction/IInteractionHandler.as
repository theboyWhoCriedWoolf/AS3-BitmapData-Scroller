package com.scrollerComponent.core.interaction
{
	import com.scrollerComponent.core.animator.IAnimator;
	import com.scrollerComponent.core.bitmapDataScroller.IBitmapDataScroller;
	import com.scrollerComponent.core.eventManagement.EventVO;
	import flash.geom.Point;

	
	/**
	 * @private
	 * @author Tal
	 */
	public interface IInteractionHandler
	{
		
		// move the list view component with velocity
		function moveList( scroller : IBitmapDataScroller, velocity : Number,  animator : IAnimator ) : void
		// moving one item only at a time
		function set moveOneItemOnly( value : Boolean ) : void
		// set velocity threshold
		function set threshold( value : Number ) : void
		// total number of items in collection
		function set totalNumItems( total : int ) : void
		// get the target position
		function targetPosition( index : int ) : Number
		// ste the item size
		function set itemSize( size : int ) : void
		// set the starting position
		function set zeroPosition( value : int ) : void 
		// set snapping 
		function set snapping( snap : Boolean ) : void 
		// set the velocity buffer
		function set velocityBuffer( value : Number ) : void
		// sets the duration to tween to each item when velocity is below threshold
		function set tweenItemDuration( value : Number ) : void
		// snap to item ease , tweenlite object
		function set snapToItemEase( value : Object ) : void
		// add a selected state to current selected item
		function addSelectedState( scroller : IBitmapDataScroller, eventVO : EventVO ) : void
		// center the selected item
		function centerSelectedPanel( scroller : IBitmapDataScroller, animator : IAnimator, eventVO : EventVO, centerPoint : Point ) : void
		// return the selected state
		function getSelectedID( listPos : Number, mousePos : Number, centerPointAdditive : int = 0 ) : int 
		// return the currently selected id
		function get currentSelectedID() : int
		// set the tweening duration to center an item
		function set moveToCenterDuration( value : Number ) : void
		// move to center tweenlite ease
		function set moveToCenterEase( value : Object ) : void
		// move to a list item by its id
		function moveToItem( scroller : IBitmapDataScroller, id : int ) : void 
		// intialise
		function initialise() : void 
		// dispose
		function dispose() : void
	}
}
