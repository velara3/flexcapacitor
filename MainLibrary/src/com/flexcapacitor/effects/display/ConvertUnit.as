

package com.flexcapacitor.effects.display {
	
	import com.flexcapacitor.effects.display.supportClasses.ConvertUnitInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.IEffect;
	
	/**
	 * Event dispatched when value is invalid
	 * */
	[Event(name="invalidValue", type="flash.events.Event")]
	
	/**
	 * Converts a value from one measurement to another
	 * */
	public class ConvertUnit extends ActionEffect {
		
		
		public static const INCHES_TO_PIXELS:String 		= "inchesToPixels";
		public static const MILLIMETERS_TO_PIXELS:String 	= "millimetersToPixels";
		public static const PIXELS_TO_INCHES:String 		= "pixelsToInches";
		public static const PIXELS_TO_MILLIMETERS:String 	= "pixelsToMillimeters";
		
		public static const INVALID_VALUE:String 			= "invalidValue";
		
		
		
		/**
		 *  Constructor.
		 * */
		public function ConvertUnit(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = ConvertUnitInstance;
		}
		
		/**
		 * The value to convert
		 * */
		public var value:Object;
		
		/**
		 * The converted value
		 * */
		[Bindable]
		public var result:Number;
		
		/**
		 * Convert types
		 * */
		[Inspectable(enumeration="inchesToPixels,pixelsToInches,millimetersToPixels,pixelsToMillimeters")]
		public var convertUnitType:String = PIXELS_TO_INCHES;
		
		/**
		 * Effect played when value is invalid
		 * */
		public var invalidValueEffect:IEffect;
		
		/**
		 * Dots per inch or points per inch (DPI, PPI)
		 * Default is 72
		 * */
		public var dotsPerInch:uint = 72;
		
		/**
		 * Number of decimal places when converting to inches
		 * */
		public var decimalPlaces:uint = 2;
		
	}
}