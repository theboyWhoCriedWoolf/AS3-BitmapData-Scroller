package com.scrollerComponent.core.timeStepper
{
	/**
	 * @author Tal
	 */
	public interface ITimeStepper
	{
		// create the timer
		function initiateTimer( update : Function, render : Function, steps : Number = 10, pSteps : int = 0, deltaTime : Number = 0.01, useEnterFrame : Boolean = false ) : void 
		// strat the timer
		function startTimer() : void 
		// stop timer
		function stopTimer() : void
		// dispose
		function dispose() : void
		// return delta time
		function get dt() : Number
	}
}
