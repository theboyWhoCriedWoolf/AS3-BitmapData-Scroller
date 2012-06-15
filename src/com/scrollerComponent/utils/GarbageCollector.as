package com.scrollerComponent.utils
{
	import flash.system.System;
	/**
	 * @private
	 * @author Tal
	 */
	public class GarbageCollector
	{
		public static function collect() : void 
		{
			try
			{
				System.gc();
			}
			catch( e : Error )
			{
				// fail silently 
			}
		}
	}
}
