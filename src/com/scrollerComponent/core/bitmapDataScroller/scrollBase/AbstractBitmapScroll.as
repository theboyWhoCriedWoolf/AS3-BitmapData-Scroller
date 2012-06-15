package com.scrollerComponent.core.bitmapDataScroller.scrollBase
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.System;

	/**
	 * @private
	 * @author Tal
	 */
	public class AbstractBitmapScroll extends Bitmap
	{
		
		// Static properties
		protected const INVALID_SIZE_SCROLL			: String = "all";
		protected const INVALID_SIZE 				: String = "size";
		protected const INVALID_SCROLL				: String = "scroll";
		
		// private properties
		protected var _internalSampleArea			: Rectangle;
		protected var _invalidScroll 				: Boolean;
		protected var _invalidSize 					: Boolean;
		protected var _invalid 						: Boolean;
		protected var _calcStartXPos				: Number = 0;
		protected var _calcEndXPos					: Number = 0;
		protected var _calcStartYPos				: Number = 0;
		protected var _calcEndYPos					: Number = 0;
		
		
		
		/*
		 * Constructor
		 */
		public function AbstractBitmapScroll( bitmapData : BitmapData = null , pixelSnapping : String = "auto" , smoothing : Boolean = false )
		{
			super( bitmapData , pixelSnapping , smoothing );
			addEventListener( Event.ADDED_TO_STAGE, addedToStage_handler , false, 0, true );
			init();
		}
		
		/*
		 * init
		 */
		protected function init() : void  { _internalSampleArea = new Rectangle(); }

	// [ HANDLERS
	
		// added to stage ( render )
		private function addedToStage_handler( event : Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE, addedToStage_handler );
			addEventListener( Event.REMOVED_FROM_STAGE, removeFromStage_handler );
			render();
		}
		
		// removed from stage
		private function removeFromStage_handler( event : Event ) : void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE, removeFromStage_handler );
			dispose();
		}
		
	// ] 
	
		/*
		 * dispose
		 */
		public function dispose() : void
		{
			if( _internalSampleArea ) _internalSampleArea = null;
			System.gc(); // force garbage collection
		}
		
		/*
		 * render, to be overriden 
		 */
		public function render() : void {};
		
		
	// [ OVERRIDE PROPERTIES
		
		// override width property
		override public function get width() : Number { return _internalSampleArea.width; }
		override public function set width( value : Number ) : void
		{
			 if ( value == _internalSampleArea.width ) return;
			_internalSampleArea.width = value;
			 invalidate( INVALID_SIZE );
			 
		}
		
		// override height property
		override public function get height() : Number { return _internalSampleArea.height; }
		override public function set height( value : Number ) : void
		{
			 if ( value == _internalSampleArea.height ) return;
			_internalSampleArea.height = value;
			 invalidate( INVALID_SIZE );
		}
		
	// ] 
	
	// [ POSITION PROPERTIES
	
		/*
		 * set the x position of the main bitmap canvas
		 */
		public function get xPos() : Number { return _internalSampleArea.x; }
		public function set xPos( xpos : Number ) : void
		{
			if( _internalSampleArea.x == xpos ) return;
			_internalSampleArea.x = xpos;
			invalidate( INVALID_SCROLL ); 
		}
		
		/*
		 * set the y position of the main canvas
		 */
		public function get yPos() : Number { return _internalSampleArea.y; }
		public function set yPos( ypos : Number ) : void
		{
			if( _internalSampleArea.y == ypos ) return;
			_internalSampleArea.y = ypos;
			invalidate( INVALID_SCROLL );  
		}
			
	// ] 
	
		
	// [ INVALIDATE 
		
		/*
		 * clear all invalidations to reset
		 */
		protected function clearInvalidation() : void 
		{
			_invalidScroll 	= false;
			_invalidSize 	= false;
			_invalid		= false;
		}
		
		/*
		 * invalidate method, pervents updates occuring unecissarily,
		 * if invalidate is true then draw then clear invalidation
		 */
		public function invalidate( type : String = "all" ) : void 
		{
			if ( !_invalid)
			{
				_invalid = true;
				switch( type )
				{
					
					case INVALID_SCROLL : // scrolling has changed
					    _invalidScroll = true;
						
						break;
						
					case INVALID_SIZE : // size has changed
	                    _invalidSize = true;
						
						break;
					
					case INVALID_SIZE_SCROLL : // scrolling position has changed
						_invalidScroll = true;
	                    _invalidSize = true;
						break;
				}
			}
		}
		
	// ] 
	
	}
}
