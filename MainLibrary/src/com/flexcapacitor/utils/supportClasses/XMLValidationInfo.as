
package com.flexcapacitor.utils.supportClasses {
	
	public class XMLValidationInfo {
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		public function XMLValidationInfo () {
			super();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  hasMarker
		//----------------------------------
		
		/**
		 *  @private
		 */
		public var hasMarker:Boolean;
		
		//----------------------------------
		//  byteMarkerType
		//----------------------------------
		
		/**
		 *  @private
		 */
		public var byteMarkerType:String;
		
		//----------------------------------
		//  row
		//----------------------------------
		
		/**
		 *  @private
		 */
		public var row:int;
		
		//----------------------------------
		//  column
		//----------------------------------
		
		/**
		 *  @private
		 */
		public var column:int;
		
		//----------------------------------
		//  valid
		//----------------------------------
		
		/**
		 *  @private
		 */
		public var valid:Boolean;
		
		//----------------------------------
		//  browser error message
		//----------------------------------
		
		/**
		 *  @private
		 */
		public var browserErrorMessage:String;
		
		//----------------------------------
		//  Flash Player parsing error message
		//----------------------------------
		
		/**
		 *  @private
		 */
		public var errorMessage:String;
		
		//----------------------------------
		//  value
		//----------------------------------
		
		/**
		 *  @private
		 */
		public var value:String;
		
		//----------------------------------
		//  error begin index
		//----------------------------------
		
		/**
		 *  @private
		 */
		public var beginIndex:int;
		
		//----------------------------------
		//  error end index
		//----------------------------------
		
		/**
		 *  @private
		 */
		public var endIndex:int;
	}
}