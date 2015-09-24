package com.flexcapacitor.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.IMXMLObject;
	
	
	/**
	 * The target was set to a singleton instance. 
	 * NOTE: Event may not be dispatched due possibly
	 * to event handlers not added in time? 
	 * */
	[Event(name="singletonInitialized", type="flash.events.Event")]
	
	/**
	 * A singleton has been registered but no instance was registered 
	 * with a matching type or name. If this event dispatches 
	 * <i>after</i> the singleton is registered then the name
	 * or type in either the RegisterSingleton or the GetSingleton
	 * are incorrect.
	 * */
	[Event(name="singletonRegistered", type="flash.events.Event")]
	
	/**
	 * Gets the first instance declared of a class type. Used as a Singleton enforcer 
	 * for MXML declaration. You must register the class as a singleton first. 
	 * See the RegisterSingleton class. 
	 * 
	 * First Register the class in your Application:
<pre>
	&lt;utils:RegisterSingleton target="{manager}" name="{MobileManager}" />
	&lt;controller:MobileManager id="manager"/>
</pre>
	 * 
	 * Next get the instance in your components: 
<pre>
	&lt;utils:GetSingleton target="{manager}" name="{MobileManager}" />
	&lt;controller:MobileManager id="manager"/>
</pre>
	 * Get a class instance by a name you specified: 
<pre>
	&lt;!-- in your application -->
	&lt;utils:RegisterSingleton target="{manager}" name="myController" />
	&lt;controller:MobileManager id="manager"/>

	&lt;!-- in your component -->
	&lt;utils:GetSingleton target="{manager}" name="myController" />
	&lt;controller:MobileManager id="manager"/>
</pre>We use every opportunity to set the instance to it's singleton instance.
	 * */
	public class GetSingleton extends EventDispatcher implements IMXMLObject {
		
		/**
		 * Constructor
		 **/
		public function GetSingleton() {
			RegisterSingleton.instance.addEventListener(RegisterSingleton.SINGLETON_REGISTERED, updateSingletonHandler, false, 0, true);
				
			registrationWatcher = BindingUtils.bindSetter(targetChangedHandler, RegisterSingleton, "instanceMap");
		}
		
		public static const SINGLETON_INITIALIZED:String = "singletonInitialized";
		public static const SINGLETON_REGISTERED:String = "singletonRegistered";
		
		/**
		 * Binding Watcher for the target object
		 **/
		public var targetChangeWatcher:Object;
		public var registrationWatcher:Object;
		
		/**
		 * Indicates if the singleton is found
		 * */
		[Bindable]
		public var singletonFound:Boolean;
		
		/**
		 * Document
		 **/
		public var document:Object;
		
		/**
		 * Document initialized
		 **/
		public var documentInitialized:Boolean;

		/**
		 * Name and target must be set by this point
		 **/
		public function initialized(document:Object, id:String):void {
			if (singletonFound) return;
			this.document = document;
			updateInstance();
			documentInitialized = true;
			
			// if an object is declared after this then we need to set it back to single instance
			if (target is String) {
				targetChangeWatcher = BindingUtils.bindSetter(targetChangedHandler, document, target);
			}
		}
		
		/**
		 * Target has changed via bindings
		 **/
		public function targetChangedHandler(value:*):void {
			updateInstance();
		}
		
		/**
		 * Updates the local instance to the registered singleton instance.
		 **/
		public function updateInstance():void {
			if (singletonFound) return;
			var itemInstance:* = getInstance();
			var item:*;
			
			// instance is not stored yet so we wait until it is and then bind 
			if (!itemInstance) {
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
					singletonFound = true;
					document[_target] = itemInstance;
					cleanUpListeners();
				}
				else if (_target) {
					// this should work but doesn't seem to be
					// i've seen this before. we may need to assign it via id
					//_target = itemInstance;
					
					if (targetID==null) {
						var id:String = discoverID();
						targetID = id;
					}
					
					if (targetID && document) {
						singletonFound = true;
						document[id] = itemInstance;
						cleanUpListeners();
					}
					
				}
			}
		}
		
		/**
		 * Singleton found. Dispatch event and remove listeners
		 * */
		public function cleanUpListeners():void {
			dispatchEvent(new Event(SINGLETON_INITIALIZED));
			RegisterSingleton.instance.removeEventListener(RegisterSingleton.SINGLETON_REGISTERED, updateSingletonHandler);
			// should remove bindings?? 
		}
		
		/**
		 * Function to find the ID of the instance.
		 * If the class instance is not a IMXMLObject it won't have an ID property
		 * that we need to get or set it on the document.
		 * */
		public function discoverID():String {
			if (document && _target && targetID==null) {
				/*for each (var property:String in document) {
					if (document[property]==_target) {
						//targetID = property;
						return property;
					}
				}
				
				for (property in document) {
					if (document[property]==_target) {
						//targetID = property;
						return property;
					}
				}*/
				
				var list:XMLList = ClassUtils.getMemberDataByType(document, _target) as XMLList;
				
				if (list && list.length()) {
					//targetID = list.@name;
					return list.@name;
				}
			}
			
			return null;
		}
		
		/**
		 * When a new singleton is registered we check if it matches our targets name or class
		 **/
		public function updateSingletonHandler(event:Event):void {
			dispatchEvent(new Event(SINGLETON_REGISTERED));
			updateInstance();
		}
		
		private var _instance:Object;
		
		/**
		 * Gets a reference to the singleton class this class enforced
		 **/
		public function get instance():Object {
			var item:* = getInstance();
			
			return item;
		}
		
		/**
		 * Gets the registered instance of the class by a specified name or it's class type
		 * Returns null if an instance is not found
		 **/
		public function getInstance():Object {
			var item:*;
			
			if (name==null && target) {
				_name = getQualifiedClassName(target);
			}
			
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
		public function get name():Object {
			return _name;
		}
		
		public function set name(value:Object):void {
			if (_name == value) return;
			
			_name = value;
			
			if (documentInitialized && value) { 
				updateInstance();
				// throw new Error("Class registered for interface '" + name + "'.");
			}
		}
		
		private var _target:Object;
		
		/**
		 * ID of the target. 
		 * You can set this manually or the original target will used set this. 
		 * */
		public var targetID:String;
		
		/**
		 * Target can be an ID or a binding to the instance.
		 **/
		public function get target():Object {
			return _target;
		}
		
		/**
		 * 
		 **/
		public function set target(value:Object):void {
			if (_target == value) return;
			
			_target = value;
			
			if (documentInitialized && value) { 
				updateInstance();
				// throw new Error("Class registered for interface '" + name + "'.");
			}
		}
	}
}