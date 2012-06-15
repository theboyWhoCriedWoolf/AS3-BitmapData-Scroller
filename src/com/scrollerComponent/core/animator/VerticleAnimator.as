package com.scrollerComponent.core.animator
{
	import com.scrollerComponent.core.bitmapDataScroller.IBitmapDataScroller;

	/**
	 * @author Tal
	 */
	final public class VerticleAnimator extends AnimatorBase implements IAnimator
	{
		
		
	// [ CALCULATE METHODS
		
		/*
		 * calculate the bounds
		 */
		override protected function initiateBounds() : void 
		{
			_top 					= _zeroIndex.y;
			_bottom 				= _totalLength;
		}
		
		
		/*
		 * check bounds
		 */
		 override public function checkBounds( scroller : IBitmapDataScroller ) : Boolean 
		 {
			if( scroller.yPos < _top )
			{
				tween(  scroller, 0, _top, _boundsduration, _boundsEasing );
				return true;
			}
			else if( scroller.yPos > _bottom )
			{
				tween( scroller, 0, _bottom, _boundsduration, _boundsEasing );
				return true;
			}
			return false;
		 }
		 
		 /*
		  * check bounds as mouse is moving, adds lag to list movement if beyond bounds
		  */
		 override public function iosLagDistance( scroller : IBitmapDataScroller ) : Number 
		 { 
			if( scroller.yPos < _top ) return 1 - ( Math.abs( scroller.yPos - _top ) * _iosLagPercent );
			else if( scroller.yPos > _bottom ) return 1 - ( Math.abs( scroller.yPos - _bottom ) * _iosLagPercent );
			return 1; 
		 }
		 
	// ]
	
	// [ ANIMATE
	
		override protected function updateWithSnap_handler() : void 
		{
			if( _tweening ) return;
			if( checkBounds( _scroller ) ) return;
			
			_vy = ( _targetVal - _listYPos ) * _listEase;
			_listYPos += _vy;
			_scroller.yPos = _listYPos;
			
			if( ( int( ( Math.abs( _vy ) )*100 ) / 100 ) <= 0.0 ) // simply calculates the vy into a two decimal number
			{
				_scroller.yPos = _targetVal;
				stopAnimation();
				tweenCompletedSignal.dispatch();  
			}
		}
	
		/*
		 * animate the view, without snapping
		 */
		override protected function updateWithoutSnap_handler() : void 
		{
			if( !_tweening ) return;
			if( checkBounds( _scroller ) ) return;
			
			_listYPos -= _targetVal;
			_listYPos *= _friction;
			
			_scroller.yPos = _listYPos;
			
			if( Math.abs( _targetVal ) <= 0.1 )
			{
				stopAnimation();
				tweenCompletedSignal.dispatch();  
			}
		}
		
		/*
		 * render the view
		 */
		override protected function render_handler() : void 
		{ 
			if( _tweening ) return;
			_scroller.yPos = _listYPos; 
		}
	
	 // ] 
	 
	
	}
}
