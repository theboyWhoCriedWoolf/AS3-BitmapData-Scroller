package com.scrollerComponent.core.bitmapDataScroller
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	/**
	 * @author Tal
	 */
	public interface IBitmapDataScroller
	{
		// set the bitmap data vector
		function set setViewCollection( collection : Vector.<BitmapData> ) : void 
		// total bitmapData width
		function get totalCollectionWidth() : Number 
		// total bitmapData height
		function get totalCollectionHeight() : Number 
		// get the total items 
		function get totalCollectionItems() : int 
		// return the actual number of items without the side buffers
		function get actualTotalCollectionItems() : int 
		// return the bitmap data as rect by ID
		function getBitmapDataRectByID( id : int ) : Rectangle 
		// render
		function render() : void 
		// dispose
		function dispose() : void
		
	// [ Selected state
	
		// add a selected state to function as button
		function addOverStateFunctionality( currentColour : uint, replacementColour : uint, mask : uint = 0xFFFFFF ) : void 
		// set selected iten via index
		function currentSelectedItem( index : int ) : void
		
	// [ positioning
	
		// x position of the data
		function get xPos() : Number 
		function set xPos( xpos : Number ) : void
		// y positioning
		function get yPos() : Number 
		function set yPos( ypos : Number ) : void
		
	// ] 
		
		// viewport width
		function get width() : Number
		function set width( value : Number ) : void
		// viewport height
		function get height() : Number
		function set height( value : Number ) : void 
		
	}
}
