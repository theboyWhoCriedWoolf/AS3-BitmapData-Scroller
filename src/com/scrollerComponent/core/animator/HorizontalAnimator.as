package com.scrollerComponent.core.animator
{
	import com.scrollerComponent.core.bitmapDataScroller.IBitmapDataScroller;

	
	/**
	 * @author Tal
	 */
	final public class HorizontalAnimator extends AnimatorBase implements IAnimator
	{
		
	// [ CALCULATE METHODS
		
		/*
		 * calculate the bounds
		 */
		override protected function initiateBounds() : void 
		{
			_right 				= _totalLength;
			_left 				= _zeroIndex.x;
		}
		
		
		/*
		 * check bounds
		 */
		 override public function checkBounds( scroller : IBitmapDataScroller ) : Boolean 
		 {
			if( scroller.xPos < _left )
			{
				tween(  scroller, _left, 0, _boundsduration, _boundsEasing );
				return true;
			}
			else if( scroller.xPos > _right )
			{
				tween( scroller, _right, 0, _boundsduration, _boundsEasing );
				return true;
			}
			return false;
		 }
		 
		 /*
		  * check bounds as mouse is moving, adds lag to list movement if beyond bounds
		  */
		 override public function iosLagDistance( scroller : IBitmapDataScroller ) : Number 
		 { 
			if( scroller.xPos < _left ) return 1 - ( Math.abs( scroller.xPos - _left ) * _iosLagPercent );
			else if( scroller.xPos > _right ) return 1 - ( Math.abs( scroller.xPos - _right ) * _iosLagPercent );
			return 1;
		 }
		 
	// ]
	
	// [ ANIMATE
	
		/*
		 * animate and snap into position
		 */
		override protected function updateWithSnap_handler( ) : void 
		{
			if( _tweening ) return;
			if( checkBounds( _scroller ) ) return;
			
			_vx = ( _targetVal - _listXPos ) * _listEase;
			_listXPos += _vx;
			_scroller.xPos = _listXPos;
			
			if( ( int( ( Math.abs( _vx ) )*100 ) / 100 ) <= 0.0 ) // simply calculates the vx into a two decimal number
			{
				_scroller.xPos = _targetVal;
				stopAnimation();
				tweenCompletedSignal.dispatch();  
			}
		}
		
		/*
		 * animate the view, without snapping
		 */
		override protected function updateWithoutSnap_handler() : void 
		{
			if( _tweening ) return;
			if( checkBounds( _scroller ) ) return;
			
			_listXPos -= _targetVal;
			_targetVal *= _friction;
			_scroller.xPos = _listXPos;
			
			if( Math.abs( _targetVal ) <= 0.1 )
			{
				stopAnimation();
				tweenCompletedSignal.dispatch();  
			}
		}
		
		/*
		 * render the list view
		 */
		override protected function render_handler() : void
		{
			if( _tweening ) return;
			_scroller.xPos = _listXPos;
		}
	
	 // ] 
	 
	
	}
}
