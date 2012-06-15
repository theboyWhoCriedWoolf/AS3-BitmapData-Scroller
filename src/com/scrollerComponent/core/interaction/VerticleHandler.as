package com.scrollerComponent.core.interaction
{
	import com.scrollerComponent.core.animator.IAnimator;
	import com.scrollerComponent.core.bitmapDataScroller.IBitmapDataScroller;
	import com.scrollerComponent.core.eventManagement.EventVO;
	import flash.geom.Point;

	/**
	 * Class to handle all intearction calculations in a verticle orientation
	 * @author Tal
	 */
	final public class VerticleHandler extends InteractionHandlerBase implements IInteractionHandler
	{
		/*
		 * move the list view based on velocity along the y Axis
		 */
		override public function moveList( scroller : IBitmapDataScroller, velocity : Number,  animator : IAnimator ) : void 
		{
			_currentID = getIdForAnimation( scroller.yPos );
			super.moveList( scroller, velocity, animator );
		}
		
		/*
		 * nearest position
		 */
		override protected function tweenToNearestPosition( scroller : IBitmapDataScroller, animator : IAnimator ) : void 
		{
			if( animator.checkBounds( scroller ) ) return;
			if( !_snapping ) return;
			
			var id : int = getIdForSnap( scroller.yPos );
			var destination : int = targetPosition( id );
			animator.tween( scroller, 0, destination , _tweenToItemDur, _snapToItemEase );
		}
		
		/*
		 * override
		 */
		override public function addSelectedState( scroller : IBitmapDataScroller, eventVO : EventVO ) : void 
		{
			_currentSelectedID = getSelectedID( scroller.yPos, eventVO.event.localY );
			scroller.currentSelectedItem( _currentSelectedID );
		}
		
		/*
		 * center the selected item to the middle of the view
		 */
		override public function centerSelectedPanel( scroller : IBitmapDataScroller, animator : IAnimator, eventVO : EventVO, centerPoint : Point ) : void 
		{
			var newID : int = getSelectedID( scroller.yPos, eventVO.event.localY, centerPoint.y );
			if( _currentSelectedID == newID ) { animator.stopAnimation(); return; }
			
			_currentSelectedID = newID;
			if(  _currentSelectedID < 0 || _currentSelectedID >= _totalItems ) { animator.stopAnimation(); return; }
			
			animator.tween( scroller, 0, targetPosition( _currentSelectedID ), _centerItemDuration );
		}
		
		/*
		 * override move to item
		 */
		override public function moveToItem( scroller : IBitmapDataScroller, id : int ) : void 
		{
			if( id < 0 || id > _totalItems ) return;
			// move into place
			scroller.yPos = targetPosition( id );
			scroller.render();
		}
	}
}
