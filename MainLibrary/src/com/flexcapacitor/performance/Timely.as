package com.flexcapacitor.performance
{

	import flash.utils.getTimer;
	
	/**
	 * A timer that gives sub-millisecond estimates that are more accurate than the
	 * whole-millisecond values provided by raw usage of flash.utils.getTimer.
	 * 
	 * Inspired by Benjamin Guihaire's excellent article on the same topic that
	 * provides a similar class: AccurateTimer (http://guihaire.com/code/?p=791)
	 * 
	 * @author Jackson Dunstan (http://JacksonDunstan.com)
	 * @license MIT (http://opensource.org/licenses/MIT)
	 */
	public class Timely
	{
		/** The number of "do{someInt++;}while(getTimer()<intVal)" iterations
		 *** that can be run in one millisecond at the time that calibrate() was
		 *** called. This is initially set to zero and therefore the timer is not
		 *** usable until this is set. Overwriting this value will change the
		 *** results of this timer and is only recommended if you have a suitable
		 *** value such as one read from another timer. Reading this value may be
		 *** useful for comparing performance or other statistics in addition to
		 *** aiding in debugging efforts. */
		public var iterationsPerMS:Number = 0;
		
		/** Time from getTimer() after the last call to begin() */
		public var beginTime:int;
		
		/**
		 * Create the timer and optionally calibrate it
		 * @param calibrate Calibrate the timer by calling calibrate(). Defaults
		 *                  to true. If false, you'll need to call calibrate()
		 *                  before using it or set iterationsPerMS manually.
		 */
		public function Timely(calibrate:Boolean=true)
		{
			if (calibrate)
			{
				this.calibrate();
			}
		}
		
		/**
		 * Calibrate the timer. You must call this function or manually set
		 * iterationsPerSecond before using the timer or your results will be
		 * highly inaccurate.
		 * @param msToCalibrate The number of milliseconds to spend calibrating
		 *                      the timer. Higher values will increase the
		 *                      timer's accuracy. This is clamped to at least one
		 *                      millisecond and therefore calibration is quite
		 *                      slow compared to most operations.
		 * @return The number of iterations per millisecond
		 */
		public function calibrate(msToCalibrate:int=10): Number
		{
			// Must spend at least one millisecond calibrating
			if (msToCalibrate < 1)
			{
				msToCalibrate = 1;
			}
			
			// Loop until getTimer starts the next millisecond
			// The idea is to start as close to the beginning of the next
			// millisecond as possible, so the loop is kept as minimal and fast
			// as possible.
			var targetMS:int = getTimer() + 1;
			do
			{
			} while (getTimer() < targetMS);
			
			// Now that we are very close to the beginning of the millisecond we
			// are in a position to count the number of iterations we can
			// achieve in each subsequent millisecond.
			var iterationCount:int;
			targetMS = getTimer() + msToCalibrate;
			do
			{
				iterationCount++;
			} while (getTimer() < targetMS);
			
			// Average the number of iterations we achieved
			this.iterationsPerMS = Number(iterationCount) / msToCalibrate;
			
			// Return the number of iterations per millisecond in case it is of
			// interest to the caller
			return this.iterationsPerMS;
		}
		
		/**
		 * Start the timer. The timer will wait until the beginning of
		 * getTimer()'s next millisecond in order to establish a more accurate
		 * start time. As a side effect, starting the timer can be costly in that
		 * it could take up to one full millisecond to start. You should
		 * therefore not start the timer often as it can easily degrade
		 * application performance.
		 * @return The next millisecond time, which will be the current time at
		 *         the end of this function
		 */
		public function begin(): int
		{
			// Loop until getTimer starts the next millisecond
			// The idea is to start as close to the beginning of the next
			// millisecond as possible, so the loop is kept as minimal and fast
			// as possible.
			this.beginTime = getTimer() + 1;
			var targetMS:int = this.beginTime;
			do
			{
			} while (getTimer() < targetMS);
			
			// Now that we are very close to the beginning of the millisecond
			// the caller can begin the activities to time. Return them the
			// current time.
			return targetMS;
		}
		
		/**
		 * End the timer and get the elapsed time since it began
		 * @return The number of milliseconds elapsed since begin() last returned
		 *         or a NaN if iterationsPerMS is either NaN or negative. If
		 *         iterationsPerMS is negative, the negation of the correct value
		 *         is returned.
		 */
		public function end(): Number
		{
			// Since we could be ending the timer at any point during the
			// millisecond, we need to count iterations in the same way as
			// during calibration until the millisecond ends in order to
			// determine the amount of the millisecond that occurred before the
			// call to this function.
			var iterationCount:int;
			var targetMS:int = getTimer() + 1;
			do
			{
				iterationCount++;
			} while (getTimer() < targetMS);
			
			// Compute the portion of the millisecond that came after the call
			// to this function based on the calibration value iterationsPerMS
			var portionNotUsed:Number = iterationCount / this.iterationsPerMS;
			
			// The traditional way to get the elapsed time would be
			//   (end - begin)
			// which in this case would be
			//   (targetMS - beginTime - 1)
			// However, that would not account for the portion of the
			// millisecond that was used after the "end" millisecond began. So
			// instead of subtracting the full millisecond ("1" in the above),
			// only subtract the portion of the millisecond that we've computed
			// was not used.
			return targetMS - this.beginTime - portionNotUsed;
		}
	}
}