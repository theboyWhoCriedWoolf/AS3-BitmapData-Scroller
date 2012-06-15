package com.scrollerComponent.core.eventManagement
{
	import org.osflash.signals.Signal;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	
	/**
	 * Class to allow the use of events and automativclly switch between mouse and touch events based on availability
	 * Will speed up and prevent bubbling, uses signals instead to dispatch to registered handlers
	 * Automatically switches to MultitouchInputMode.TOUCH_POINT if available
	 * 
	 * @author Tal
	 */
	final public class EventManager implements IEventManager
	{
		
		// public consts
		public static const MOUSE_DOWN 		: String = "mouse_down";
		public static const MOUSE_UP 		: String = "mouse_up";
		public static const MOUSE_MOVE		: String = "mouse_move";
		public static const CLICK			: String = "click";
		// signal holder
		private static var _signalCont		: Vector.<Signal> = new Vector.<Signal>();
		
		/*
		 * Constructor, set the event moe otherwise events wont work
		 */
		public function EventManager( ) : void 
		{ 
			setMode(); 
			
			// append signals
			_signalCont.push( mouseDownSignal );
			_signalCont.push( mouseUpSignal );
			_signalCont.push( mouseClickSignal );
			_signalCont.push( mouseMoveSignal );
			
		}
		
		/**
		 * Add listeners based on interaction type
		 */
		public function addListeners( obj : InteractiveObject ) : void 
		{
			if( obj == null ) return;
			if( Multitouch.supportsTouchEvents )
			{
				obj.addEventListener( TouchEvent.TOUCH_BEGIN, mouseDown_handler, false, 0, true );
				obj.addEventListener( TouchEvent.TOUCH_END, mouseUp_handler, false, 0, true );
				obj.addEventListener( TouchEvent.TOUCH_TAP, click_handler, false, 0, true );
				obj.addEventListener( TouchEvent.TOUCH_MOVE, mouseMove_handler, false, 0, true );
				return;
			}
			// add normal mouse events
			obj.addEventListener( MouseEvent.MOUSE_DOWN, mouseDown_handler, false, 0, true );
			obj.addEventListener( MouseEvent.MOUSE_UP, mouseUp_handler, false, 0, true );
			obj.addEventListener( MouseEvent.CLICK, click_handler, false, 0, true );
			obj.addEventListener( MouseEvent.MOUSE_MOVE, mouseMove_handler, false, 0, true );
		}

		/**
		 * Remove listeners based on interaction type
		 */
		public function removeListeners( obj : InteractiveObject ) : void 
		{
			if( obj == null ) return;
			if( Multitouch.supportsTouchEvents )
			{
				if( obj.hasEventListener( TouchEvent.TOUCH_BEGIN ) ) 		obj.removeEventListener( TouchEvent.TOUCH_BEGIN, mouseDown_handler );
				if( obj.hasEventListener( TouchEvent.TOUCH_END ) ) 			obj.removeEventListener( TouchEvent.TOUCH_END, mouseUp_handler );
				if( obj.hasEventListener( TouchEvent.TOUCH_TAP ) ) 			obj.removeEventListener( TouchEvent.TOUCH_TAP, click_handler );
				if( obj.hasEventListener( TouchEvent.TOUCH_MOVE ) ) 		obj.removeEventListener( TouchEvent.TOUCH_MOVE, mouseUp_handler );
				return;
			}
			
			// add normal mouse events
			if( obj.hasEventListener( MouseEvent.MOUSE_DOWN ) )				obj.removeEventListener( MouseEvent.MOUSE_DOWN, mouseDown_handler );
			if( obj.hasEventListener( MouseEvent.MOUSE_UP ) )				obj.removeEventListener( MouseEvent.MOUSE_UP, mouseUp_handler );
			if( obj.hasEventListener( MouseEvent.CLICK ) )					obj.removeEventListener( MouseEvent.CLICK, click_handler );
			if( obj.hasEventListener( MouseEvent.MOUSE_MOVE ) )				obj.removeEventListener( MouseEvent.MOUSE_MOVE, mouseMove_handler );
		}
		
		/**
		 * Add listener to Interactive object by type
		 */
		public function addListenerByType( obj : InteractiveObject, type : String ) : void 
		{
			if( obj == null ) return;
			switch( type )
			{
				case MOUSE_DOWN :
					if( Multitouch.supportsTouchEvents ) obj.addEventListener( TouchEvent.TOUCH_BEGIN, mouseDown_handler, false, 0, true );
					else obj.addEventListener( MouseEvent.MOUSE_DOWN, mouseDown_handler, false, 0, true );
					break;
					
				case MOUSE_UP:
					if( Multitouch.supportsTouchEvents ) obj.addEventListener( TouchEvent.TOUCH_END, mouseUp_handler, false, 0, true );
					else obj.addEventListener( MouseEvent.MOUSE_UP, mouseUp_handler, false, 0, true );
					break;
					
				case MOUSE_MOVE:
					if( Multitouch.supportsTouchEvents ) obj.addEventListener( TouchEvent.TOUCH_MOVE, mouseMove_handler, false, 0, true );
					else obj.addEventListener( MouseEvent.MOUSE_MOVE, mouseMove_handler, false, 0, true );
					break;
					
				case CLICK:
					if( Multitouch.supportsTouchEvents ) obj.addEventListener( TouchEvent.TOUCH_TAP, click_handler, false, 0, true );
					else obj.addEventListener( MouseEvent.CLICK, click_handler, false, 0, true );
					break;
			}
		}
		
		/**
		 * Remove listener by type
		 */
		public function removeListenerByType( obj : InteractiveObject, type : String ) : void 
		{
			if( obj == null ) return;
			try
			{
				switch( type )
				{
					case MOUSE_DOWN :
						if( Multitouch.supportsTouchEvents ) obj.removeEventListener( TouchEvent.PROXIMITY_BEGIN, mouseDown_handler);
						else obj.removeEventListener( MouseEvent.MOUSE_DOWN, mouseDown_handler );
						break;
						
					case MOUSE_UP:
						if( Multitouch.supportsTouchEvents ) obj.removeEventListener( TouchEvent.TOUCH_END, mouseUp_handler );
						else obj.removeEventListener( MouseEvent.MOUSE_UP, mouseUp_handler );
						break;
					
					case MOUSE_MOVE:
						if( Multitouch.supportsTouchEvents ) obj.removeEventListener( TouchEvent.TOUCH_MOVE, mouseMove_handler );
						else obj.removeEventListener( MouseEvent.MOUSE_MOVE, mouseMove_handler );
						break;
						
					case CLICK:
						if( Multitouch.supportsTouchEvents ) obj.removeEventListener( TouchEvent.TOUCH_TAP, click_handler );
						else obj.removeEventListener( MouseEvent.CLICK, click_handler );
						break;
				}
			}
			catch( e : Error ) { throw new Error("ERROR removing event listener from obj :: " + e ); } // fail 
		}
		

	// [ HANDLERS
	
		private function click_handler( event : * ) : void
		{
			event.stopImmediatePropagation();
			var eventVo : EventVO = vo;
			eventVo.event = event;
			mouseClickSignal.dispatch( eventVo  );
		}

		private function mouseUp_handler( event : * ) : void
		{
			event.stopImmediatePropagation();
			var eventVo : EventVO = vo;
			eventVo.event = event;
			mouseUpSignal.dispatch( eventVo  );
		}

		private function mouseDown_handler( event : * ) : void
		{
			event.stopImmediatePropagation();
			var eventVo : EventVO = vo;
			eventVo.event = event;
			mouseDownSignal.dispatch( eventVo );
		}
		
		private function mouseMove_handler( event : * ) : void
		{
			event.stopImmediatePropagation();
			var eventVo : EventVO = vo;
			eventVo.event = event;
			mouseMoveSignal.dispatch( eventVo );
		}
		
	// ]
	
	// [ SIGNALS
	
		/**
		 * Mouse Down signal
		 */
		public function get mouseDownSignal() : Signal { return _mouseDownSignal; }
		public function set mouseDownSignal( signal : Signal ) : void
		{
			_mouseDownSignal = signal;
		}
		private var _mouseDownSignal : Signal = new Signal( EventVO );
		
		/**
		 * Mouse up signal
		 */
		public function get mouseUpSignal() : Signal { return _mouseUpSignal; }
		public function set mouseUpSignal( signal : Signal ) : void
		{
			_mouseUpSignal = signal;
		}
		private var _mouseUpSignal : Signal = new Signal( EventVO );
		
		/**
		 * Click signal
		 */
		public function get mouseClickSignal() : Signal { return _mouseClickSignal; }
		public function set mouseClickSignal( signal : Signal ) : void
		{
			_mouseClickSignal = signal;
		}
		private var _mouseClickSignal : Signal = new Signal( EventVO );
		
		/**
		 * Mouse move signal
		 */
		public function get mouseMoveSignal() : Signal { return _mouseMoveSignal; }
		public function set mouseMoveSignal( signal : Signal ) : void
		{
			_mouseMoveSignal = signal;
		}
		private var _mouseMoveSignal : Signal = new Signal( EventVO );
	
	// ] 
	
		/**
		 * Remove signal handler function
		 */
		public function removeSignalListener( handler : Function ) : void 
		{
			var i : uint = _signalCont.length;
			var s : Signal;
			while( --i )
			{
				s = _signalCont[ i ];
				s.remove( handler );
			}
		}
		
		/*
		 * automatically check for the mode
		 */
		private function setMode() : void 
		{
			if( Multitouch.supportsTouchEvents ) Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
		}
	
		/*
		 * return new vo
		 */
		private function get vo() : EventVO { return new EventVO(); }
	
		/**
		 * dispose of signals
		 */
		public function dispose() : void 
		{
			mouseDownSignal.removeAll();
			mouseUpSignal.removeAll();
			mouseClickSignal.removeAll();
			mouseMoveSignal.removeAll();
			
			mouseDownSignal 	= null;
			mouseUpSignal		= null;
			mouseClickSignal 	= null;
			_signalCont			= null;
		}
	
	}
}
