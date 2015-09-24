
package com.flexcapacitor.utils.supportClasses {
	
	/**
	 * Describes XML after it has been validated by a XMLUtils.validate call. 
	 * */
	public class XMLValidationInfo {

		/**
		 *  
		 */
		public function XMLValidationInfo () {
			super();
		}

		/**
		 * If true has a byte marker as the first character. 
		 * XML cannot have any charcter before the first XML declaration
		 * or root node. Byte order markers are invisible characters
		 * that provide information about how information is stored in a
		 * file.  
		 */
		public var hasMarker:Boolean;
		
		/**
		 *  Type of byte marker found
		 */
		public var byteMarkerType:String;
		
		/**
		 *  Row where error begins
		 */
		public var row:int;

		/**
		 *  Column where error begins
		 */
		public var column:int;
		
		/**
		 *  If true indicates if XML is valid
		 */
		public var valid:Boolean;
		
		/**
		 *  browser error message
		 */
		public var browserErrorMessage:String;
		
		/**
		 *  Flash Player error message from Flash Player try catch of new XML(value)
		 */
		public var internalErrorMessage:String;
		
		/**
		 * Trims the first line of text from the error message
		 * */
		public var specificErrorMessage:String;
		
		/**
		 *  Error message from Flash Player try catch of new XML(value)
		 */
		public var errorMessage:String;
		
		/**
		 *  Error from Flash Player try catch of new XML(value)
		 */
		public var error:Error;
		
		/**
		 *  Value used in the test
		 */
		public var value:String;
		
		/**
		 *  Beginning index of the error
		 */
		public var beginIndex:int;
		
		/**
		 *  Ending index of the error
		 */
		public var endIndex:int;
	}
}