package com.scrollerComponent.core.timeStepper
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	
	
	/**
	 * Handles the timestepping and rendering of the list component view
	 * 
	 * @author Tal
	 */
	final public class TimeStepper extends BasicTimeStepper implements ITimeStepper
	{
		// private properties
		private var _newTime 		: Number = 0.0;
		
		/*
		 * initiate the timer
		 */
		override public function initiateTimer( update : Function, render : Function, steps : Number = 1, pSteps : int = 0, deltaTime : Number = 0.01, useEnterFrame : Boolean = false ) : void 
		{
			super.initiateTimer( update, render, steps, pSteps, deltaTime, useEnterFrame );
			_dt	= deltaTime; 
		}
		
		/*
		 * animate each frame, adding to the delta time in case of any lapse in framerate
		 */
		override protected function tick_handler( event : Event ) : void
		{
			event.stopImmediatePropagation();
			
			_newTime		= getTimer();
			_frameTime 		= ( _newTime - _t0 );
			_t0  			= _newTime;
			
			if( _frameTime > _dt ) _frameTime = _dt;
			_accumulator += _frameTime;
			
			while( _accumulator >= _dt )
	        {
				_accumulator -= _dt;
				_update();
				_time += _dt;
			}
			_render();
			if( !_useEnterFrame ) TimerEvent( event ).updateAfterEvent();
		}
		
		
	}
}
