

package com.flexcapacitor.effects.handlers {
	
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	import com.flexcapacitor.handlers.EventHandler;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Binds a view component to a reference on the static controller defined in 
	 * EventHandler.staticController or eventHandler.controller<br/><br/>
	 * 
	 * @copy EventHandler
	 * */
	public class RegisterComponent extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 */
		public function RegisterComponent(target:Object = null) {
			super(target);
			
			target = null;
			
			duration = 0;
			
			instanceClass = RegisterComponentInstance;
			
		}
		
		/**
		 * If true the target component is a static member
		 * */
		public var isTargetStatic:Boolean;
		
		/**
		 * Errors if the component was already set
		 * */
		public var errorIfRegistered:Boolean;
		
		private var _targetPropertyName:String;
		
		[Bindable]
		/**
		 * Name of property on controller
		 * */
		public function get targetPropertyName():String {
			return _targetPropertyName;
		}
		
		/**
		 * @private
		 */
		public function set targetPropertyName(value:String):void {
			_targetPropertyName = value;
			
			if (value && _source) {
				registerComponent();
			}
		}
		
		private var _source:Object;
		
		/**
		 * Reference to the source object to be set in the controller
		 * */
		[Bindable]
		public function set source(value:Object):void {
			_source = value;
			
			if (value && _targetPropertyName) {
				registerComponent();
			}
		}
		
		public function get source():Object {
			return _source;
		}
		
		public function registerComponent():void {
			var staticController:Object = EventHandler.staticController;
			var isTargetStatic:Boolean = isTargetStatic;
			var ClassReference:Class;
			
			if (!isTargetStatic) {
				
				if (!(targetPropertyName in staticController)) {
					//dispatchErrorEvent("The static controller does not have the property '" + targetPropertyName + "'");
				}
				
				if (errorIfRegistered && staticController[targetPropertyName]) {
					//dispatchErrorEvent("The property '" + targetPropertyName + "' is already set");
				}
				
				staticController[targetPropertyName] = source;
				
				
			}
			else {
				// property is static
				ClassReference = getClass(staticController);
				
				
				// check if it's on the class
				if (!(targetPropertyName in ClassReference)) {
					//dispatchErrorEvent("The static controller does not have the static property '" + targetPropertyName + "'");
				}
				
				// check if target has already been set
				if (errorIfRegistered && ClassReference[targetPropertyName]) {
					//dispatchErrorEvent("The static property " + targetPropertyName + " is already set");
				}
				
				// set target
				ClassReference[targetPropertyName] = source;
			}
		}
		
		/**
		 * Gets a reference to the class given an object. 
		 * This may be faster than the getDefinitionByName by name method. Need to test...
		 * 
		 * Notes:
		 * XML objects (XML, XMLList) are an exception to object.constructor (ie. (new XML() as Object).constructor as Class == null). 
		 * It's recommended to fall back to getDefinitionByName(getQualifiedClassName) when the constructor does not resolve:
		 * Note that getDefinitionByName will throw an error if the class is defined in a different  
		 * application domain from the calling code.
		 * */
		public function getClass(object : Object) : Class {
			var klass : Class = (object as Class) || (object.constructor as Class);
			
			if (klass == null) {
				klass = getDefinitionByName(getQualifiedClassName(object)) as Class;
			}
			
			return klass;
		}
	}
	
}


import com.flexcapacitor.effects.handlers.RegisterComponent;
import com.flexcapacitor.effects.supportClasses.ActionEffect;
import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
import com.flexcapacitor.handlers.EventHandler;

import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

/**
 * @copy RegisterComponent
 * */  
internal class RegisterComponentInstance extends ActionEffectInstance {
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor.
	 * 
	 * */
	public function RegisterComponentInstance(target:Object) {
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
		
		var action:RegisterComponent = RegisterComponent(effect);
		var targetPropertyName:String = action.targetPropertyName;
		var isTargetStatic:Boolean = action.isTargetStatic;
		var errorIfRegistered:Boolean = action.errorIfRegistered;
		var staticController:Object = EventHandler.staticController;
		var source:Object = action.source;
		var ClassReference:Class;
		
		
		///////////////////////////////////////////////////////////
		// Verify we have everything we need before going forward
		///////////////////////////////////////////////////////////
		
		if (validate) {
			
			// if the target is null it may not have been created yet. 
			if (staticController==null) {
				dispatchErrorEvent("The static controller is not set");
			}
			
			// if the source is null it may not have been created yet
			if (source==null) {
				dispatchErrorEvent("The source is not set");
			}
			
			// if the targetPropertyName cannot be null
			if (targetPropertyName==null) {
				dispatchErrorEvent("The targetPropertyName is not set");
			}
			
		}
		
		
		///////////////////////////////////////////////////////////
		// Continue with action
		///////////////////////////////////////////////////////////
		
		
		// check if property is static
		if (!isTargetStatic) {
			
			if (!(targetPropertyName in staticController)) {
				dispatchErrorEvent("The static controller does not have the property '" + targetPropertyName + "'");
			}
			
			if (errorIfRegistered && staticController[targetPropertyName]) {
				dispatchErrorEvent("The property '" + targetPropertyName + "' is already set");
			}
			
			staticController[targetPropertyName] = source;
			
			
		}
		else {
			// property is static
			ClassReference = getClass(staticController);
			
			
			// check if it's on the class
			if (!(targetPropertyName in ClassReference)) {
				dispatchErrorEvent("The static controller does not have the static property '" + targetPropertyName + "'");
			}
			
			// check if target has already been set
			if (errorIfRegistered && ClassReference[targetPropertyName]) {
				dispatchErrorEvent("The static property " + targetPropertyName + " is already set");
			}
			
			// set target
			ClassReference[targetPropertyName] = source;
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
	//  Utility methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Gets a reference to the class given an object. 
	 * This may be faster than the getDefinitionByName by name method. Need to test...
	 * 
	 * Notes:
	 * XML objects (XML, XMLList) are an exception to object.constructor (ie. (new XML() as Object).constructor as Class == null). 
	 * It's recommended to fall back to getDefinitionByName(getQualifiedClassName) when the constructor does not resolve:
	 * Note that getDefinitionByName will throw an error if the class is defined in a different  
	 * application domain from the calling code.
	 * */
	public function getClass(object : Object) : Class {
		var klass : Class = (object as Class) || (object.constructor as Class);
		
		if (klass == null) {
			klass = getDefinitionByName(getQualifiedClassName(object)) as Class;
		}
		
		return klass;
	}
	
	
}