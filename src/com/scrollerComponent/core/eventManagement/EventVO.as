package com.scrollerComponent.core.eventManagement
{
	/**
	 * @private
	 * @author Tal
	 */
	public class EventVO
	{
		/*
		 * cast at runtime depending on the event type
		 */
		public function get event() : * { return _Event;}
		
		public function set event( event : * ) : void
		{
			_Event = event;
		}
		private var _Event : *;
	}
}
