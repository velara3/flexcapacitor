package com.flexcapacitor.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.IMXMLObject;
	
	
	/**
	 * The target was set. 
	 * NOTE: Event is not getting dispatched due possibly
	 * to event handlers not added in time. 
	 * */
	[Event(name="targetSet", type="flash.events.Event")]
	
	/**
	 * Gets an instance of a class. 
	 * */
	public class GetSingleton extends EventDispatcher implements IMXMLObject {
		
		public static const TARGET_SET:String = "targetSet";
		
		/**
		 * Document
		 **/
		public var document:Object;
		
		/**
		 * Document initialized
		 **/
		public var documentInitialized:Boolean;
		
		/**
		 * Constructor
		 **/
		public function GetSingleton() {
			RegisterSingleton.instance
			
			watcher2 = BindingUtils.bindSetter(targetChangedHandler, RegisterSingleton, "instanceMap");
		}

		/**
		 * Name and target must be set by this point
		 **/
		public function initialized(document:Object, id:String):void {
			this.document = document;
			updateInstance();
			documentInitialized = true;
			
			// if an object is delcared after this then we need to set it back to single instance
			if (target is String) {
				watcher = BindingUtils.bindSetter(targetChangedHandler, document, target);
			}
		}
		
		/**
		 * 
		 **/
		public function targetChangedHandler(value:*):void {
			updateInstance();
		}
		
		/**
		 * 
		 **/
		public function updateInstance():void
		{
			var itemInstance:* = getInstance();
			var item:*;
			
			// instance is not stored yet so we wait until it is and then bind 
			if (!itemInstance) {
				RegisterSingleton.instance.addEventListener(RegisterSingleton.SINGLETON_REGISTERED, updateSingletonHandler, false, 0, true);
				return;
			}
			
			if (!target) return;
			
			// Errors ////////////////////////////////////////////////////////////
			// TypeError: Error #1034: Type Coercion failed: cannot convert controller::ApplicationController$ to controller.ApplicationController.
			// 
			// Cause
			// <utils:RegisterSingleton target="{controller.ApplicationController}" name="applicationController" />
			// <controller:MobileManager id="manager"/>
			// 
			// Solution
			// <utils:RegisterSingleton target="{manager}" name="applicationController" />
			// <controller:MobileManager id="manager"/>
			// ///////////////////////////////////////////////////////////////////
			
			if (itemInstance) {
				if (_target is String && document) {
					document[_target] = itemInstance;
					dispatchEvent(new Event(TARGET_SET));
				}
				else if (_target) {
					_target = itemInstance;
					dispatchEvent(new Event(TARGET_SET));
				}
			}
			
				
		}
		
		/**
		 * 
		 **/
		public var watcher:Object;
		public var watcher2:Object;
		
		/**
		 * 
		 **/
		public function updateSingletonHandler(event:Event):void {
			updateInstance();
		}
		
		private var _instance:Object;
		
		/**
		 * Gets reference to the class 
		 **/
		public function get instance():Object {
			var item:* = getInstance();
			
			return item;
		}
		
		/**
		 * 
		 **/
		public function getInstance():Object {
			var item:*;
			
			if (name is String) {
				item = RegisterSingleton.getInstanceByName(String(name));
			}
			else if (name is Class) {
				item = RegisterSingleton.getInstanceByType(Class(name));
			}
			
			
			return item;
		}
		
		private var _name:Object;
		
		/**
		 * Name or type of class
		 * 
		 * Typical value is something like, "MyCustomClass" 
		 * or "{ApplicationSingletonClass}"
		 **/
		public function get name():Object 
		{
			return _name;
		}
		
		public function set name(value:Object):void 
		{
			if (_name == value) return;
			
			_name = value;
			
			if (documentInitialized && value) { 
				updateInstance();
				// throw new Error("Class registered for interface '" + name + "'.");
			}
		}
		
		private var _target:Object;
		
		/**
		 * 
		 **/
		public function get target():Object
		{
			return _target;
		}
		
		/**
		 * 
		 **/
		public function set target(value:Object):void
		{
			if (_target == value) return;
			
			_target = value;
			
			if (documentInitialized && value) { 
				updateInstance();
				// throw new Error("Class registered for interface '" + name + "'.");
			}
			
		}
	}
}