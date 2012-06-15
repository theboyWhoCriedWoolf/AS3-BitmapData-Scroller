package com.scrollerComponent.core.interaction
{
	import com.scrollerComponent.core.animator.IAnimator;
	import com.scrollerComponent.core.bitmapDataScroller.IBitmapDataScroller;
	import com.scrollerComponent.core.eventManagement.EventVO;
	import flash.geom.Point;
	
	/**
	 * Class to handle all intearction calculations in a horizontal orientation
	 * @author Tal
	 */
	final public class HorizontalHandler extends InteractionHandlerBase implements IInteractionHandler
	{
		
		/*
		 * move the list view based on velocity along the x Axis
		 */
		override public function moveList( scroller : IBitmapDataScroller, velocity : Number,  animator : IAnimator ) : void 
		{
			_currentID 	= getIdForAnimation( scroller.xPos );
			super.moveList( scroller, velocity, animator );
		}		
		
		/*
		 * nearest position
		 */
		override protected function tweenToNearestPosition( scroller : IBitmapDataScroller, animator : IAnimator ) : void 
		{
			if( animator.checkBounds( scroller ) ) return;
			if( !_snapping ) return;
			
			var id : int = getIdForSnap( scroller.xPos );
			var destination : int = targetPosition( id );
			animator.tween( scroller, destination, 0 , _tweenToItemDur, _snapToItemEase );
		}
		
		/*
		 * override
		 */
		override public function addSelectedState( scroller : IBitmapDataScroller, eventVO : EventVO ) : void 
		{
			_currentSelectedID = getSelectedID( scroller.xPos, eventVO.event.localX );
			scroller.currentSelectedItem( _currentSelectedID );
		}
		
		/*
		 * center the selected item to the middle of the view
		 */
		override public function centerSelectedPanel( scroller : IBitmapDataScroller, animator : IAnimator, eventVO : EventVO, centerPoint : Point ) : void 
		{
			var newID : int = getSelectedID( scroller.xPos, eventVO.event.localX, centerPoint.x );
			if( _currentSelectedID == newID ) { animator.stopAnimation(); return; }
			
			_currentSelectedID = newID;
			if(  _currentSelectedID < 0 || _currentSelectedID >= _totalItems ) { animator.stopAnimation(); return; }
			
			animator.tween( scroller, targetPosition( _currentSelectedID ), 0, _centerItemDuration, _moveToCenterEase );
		}
		
		/*
		 * override move to item
		 */
		override public function moveToItem( scroller : IBitmapDataScroller, id : int ) : void 
		{
			if( id < 0 || id > _totalItems ) return;
			// move into place
			scroller.xPos = targetPosition( id );
			scroller.render();
		}
	}
}
