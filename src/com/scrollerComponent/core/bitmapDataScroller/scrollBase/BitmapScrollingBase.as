package com.scrollerComponent.core.bitmapDataScroller.scrollBase
{
	import com.scrollerComponent.core.bitmapDataScroller.scrollBase.utils.BitmapDataTransformer;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * @private
	 * @author Tal
	 */
	public class BitmapScrollingBase extends AbstractBitmapScroll
	{
		//private properties
		protected var _bitmapDataCollection 	: Vector.<BitmapData>;
		protected var _collectionRects			: Vector.<Rectangle>;
		protected var _samplePositionPoint		: Point;
		protected var _calculationPoint 		: Point;
		protected var _collectionTotal 			: uint;
		protected var _collectionID 			: int;
		protected var _sourceRect 				: Rectangle;
		protected var _sourceBitmapData 		: BitmapData;
		protected var _leftover 				: Number;
		protected var _difference 				: Number;
		protected var _copyPixelOffset 			: Point;
		protected var point 					: Point;
		protected var _sampleArea 				: Rectangle;
		protected var _maxHeight 				: Number;
		protected var _maxWidth 				: Number;
		protected var _bitmapDataTransformer	: BitmapDataTransformer;
		protected var _totalWidth 				: Number = 0;
		protected var _totalHeight				: Number = 0;
		
		
		/*
		 * Constructor
		 */
		public function BitmapScrollingBase( bitmapData : BitmapData = null , pixelSnapping : String = "auto" , smoothing : Boolean = false )
		{
			super( bitmapData , pixelSnapping , smoothing );
		}
		
				
		/*
		 * create any variables needed
		 */
		override protected function init() : void 
		{
			super.init();
			_collectionRects 		= new Vector.<Rectangle>();
			_samplePositionPoint	= new Point();
			_calculationPoint		= new Point();
			_copyPixelOffset		= new Point();
			
		}

	// [ PROPERTY SETTERS
		
		// adds the ability to have an over state
		public function addOverStateFunctionality( currentColour : uint, replacementColour : uint, mask : uint = 0xFFFFFF ) : void 
		{
			_bitmapDataTransformer = new BitmapDataTransformer();
			_bitmapDataTransformer.setColours( currentColour, replacementColour, mask  );
		}
		// set the current selected item
		public function currentSelectedItem( index : int ) : void 
		{ 
			if( _bitmapDataTransformer === null ) return;
			_bitmapDataTransformer.setSelected( _bitmapDataCollection[ index + 1 ] ); 
			invalidate( INVALID_SCROLL ); 
			render();
		}
		
		// set the bitmapData collection vector
		public function set setViewCollection( collection : Vector.<BitmapData> ) : void 
		{
			_bitmapDataCollection = collection;
			indexCollection();
		}
		
		/*
		 * index all bitmap data, loop through the given array and create index
		 */
		private function indexCollection() : void
		{
			_totalWidth 		= 0;
			_maxHeight			= 0;
			_collectionTotal	= _bitmapDataCollection.length;
			
			var i : int = 0;
			var bmd : BitmapData ;
			while( i < _bitmapDataCollection.length )
			{
				bmd = _bitmapDataCollection[ i ];
				indexBitmapData( bmd );
				++i;
			}
		}

		/*
		 * indexes the bitmap data, creates rectangles for each bitmap object passed
		 * in the array and positions it, indexing each one to get the total width
		 */
		protected function indexBitmapData( bmd : BitmapData ) : void{}
		
	// ]
	
	
	// [ PROPERTY GETTERS
	
		// total bitmapData width
		public function get totalCollectionWidth() : Number { return _totalWidth; }
		// total bitmapData height
		public function get totalCollectionHeight() : Number { return _totalHeight; }
		// get the total items 
		public function get totalCollectionItems() : int { return _collectionTotal; }
		// return the actual number of items without the side buffers
		public function get actualTotalCollectionItems() : int { return ( totalCollectionItems - 2 ); }
	
	
	// ] 
	
	// [ CALCULATIONS

		/*
		 * return the index of a rectangle containing bitmap data
		 */
		protected function calculateCollectionStartIndex( calculationPoint : Point ) : int
		{
			if ( calculationPoint.x < 0 )  return -1; // safeguards errors in drawing bitmapData
			if ( calculationPoint.y < 0 )  return -1;
			
			var i : int = 0;
			while( i < _collectionTotal )
			{
				if ( _collectionRects[ i ].containsPoint( calculationPoint ) ) return i;
				++i;
			}
			return -1;
		}
		
		/*
		 * return therectangle position by id specified, from the _collectionRects arry
		 */
		public function getBitmapDataRectByID( id : int ) : Rectangle 
		{
			if( id < 0 ) id = 0;
			if( id > _collectionRects.length - 1 ) id = _collectionRects.length - 1;
			return _collectionRects[ id ];
		}
		
	// ] 
	
	// [ RENDER
	
	/*
	 * render the view
	 */
	override public function render():void
    {
        if ( _invalid )
        {
            // check to see if the size has changed. If it has we create a new bitmap. If not we clear it with fillRect
            if ( _invalidSize )
            {
                bitmapData = new BitmapData( _internalSampleArea.width, _internalSampleArea.height, true, 0x000000);
            }
            else
            {
                bitmapData.fillRect( _internalSampleArea, 0 );
            }
            // Call sample to get the party started
            draw( _internalSampleArea.clone() );

            // Clear any invalidation
            clearInvalidation();
        }
    }
		
		/*
		 * draw the data, keep looping until the area of the canvas has been filled
		 */
		protected function draw( sampleArea : Rectangle, offset:Point = null ) : void {}
	
	// ] 
	
		// dispose
		override public function dispose() : void 
		{
			_bitmapDataCollection 	= null;
			_collectionRects		= null;
			_sourceBitmapData		= null;
			_sourceRect				= null;
			_sampleArea				= null;
			_copyPixelOffset		= null;
			point					= null;
			bitmapData				= null;
			super.dispose();
			
			if( _bitmapDataTransformer === null ) return;
			_bitmapDataTransformer.dispose();
			_bitmapDataTransformer = null;
			
		}
	
	
	}
}
