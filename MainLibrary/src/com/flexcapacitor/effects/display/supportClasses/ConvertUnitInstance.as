

package com.flexcapacitor.effects.display.supportClasses {
	import com.flexcapacitor.effects.display.ConvertUnit;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.utils.MeasurementUtils;
	
	
	/**
	 * @copy ConvertUnit
	 * */
	public class ConvertUnitInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function ConvertUnitInstance(target:Object) {
			super(target);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 * */
		override public function play():void {
			super.play(); // dispatches startEffect
			
			var action:ConvertUnit = ConvertUnit(effect);
			var convertType:String = action.convertUnitType;
			var dotsPerInch:uint = action.dotsPerInch;
			var value:Number = Number(action.value);
			var decimalPlaces:uint = action.decimalPlaces;
			var result:Number;
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (action.value===null) {
					dispatchErrorEvent("Value is required");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			switch(convertType) {
				
				case ConvertUnit.INCHES_TO_PIXELS: {
					result = MeasurementUtils.inchesToPixels(value, dotsPerInch);
					break;
				}
				case ConvertUnit.PIXELS_TO_INCHES: {
					result = MeasurementUtils.pixelsToInches(value, dotsPerInch, decimalPlaces);
					break;
				}
				case ConvertUnit.MILLIMETERS_TO_PIXELS: {
					result = MeasurementUtils.millimetersToPixels(value, dotsPerInch);
					
					break;
				}
				case ConvertUnit.PIXELS_TO_MILLIMETERS: {
					result = MeasurementUtils.pixelsToMillimeters(value, dotsPerInch);
					
					break;
				}
				default: {
					dispatchErrorEvent("The conversion type was not specified or supported");
					break;
				}
			}
			
			
			action.result = result;
			
			///////////////////////////////////////////////////////////
			// End the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
	}
}