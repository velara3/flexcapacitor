

package com.flexcapacitor.effects.data.supportClasses {
	import com.flexcapacitor.effects.data.ConvertStringToXML;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.utils.XMLUtils;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	/**
	 *  @copy ConvertStringToXML
	 * */  
	public class ConvertStringToXMLInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function ConvertStringToXMLInstance(target:Object) {
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
			// Dispatch an effectStart event
			super.play();
			
			var action:ConvertStringToXML = ConvertStringToXML(effect);
			var propertyName:String = action.sourcePropertyName;
			var childName:String = action.getChildByName;
			var source:Object = action.source;
			var isValid:Boolean;
			var newXML:Object;
			var value:String;
			var xml:XML;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			if (validate) {
				if (source==null) {
					dispatchErrorEvent("The source is not set. It is null.");
				}
				
				if (propertyName!=null 
					&& !(propertyName in source)) {
					dispatchErrorEvent("The property " + propertyName + " is not in the source.");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			value = propertyName ? source[propertyName] : String(source);
			
			if (action.inspectXML) {
				trace(className + " unprocessed XML:\n", value);
			}
			
			isValid = XMLUtils.isValidXML(value);
			
			if (isValid) {
				xml = getXML(value);
				
				if (action.getFirstChild) {
					newXML = xml.child(0).length()>0 ? xml.child(0)[0] : xml.child(0);
				}
				else if (childName) {
					newXML = xml.child(childName).length()>0 ? xml.child(childName)[0] : xml.child(childName);
				}
				else {
					newXML = xml;
				}
				
			}
			else {
				if (hasEventListener(ConvertStringToXML.INVALID_VALUE)) {
					dispatchActionEvent(new Event(ConvertStringToXML.INVALID_VALUE));
				}
					
				if (action.invalidXMLEffect) {
					playEffect(action.invalidXMLEffect);
				}
				
				finish();
				return;
			}
			
			if (action.inspectXML) {
				trace(className + " processed XML:\n", newXML.toString());
			}
			
			action.data = newXML as XML;
			
			if (hasEventListener(ConvertStringToXML.VALID_VALUE)) {
				dispatchActionEvent(new Event(ConvertStringToXML.VALID_VALUE));
			}
			
			if (action.validXMLEffect) {
				playEffect(action.validXMLEffect);
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			finish();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function getXML(value:String):XML {
			
			try {
				// needs to be more robust use TLF HTML / Text Importer
				// to create valid XML before parsing?
				return new XML(value);
			}
			catch (error:ErrorEvent) {
				return null;
			}
			
			return null;
		}
	}
}