package com.scrollerComponent.core.eventManagement
{
	import org.osflash.signals.Signal;

	import flash.display.InteractiveObject;
	/**
	 * @author Tal
	 */
	public interface IEventManager
	{
		// add lsiteners to passed objects
		function addListeners( obj : InteractiveObject ) : void 
		// remove listenets from object
		function removeListeners( obj : InteractiveObject ) : void 
		// add listeners by type requested
		function addListenerByType( obj : InteractiveObject, type : String ) : void 
		// remove listener by type
		function removeListenerByType( obj : InteractiveObject, type : String ) : void 
		// remove a handler function from signal
		function removeSignalListener( handler : Function ) : void 
		// dispose
		function dispose() : void 
		
		// [ SIGNALS
		
			// mouse down
			function get mouseDownSignal() : Signal 
			function set mouseDownSignal( signal : Signal ) : void
			// mouse up
			function get mouseUpSignal() : Signal 
			function set mouseUpSignal( signal : Signal ) : void
			// click handler
			function get mouseClickSignal() : Signal 
			function set mouseClickSignal( signal : Signal ) : void
			// mouse move
			function get mouseMoveSignal() : Signal
			function set mouseMoveSignal( signal : Signal ) : void
		
		//
	}
}
