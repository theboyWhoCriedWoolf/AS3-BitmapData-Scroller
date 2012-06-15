package com.scrollerComponent
{
	import com.greensock.TweenLite;
	import com.scrollerComponent.core.eventManagement.EventManager;
	import com.scrollerComponent.core.eventManagement.EventVO;
	import com.scrollerComponent.utils.GarbageCollector;
	import com.scrollerComponent.utils.Orientation;
	import com.scrollerComponent.utils.Position;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;



	/**
	 * List component
	 * Handles all initialisation of interaction, events and instantiation of view elements
	 * 
	 * @author Tal
	 */
	public class ScrollerComponent extends ScrollerComponentBase implements IScrollerComponent
	{
		// private properties
		private var _dragging 		: Boolean;
		private var _initialY 		: Number = 0;
		private var _initialX 		: Number = 0;
		private var _velocityY 		: Number = 0;
		private var _velocityX 		: Number = 0;
		private var _velocity 		: Number = 0;
		private var _moveList		: Function;
		private var _lag			: Number;
		
		
	// [ VIEW PROPERTIES
		
		/**
		 * Set the main properties of the list component
		 * 
		 * @param viewCanvas Main visible area rect
		 * @param objMargin Spacing between list elements
		 * @param snapping Snap to list items when moved
		 * @param bindToCanvas Bind to the visible area or one element
		 * @param orientation List orientation
		 * @param positioning Starting position of the list elements
		 * @param useEnterFrame Use timer or enterframe
		 * 
		 *  @see com.listComponent.AbstractListComponent#canvas
		 *  @see com.listComponent.AbstractListComponent#margin
		 *  @see com.listComponent.AbstractListComponent#snapping
		 *  @see com.listComponent.AbstractListComponent#bindToCanvas
		 *  @see com.listComponent.AbstractListComponent#orientation
		 *  @see com.listComponent.AbstractListComponent#startingPosition
		 *  @see com.listComponent.AbstractListComponent#useEnterFrame
		 */
		public function properties(
											 viewCanvas 		: Rectangle,
											 objMargin			: int 			= 0,
											 snapping			: Boolean 		= false,
											 bindToCanvas		: Boolean		= true,
											 orientation		: String 		= "horiontal",
											 positioning 		: String 		= "left",
											 useEnterFrame		: Boolean		= false
									) : void
		{
			this.canvas	 				= viewCanvas;
			this.margin					= objMargin;
			this.snapping				= snapping;
			this.bindToCanvas			= bindToCanvas;
			this.startingPosition		= ( positioning == Position.LEFT && orientation == Orientation.VERTICLE ) ? Position.TOP : Position.LEFT ;
			this.orientation			= orientation;
			this.useEnterFrame			= useEnterFrame;
		}
		
		/**
		 * initialise the list view
		 * Must be called after all params have been set
		 */
		public function initialiseScroller() : void 
		{
			if( _collection === null ) return;
			
			listHitArea = ( listHitArea === null ) ? this : listHitArea; // set the hit area to this if none specified
			
			eventManager.mouseClickSignal.add( click_handler );			// initialise the event manager
			eventManager.mouseDownSignal.add( mouseDown_handler );
			eventManager.mouseUpSignal.add( mouseUp_handler );
			
			_startingAtCenterPos = ( _positionSelectedToCenter && !bindToCanvas );
			
			initialiseHandlers( orientation );							// set orientation
			initiateBitmapScroller();									// instantiate BitmapData scroller class
			calculateBounds();											// calculate bounds 
			populateAnimator();											// instantiate animator
			align( startingPosition );									// align view
			bitmapDataScroller.render();								// make sure that the view is rendered
			
			_moveList = ( orientation === Orientation.HORIZONTAL ) ? movePanelX : movePanelY; 
			
			this.movementCompletedSignal.add( removeRender );
			animator.tweenCompletedSignal = this.movementCompletedSignal;
			
			this.cacheAsBitmap = true;
			GarbageCollector.collect();
			
			// add listeners
			eventManager.addListenerByType( listHitArea, EventManager.CLICK );
			eventManager.addListenerByType( listHitArea, EventManager.MOUSE_DOWN );
			
		}
	
	// ] 
	
	// [ HANDLERS 
	
		/*
		 * mouse down signal handler
		 */
		private function mouseDown_handler( eventVO : EventVO ) : void
		{
			_dragging = true;
			_initialX = eventVO.event.stageX;
			_initialY = eventVO.event.stageY;
			
			TweenLite.killDelayedCallsTo( bitmapDataScroller );
			TweenLite.killTweensOf( bitmapDataScroller );
			
			animator.stopAnimation();
			storeTapBounds( new Point( _initialX, _initialY ) );
			
			addEventListener( Event.ENTER_FRAME, enterFrame_handler, false, 0, true );
			eventManager.removeListenerByType( listHitArea, EventManager.MOUSE_DOWN );
			eventManager.addListenerByType( stage, EventManager.MOUSE_UP );
		}

		/*
		 * mouse up signal handler 
		 */
		private function mouseUp_handler( eventVO : EventVO ) : void
		{
			_dragging = false;

			eventManager.removeListenerByType( stage, EventManager.MOUSE_UP );
			eventManager.addListenerByType( listHitArea, EventManager.MOUSE_DOWN );
			
			if( _tapBounds.containsPoint( new Point( eventVO.event.stageX, eventVO.event.stageY ) ) ) { return; }
			
			_velocity = ( orientation == Orientation.HORIZONTAL ) ? _velocityX : _velocityY;
			interactionHandler.moveList( bitmapDataScroller, _velocity, animator );
			movementStartedSignal.dispatch();
		}
		
		/*
		 * click handler
		 */
		private function click_handler( eventVO : EventVO ) : void
		{
			if( !_tapBounds.containsPoint( new Point( eventVO.event.stageX, eventVO.event.stageY ) ) ) return;
			movementStartedSignal.dispatch();
			
			if( _startingAtCenterPos )
			{
				// center panel
				if( _addOverstate ) interactionHandler.addSelectedState( bitmapDataScroller, eventVO );
				interactionHandler.centerSelectedPanel( bitmapDataScroller, animator, eventVO, _centerPoint );
				itemSelectedSignal.dispatch( interactionHandler.currentSelectedID );
			}
			else
			{
				// selected state
				if( _addOverstate ) interactionHandler.addSelectedState( bitmapDataScroller, eventVO );
				itemSelectedSignal.dispatch( interactionHandler.currentSelectedID );
				removeRender(); 
			}
		}
	
	// ] 
	
	// [ RENDER
	
		/*
		 * render the view and also track velocity if dragging
		 */
		private function enterFrame_handler( event : Event ) : void
		{
			render_handler();
			if( _dragging )
			{
				trackVelocity();
			}
		}
		
		/*
		 * track velocity based on mouse movement
		 */
		private function trackVelocity() : void
		{
			_lag = animator.iosLagDistance( bitmapDataScroller );
			
			_moveList();
			_velocityX = stage.mouseX - _initialX;
			_velocityY = stage.mouseY - _initialY;

			_initialX = stage.mouseX;
			_initialY = stage.mouseY;
			
		}
	
		// render the scroller
		private function render_handler( event : Event = null ) : void { bitmapDataScroller.render(); }
		
		// remove the render handler
		private function removeRender() : void 
		{
			if( !this.hasEventListener( Event.ENTER_FRAME ) ) return;
			removeEventListener( Event.ENTER_FRAME, render_handler );
			removeEventListener( Event.ENTER_FRAME, enterFrame_handler );
		}
		
	// ] 
		// move the scroller to the mouse position on XAxis
		private function movePanelX() : void { bitmapDataScroller.xPos += ( ( _initialX - stage.mouseX ) * _lag ); }
		// move panel on yAxis
		private function movePanelY() : void { bitmapDataScroller.yPos += ( ( _initialY - stage.mouseY ) * _lag ); }
		
	// [ CONTROLS
	
		 /**
		  * Disable the list component, removing all listeners and perform System.gc()
		  */
		  public function disable() : void 
		  {
				removeRender();
				eventManager.removeListeners( stage );
				eventManager.removeListeners( listHitArea );
				GarbageCollector.collect();
		  }
		 
		 /**
		  * Enable the list, activate all listeners
		  */
		 public function enable() : void 
		 {
			eventManager.addListenerByType( listHitArea, EventManager.CLICK );
			eventManager.addListenerByType( listHitArea, EventManager.MOUSE_DOWN );
		 }
	
	// ] 
		
	}
}
