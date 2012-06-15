package com.scrollerComponent.utils
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * @private
	 * @author Tal
	 */
	public class BitmapDataUtils
	{
		/*
		 * add empty bitmap data to an array of bitmap data
		 */
		public static function addEmptyDataToCollection( 
															collection 			: Vector.<BitmapData>, 
															canvas 				: Rectangle, 
															colour 				: int = 0x00000000, 
															alpha 				: Number = 0,
															centerPoint 		: Point = null
														) : void
		{
			var leftPadding 	: BitmapData;
			var rightPadding 	: BitmapData;
			
			var paddingWidth	: int = ( centerPoint != null ) ? ( canvas.width + centerPoint.x ) : canvas.width;
			var paddingHeight	: int = ( centerPoint != null ) ? ( canvas.height + centerPoint.y ) : canvas.height;
			
			var rightShape		: Shape = getPadding( paddingWidth, paddingHeight, colour, alpha );
			var leftShape		: Shape = getPadding( paddingWidth, paddingHeight, colour, alpha );
			rightPadding 		= new BitmapData( paddingWidth, paddingHeight, true, 0x00000000 );
			leftPadding 		= new BitmapData( paddingWidth, paddingHeight, true, 0x00000000 );
			
			rightPadding.draw( rightShape ); // draw padding either side
			leftPadding.draw( leftShape );
			
			collection.unshift( leftPadding ); // addd padding to the array
			collection.push( rightPadding );
		}
		
		/*
		 * add margin to bitmap data elements in an array,
		 * creating empty bitmap data
		 */
		 public static function addMarginToCollectionItems( collection : Vector.<BitmapData>, margin : int ) : void 
		 {
			var i : int = 0;
			var btmpaData : BitmapData;
			for each( var bmd : BitmapData in collection )
			{
				btmpaData = new BitmapData( bmd.width + margin, bmd.height + margin, true, 0x00000000 );
				btmpaData.copyPixels( bmd, new Rectangle( 0, 0, bmd.width, bmd.height ), new Point() );
				
				collection[ i ] = btmpaData;
				i++;
			}
		 }
		
		
		/*
		 * draw padding
		 */
		private static function getPadding( w : int , h : int, col : int, a : Number ) : Shape
		{
			var s : Shape = new Shape();
			s.graphics.beginFill( col, a );
			s.graphics.drawRect(0, 0, w, h  );
			s.graphics.endFill();
			return s;
		}
	}
}
