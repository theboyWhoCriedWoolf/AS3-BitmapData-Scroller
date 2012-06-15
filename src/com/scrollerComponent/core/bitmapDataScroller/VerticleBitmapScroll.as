package com.scrollerComponent.core.bitmapDataScroller
{
	import com.scrollerComponent.core.bitmapDataScroller.scrollBase.BitmapScrollingBase;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @private
	 * @author Tal
	 */
	final public class VerticleBitmapScroll extends BitmapScrollingBase implements IBitmapDataScroller
	{
		
		
	// [ PROPERTY SETTERS
	
		/*
		 * indexes the bitmap data, creates rectangles for each bitmap object passed
		 * in the array and positions it, indexing each one to get the total width
		 */
		override protected function indexBitmapData( bmd : BitmapData ) : void
		{
			// will end up with the last rectangle position
			if( _collectionRects.length >= 1 )
			 	var lastRect : Rectangle = _collectionRects[ _collectionRects.length - 1 ];
			 
			 var lastY : int = ( lastRect ) ? ( lastRect.y + lastRect.height) : 0;
			 // create a rectangle for data
			 var rect : Rectangle = new Rectangle( 0, lastY, bmd.width, bmd.height );
			 _collectionRects.push( rect );
			 
			  _totalHeight += rect.height;
			  _maxWidth = Math.max( _maxWidth, bmd.width ); // change max width if need be
		}
		
		/*
		 * draw the data, keep looping until the area of the canvas has been filled
		 */
		override protected function draw( sampleArea : Rectangle, offset:Point = null ) : void 
		{
			
			_calculationPoint.x = sampleArea.x;
			_calculationPoint.y = sampleArea.y;
			
			_collectionID = calculateCollectionStartIndex( _calculationPoint );
			
			if ( _collectionID != -1 )
            {
				_sourceRect 		= _collectionRects[ _collectionID ];
				_sourceBitmapData 	= _bitmapDataCollection[ _collectionID ];
				
				_leftover = Math.round( calculateLeftOverValue( sampleArea.y, sampleArea.height, _sourceRect ) );
				
				 if ( !offset )
                    offset = _copyPixelOffset;
				
				// calculate remaining space
				point = calculateSamplePosition( sampleArea, _sourceRect );

                sampleArea.x = point.x;	// position the sample area point
                sampleArea.y = point.y;
			
                bitmapData.copyPixels( _sourceBitmapData, sampleArea, offset ); // copy the pixels starting at that location

                if ( _leftover > 0 )
                {
                    offset = new Point( 0 , bitmapData.height - _leftover );
                    var leftOverSampleArea : Rectangle = calculateLeftOverSampleArea( sampleArea, _leftover, _sourceRect );
                    draw( leftOverSampleArea, offset);
                }
			}
		}
		
		
	// ]
		
	// [ CALCULATIONS
		
		/*
		 * return the remaining area, 
		 */
		private function calculateLeftOverSampleArea( sampleAreaSRC : Rectangle, leftOver : Number, sourceRect : Rectangle ) : Rectangle
        {
            _sampleArea = sampleAreaSRC.clone();
            _sampleArea.height = leftOver;
            _sampleArea.y = sourceRect.y + sourceRect.height;
            return _sampleArea;
        }
		
		/*
		 * get the position of the sample data
		 */
		private function calculateSamplePosition( sampleRect : Rectangle, sourceArea : Rectangle ) : Point
        {
            _samplePositionPoint.y = sampleRect.y - sourceArea.y;
            return _samplePositionPoint;
        }
		
		/*
		 * calculate the left over, getting the stage width and then
		 * calculating the remaining size left to draw in more data
		 */
		private function calculateLeftOverValue( offset : Number , sampleHeight : Number , sourceRect : Rectangle ) : Number
		{
			_difference = ( offset + sampleHeight ) - ( sourceRect.y + sourceRect.height );
			return ( _difference < 0 ) ? 0 : _difference;
		}
		
	// ] 
	
	}
}
