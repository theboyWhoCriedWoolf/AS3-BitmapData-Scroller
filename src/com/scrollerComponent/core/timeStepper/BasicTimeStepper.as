package com.scrollerComponent.core.timeStepper
{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * @author Tal
	 */
	public class BasicTimeStepper extends Sprite implements ITimeStepper
	{
		// private properties
		protected var _timer 			: Timer;
		protected var _dt				: Number = 0.01;
		protected var _time				: Number = 0;
		protected var _t0				: Number = 0;
		protected var _accumulator 		: Number = 0.0;
		protected var _frameTime 		: Number = 0.0;
		protected var _frameRate 		: Number = 0;
		protected var _useEnterFrame	: Boolean;
		protected var _update	 		: Function;
		protected var _render	 		: Function;
		
		
		/*
		 * initiate the timer
		 */
		public function initiateTimer( update : Function, render : Function, steps : Number = 1, pSteps : int = 0, deltaTime : Number = 0.01, useEnterFrame : Boolean = false ) : void  
		{
			_update 			= update;
			_render 			= render;
			_timer 				= new Timer( steps, pSteps );
			_useEnterFrame		= useEnterFrame;
		}
		
		/*
		 * start the timer
		 */
		public function startTimer() : void 
		{
			if( _useEnterFrame )
			{
				addEventListener( Event.ENTER_FRAME, tick_handler, false, 0, true );
			}
			else
			{
				_timer.addEventListener( TimerEvent.TIMER, tick_handler, false, 0, true );
				_timer.start();
			}
			
			_frameTime = 0;
			_t0 = getTimer();
			_time = 0;
			_accumulator = 0.0;
		}
		
		/*
		 * animate each frame, adding to the delta time in case of any lapse in framerate
		 */
		protected function tick_handler( event : Event ) : void
		{
			event.stopImmediatePropagation();
			
			_dt 		= 0.001 * ( getTimer() - _t0 );
			_t0  		= getTimer();
			
			_time 		+= _dt;
			_render();
			
			if( !_useEnterFrame ) TimerEvent( event ).updateAfterEvent();
		}
		
		/*
		 * delta time 
		 */
		public function get dt() : Number { return _dt; }
		
		
		/*
		 * Stop the timer
		 */
		public function stopTimer() : void
		{
			if( _useEnterFrame )
			{
				if( this.hasEventListener( Event.ENTER_FRAME ) ) this.removeEventListener( Event.ENTER_FRAME, tick_handler );
			}
			else
			{
				_timer.removeEventListener( TimerEvent.TIMER, tick_handler );
				_timer.stop();
			}
		}
		
		/*
		 * dispose
		 */
		public function dispose() : void
		{
			stopTimer();
			if ( _timer && _timer.running ) _timer.stop();
			_timer = null;			
		}
		
	}
}
