

package com.flexcapacitor.utils.supportClasses {
	
	import com.flexcapacitor.utils.supportClasses.XMLValidationInfo;
	
	import flash.events.Event;
	
	/**
	 * Event from XML Validation result
	 * */
	public class XMLValidationEvent extends Event {
		
		/**
		 * Value returned from location change event
		 * */
		public var result:XMLValidationInfo;
		
		public function XMLValidationEvent(result:XMLValidationInfo = null) {
			this.result = result;
			
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new XMLValidationEvent(result);
		}
		
		
	}
}