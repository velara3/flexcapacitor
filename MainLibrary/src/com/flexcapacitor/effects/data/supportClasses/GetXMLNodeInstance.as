

package com.flexcapacitor.effects.data.supportClasses {
	import com.flexcapacitor.effects.data.GetXMLNode;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.utils.ClassUtils;
	
	/**
	 * @copy GetXMLNode
	 * */  
	public class GetXMLNodeInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function GetXMLNodeInstance(target:Object) {
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
			
			var action:GetXMLNode = GetXMLNode(effect);
			var propertyName:String = action.sourcePropertyName;
			var childNamed:String = action.getChildByName;
			var childrenNamed:String = action.getChildrenByName;
			var source:Object = action.source;
			var verifiedXML:XML;
			var newXML:Object;
			var xml:XML;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			if (validate) {
				if (source==null) {
					dispatchErrorEvent("The source is not set.");
				}
				
				if (propertyName!=null 
					&& !(propertyName in source)) {
					dispatchErrorEvent("The property " + propertyName + " is not in the source.");
				}
				
				if (propertyName==null 
					&& !(source is XML)
					&& !(source is String)) {
					dispatchErrorEvent("The source is not XML or XML String.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			if (source is String) {
				try {
					verifiedXML = new XML(source);
				}
				catch (error:Error) {
					dispatchErrorEvent("The source is not XML or XML String.");
				}
			}
			else {
				verifiedXML = XML(source);
			}
			
			xml = propertyName ? XML(source[propertyName]) : verifiedXML;
			
			if (action.ignoreRoot) {
				xml = xml.child(0).length()>0 ? xml.child(0)[0] : xml.child(0);
			}
			
			if (action.inspectXML) {
				trace(className + " unprocessed XML(" + ClassUtils.getClassName(xml) + "):\n", xml);
			}
			
			if (action.getFirstChild) {
				newXML = xml.child(0).length()>0 ? xml.child(0)[0] : xml.child(0);
			}
			else if (action.getFirstNodeChildren) {
				newXML = xml.children();
			}
			else if (childNamed) {
				newXML = xml.child(childNamed).length()>0 ? xml.child(childNamed)[0] : xml.child(childNamed);
			}
			else if (childrenNamed) {
				newXML = xml.descendants(childrenNamed);
			}
			else {
				newXML = xml;
			}
			
			if (action.inspectXML) {
				traceMessage("Processed XML(" + ClassUtils.getClassName(newXML) + "):\n" + newXML.toString());
			}
			
			action.data = newXML; // as XML;
			
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
		
		
	}
}