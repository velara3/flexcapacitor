




package com.flexcapacitor.handlers {
	
	import com.flexcapacitor.utils.TokenReplace;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * Used for setting conditions in action sequences. 
	 * Currently not used
	 * */
	public class Condition extends EventDispatcher {
		
		/**
	     *  @private
	     *  This is a table of pseudonyms.
	     *  Whenever the property being overridden is found in this table,
	     *  the pseudonym is saved/restored instead.
	     */
	    private static const PSEUDONYMS:Object =
	    {
	        width: "explicitWidth",
	        height: "explicitHeight"
	    };
	
	    /**
	     *  @private
	     *  This is a table of related properties.
	     *  Whenever the property being overridden is found in this table,
	     *  the related property is also saved and restored.
	     */
	    private static const RELATED_PROPERTIES:Object =
	    {
	        explicitWidth: [ "percentWidth" ],
	        explicitHeight: [ "percentHeight" ]
	    };
	    
	    [Inspectable(category="General")]
	
	    /**
	     *  The name of the property to match.
	     */
	    public var property:String;
			
		[Inspectable(category="General")]
		
		/**
		 *  The object containing the property to be checked.
		 *
		 *  @default null
		 */
		public var target:Object;
    
	    [Inspectable(category="General")]
	
	    /**
	     *  The value to compare to target property value or parameter value.
	     *
	     *  @default undefined
	     */
	    public var value:*;
		
		// 
	    public var caseSensitive:Boolean = true;
	    
	    
		private var _parameter:String = "";
		
		// url parameter fragment
		[Bindable]
		public function set parameter(value:String):void {
			_parameter = value;
		}
		
		public function get parameter():String {
			return _parameter;
		}
		
		private var _type:String = "";
		
		// condition type
		[Bindable]
		public function set type(value:String):void {
			_type = value;
		}
		
		public function get type():String {
			return _type;
		}
		
		// if this property is set to true and the property or parameter is NOT blank 
		// IE anything but null, undefined or empty 
		// than the condition is met  
		public var isNotBlank:Boolean = false;
		
		// if this property is set to true and the property or parameter IS blank 
		// IE is null, undefined or empty string 
		// than the condition is met  
		public var isBlank:Boolean = false;
		
		// result of last validate call is placed in this value
		public var conditionReport:String = "";
		
		// used to provide condition reports 
		public var debug:Boolean = false;
    
		public function Condition(target:IEventDispatcher = null) {
			super(target);
		}
		
		private var tokenReplace:TokenReplace = new TokenReplace();
		
		public function validate():Boolean {
			var caseSensitiveMatch:Boolean = caseSensitive;
			
			// todo: add contract validation here and throw error or warning if required fields aren't set
			
			// check if condition is met
			// CHECK PROPERTY ON TARGET
			if (property) {
				if (target && Object(target).hasOwnProperty(property)) {
					var targetValue:* = target[property];
					
    				// IS NOT BLANK
    				//  if they set the isNotBlank make sure it's not blank
    				if (isNotBlank && (targetValue!="" && targetValue!=null && targetValue!="null" && targetValue!="undefined")) {
    					if (debug) conditionReport = tokenReplace.replace("Target property must not be blank. The [target] value is blank. Condition met.", this);
    					return true;
    				}
    				else if (isNotBlank) {
    					if (debug) conditionReport = tokenReplace.replace("Target property must not be blank. The [target] value is not blank, '"+targetValue+"'.", this);
    					return false;
    				}
    				
    				// IS BLANK
    				// check if they set is blank parameter in the handler
    				if (isBlank && (targetValue=="" || targetValue==null || targetValue=="null" || targetValue=="undefined")) {
    					if (debug) conditionReport = tokenReplace.replace("Target property must be blank. The value of [target].[property] value is blank. Condition met. ", this);
    					return true;
    				}
    				else if (isBlank) {
    					if (debug) conditionReport = tokenReplace.replace("Target property must be blank. The value of [target].[property] is not blank, '"+targetValue+"'.", this);
    					return false;
    				}
    				
    				
    				// when comparing an object we can't check case sensitivity
    				if (value is Object) {
    					caseSensitiveMatch = true;
    				}
    				
    				// COMPARE TO VALUE
    				// compare parameter value to condition value
    				if (caseSensitiveMatch && targetValue == value) {
    					if (debug) conditionReport = tokenReplace.replace("Target property must equal value. The value of [target].[property] matches the value, '[value]'. Condition met.", this);
    					return true;
    				}
    				else if (!caseSensitiveMatch && targetValue.toLowerCase() == String(value).toLowerCase()) {
    					if (debug) conditionReport = tokenReplace.replace("Target property must equal value, case insensitive. The value of [target].[property] matches the value, '[value]'. Condition met.", this);
    					return true;
    				}
    				else {
    					if (debug) conditionReport = tokenReplace.replace("Target property must equal value. The value of [target].[property], '"+targetValue+"' does not match the value, '[value]'.", this);
    					return false;
    				}
					
				}
			}
			else {
				// set the "property" or "parameter" value in the condition you added to the handler 
				throw new Error("Property or parameter is not set in a Link Manager Handler Condition.");
			}
			
			
			return false;
		}

	}
	
}
