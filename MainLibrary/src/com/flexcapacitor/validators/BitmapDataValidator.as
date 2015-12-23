package com.flexcapacitor.validators {
	import flash.display.BitmapData;
	
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class BitmapDataValidator extends Validator
	{
		public function BitmapDataValidator()
		{
		}
		
		/**
		 *  Override of the base class <code>doValidation()</code> method
		 *  to validate bitmap data.
		 *
		 *  <p>You do not call this method directly;
		 *  Flex calls it as part of performing a validation.
		 *  If you create a custom Validator class, you must implement this method.</p>
		 *
		 *  @param value Object to validate.
		 *
		 *  @return An Array of ValidationResult objects, with one ValidationResult 
		 *  object for each field examined by the validator. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override protected function doValidation(value:Object):Array {
			var results:Array = [];//super.doValidation(value);
			
			
			
			return BitmapDataValidator.validateBitmapData(this, value);
			
		}
		
		public var bitmapIsNullError:String = "Bitmap data cannot be null"; 
		public var valueIsNotBitmapDataError:String = "Value is not of type BitmapData"; 
		public var bitmapIsZeroSizeError:String = "Bitmap data cannot have zero width and zero height"; 
			
		public static function validateBitmapData(validator:BitmapDataValidator, value:Object, baseField:String = null):Array {
			var results:Array = [];
			
			
			if (value==null) {
				results.push(new ValidationResult(true, baseField, "bitmapIsNull", validator.bitmapIsNullError));
				return results;
			}
			
			if (!(value is BitmapData)) {
				results.push(new ValidationResult(true, baseField, "valueIsNotBitmapData", validator.valueIsNotBitmapDataError));
					// StringUtil.substitute(validator.valueIsNotBitmapDataError, getQualifiedClassName(value)))
				return results;
			}
			
			if (value is BitmapData && (value.width<=0 || value.height<=0)) {
				results.push(new ValidationResult(true, baseField, "valueIsZeroSize", validator.bitmapIsZeroSizeError));
					// StringUtil.substitute(validator.valueIsNo)BitmapDataError, getQualifiedClassName(value)))
				return results;
			}
			
			return results;
		}
	}
}