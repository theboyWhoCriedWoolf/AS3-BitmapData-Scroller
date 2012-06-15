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
	final public class HorizontalBitmapScroll extends BitmapScrollingBase implements IBitmapDataScroller
	{
		
		
	// [ PROPERTY SETTERS
	
		/*
		 * indexes the bitmap data, creates rectangles for each bitmap object passed
		 * in the array and positions it, indexing each one to get the total width
		 */
		override protected function indexBitmapData( bmd : BitmapData ) : void
		{
			// will end up with the last rectangle position
			if( _collectionRects.length - 1 > -1 )
			 var lastRect:Rectangle = _collectionRects[ _collectionRects.length - 1];

            var lastX:int = lastRect ? lastRect.x + lastRect.width : 0;
			 
			 // create a rectangle for data
			 var rect : Rectangle = new Rectangle( lastX, 0, bmd.width, bmd.height );
			 _collectionRects.push( rect );
			 
			  _totalWidth += rect.width;
			  _maxHeight = Math.max( _maxHeight, bmd.height ); // change max height if need be
			  
		}
		
		/*
		 * draw the data, keep looping until the area of the canvas has been filled
		 */
		override protected function draw( sampleArea : Rectangle, offset:Point = null ) : void 
		{
			_calculationPoint.x = sampleArea.x;
            _calculationPoint.y = sampleArea.y;
			
            _collectionID = calculateCollectionStartIndex(_calculationPoint);
			
            if ( _collectionID != -1)
            {
                _sourceRect = _collectionRects[_collectionID];

               _sourceBitmapData = _bitmapDataCollection[_collectionID];

                _leftover = Math.round(calculateLeftOverValue(sampleArea.x, sampleArea.width, _sourceRect));

                if (!offset)
                    offset = _copyPixelOffset;

                point = calculateSamplePosition(sampleArea, _sourceRect);

                sampleArea.x = point.x;
                sampleArea.y = point.y;

                bitmapData.copyPixels(_sourceBitmapData, sampleArea, offset);

                if ( _leftover > 0 )
                {
                    offset = new Point( bitmapData.width - _leftover, 0);
                    var leftOverSampleArea:Rectangle = calculateLeftOverSampleArea(sampleArea, _leftover, _sourceRect );

                    draw(leftOverSampleArea, offset);
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
            _sampleArea.width = leftOver;
            _sampleArea.x = sourceRect.x + sourceRect.width;
            return _sampleArea;
        }
		
		/*
		 * get the position of the sample data
		 */
		private function calculateSamplePosition( sampleRect : Rectangle, sourceArea : Rectangle ) : Point
        {
            _samplePositionPoint.x = sampleRect.x - sourceArea.x;
            return _samplePositionPoint;
        }
		
		/*
		 * calculate the left over, getting the stage width and then
		 * calculating the remaining size left to draw in more data
		 */
		private function calculateLeftOverValue( offset : Number , sampleWidth : Number , sourceRect : Rectangle ) : Number
		{
			 _difference = (offset + sampleWidth) - (sourceRect.x + sourceRect.width);
            return ( _difference < 0) ? 0 : _difference;
		}

	// ] 
	
	
	}
}
