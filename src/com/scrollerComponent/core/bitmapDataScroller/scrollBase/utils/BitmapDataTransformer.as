package com.scrollerComponent.core.bitmapDataScroller.scrollBase.utils
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	
	/**
	 * @private
	 * @author Tal
	 */
	public class BitmapDataTransformer
	{
		// private properties
		private var _replacementColour 		: uint;
		private var _originalColour 		: uint;
		private var _replacementBitmap		: BitmapData = null;
		private var _mask 					: uint;
		
		
		/*
		 * set the over colour and replacement colour of the threshold
		 */
		public function setColours( originalColour : uint, replacementColour : uint, mask : uint = 0xFFFFFF ) : void 
		{
			_originalColour 	= originalColour;
			_replacementColour	= replacementColour;
			_mask				= mask;
		}
		
		/*
		 * set the bitmapData thats active and needs to be changed
		 */
		public function setSelected( selectedView : BitmapData ) : void 
		{
			if( _replacementBitmap === null )
			{
				_replacementBitmap = selectedView;
				setToSelectedSatet( _replacementBitmap );
				return;
			}
			setToOriginalState( _replacementBitmap );
			_replacementBitmap = selectedView;
			setToSelectedSatet( _replacementBitmap );
		}
		
		
		/*
		 * set the bitmap data to over state
		 */
		private function setToSelectedSatet( bmd : BitmapData ) : void
		{
				bmd.threshold( 
								bmd, 
								new Rectangle(0, 0, _replacementBitmap.width,_replacementBitmap.height ), 
								new Point( 0, 0), 
								"==", 
								_originalColour,
								_replacementColour,
								_mask
							);	
		}
		
		/*
		 * set to original state
		 */
		private function  setToOriginalState( bmd : BitmapData ) : void 
		{
			bmd.threshold( 
							bmd, 
							new Rectangle(0, 0, _replacementBitmap.width,_replacementBitmap.height ), 
							new Point( 0, 0), 
							"==", 
							_replacementColour,
							_originalColour,
							_mask
						);
		}
		
		/*
		 * dispose
		 */
		public function dispose() : void 
		{
			if( _replacementBitmap !== null ) setToOriginalState( _replacementBitmap ); 
			_replacementBitmap = null;
		}
		
	}
}
