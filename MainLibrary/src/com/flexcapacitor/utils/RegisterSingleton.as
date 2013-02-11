package com.flexcapacitor.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.IMXMLObject;
	import mx.core.Singleton;
	
	/**
	 * Dispatched when a singleton is registered
	 **/
	[Event(name="singletonRegistered", type="flash.events.Event")]
	
	/**
	 * Dispatched when a singleton is already registered
	 **/
	[Event(name="alreadyRegistered", type="flash.events.Event")]
	
	/**
	 * This class allows any class to become a singleton. It functions similarly to 
	 * how the mx.core.Singleton class works. With that class you register a class instance
	 * under a unique name and then later you can retrieve that same class instance by it's name.<br/><br/>  
	 * 
	 * In the mx.core.Singleton class approach you get an instance by calling the getInstance() method 
	 * in ActionScript. That means your singleton class has to add this method and call it wherever you 
	 * need to access it. This prevents it from being declared in MXML. <br/><br/>
	 * 
	 * This class allows you to declare your singleton in MXML and does not require your class to have a 
	 * getInstance() method or add an static instance variable.
	 * <br/><br/>
	 * 
	 * Overview of how to use:<br/>
	 * 1. Create instance of this class on MXML Application<br/>
	 * 2. Declare an instance of the class that you want to be a singleton on that MXML Application as well. <br/>
	 * 3. Set or bind the target singleton instance to the target property of this class.<br/>
	 * 4. Provide a name to the name property that can be used to retrieve the target singleton class later. Optional. <br/><br/>
	 * 
	 * Register a class with a name:<br/><br/>
	 * In MyApplication.mxml,<br/>
	<pre>
	&lt;fx:Declarations>
		&lt;utils:RegisterSingleton target="{myClass}" name="myCustomSingleton"/>
		&lt;managers:MySingleton id="myClass"/>
	&lt;/fx:Declarations>
	</pre>
	 * Registering your Application:<br/><br/>
	 * In MyApplication.mxml,<br/>
	<pre>
	&lt;fx:Declarations>
		&lt;utils:RegisterSingleton target="{this}"/>
	&lt;/fx:Declarations>
	</pre>
	 * Registering a class without a name:<br/><br/>
	 * In MyApplication.mxml,<br/>
	<pre>
	&lt;fx:Declarations>
		&lt;utils:RegisterSingleton target="{this}"/>
		&lt;managers:ApplicationManager id="manager"/>
	&lt;/fx:Declarations>
	</pre>
	 * 
	 * The example shows registering the current class, "this", as a singleton and the ApplicationManager class as a singleton.
	 * Neither specify a name but rather are stored by type. You can later retrieve that instance by it's type. 
	 * If specified a name then that instance will be stored under that name and it can be retrieved by that name. 
	 * 
	 * Next, you will want to retrive the singleton. You use the GetSingleton or SingletonEnforcer class in MXML 
	 * to set the local instance to the singleton instance:<br/><br/>
	 * 
	 * Overview of how to use:<br/>
	 * 1. Create instance of GetSingleton class in your MXML component.<br/>
	 * 2. Declare an instance of the target class (this can be a base class or interface).<br/><br/>
	 * 
	 * Retrieving a class by name:<br/><br/>
	 * In MyComponent.mxml,<br/>
	 * <pre>
	&lt;fx:Declarations>
		&lt;utils:GetSingleton name="myCustomSingleton" target="mySingleton" />
		&lt;managers:MySingleton id="mySingleton"/>
	&lt;/fx:Declarations>
		</pre>
	 * Retrieving a class by type:<br/><br/>
	 * In MyComponent.mxml,<br/>
	 * <pre>
	&lt;fx:Declarations>
		&lt;utils:GetSingleton name="{ApplicationManager}" target="manager" />
		&lt;managers:ApplicationManager id="manager"/>
	&lt;/fx:Declarations>
		</pre>
	 * Replacing a interface with an implementation by name:<br/><br/>
	 * In MyComponent.mxml,<br/>
	 * <pre>
	&lt;fx:Declarations>
		&lt;utils:GetSingleton name="myCustomSingleton" target="mySingleton" />
		&lt;managers:MySingletonBase id="mySingleton"/>
	&lt;/fx:Declarations>
		</pre>
		 * 
		 * In the last example in the code above the MySingletonBase is replaced by the actual class instance 
		 * that's been registered. This allows you to assign different implementations typically based on 
		 * different deployment targets. For example, if you have mobile application and a desktop application
		 * then you may want to register a class with mobile specific functionality in your mobile application 
		 * and register an class with desktop specific functionality. If MobileSingleton and DesktopSingleton 
		 * share a common base or interface then you declare the base or interface and the GetSingleton class 
		 * will get and set the base or interface to the class you registered in your desktop or 
		 * mobile application.<br/><br/>
		 * 
		 *  
	 * Sometimes you need to get an instance of a class in ActionScript. In that case you need to aad 
	 * a getInstance() method in your class. In that case the following code will mimic a typical getInstance()
	 * call. Add this to code to your class:<br/><br/>
	 * 
	 * <pre>
		public static function getInstance():ApplicationManager {
			return RegisterSingleton.getInstanceByType(ApplicationManager);
		}
		</pre> 
	 * 
	 * For the getInstance() call to work as usual you must have the class registered early on,
	 * for example, registered in the Application, or the value may return null.<br/>
	 * */
	public class RegisterSingleton extends EventDispatcher implements IMXMLObject {
		
		public static const SINGLETON_REGISTERED:String = "singletonRegistered";
		public static const ALREADY_REGISTERED:String = "alreadyRegistered";
		
		public static const ALREADY_REGISTERED_MESSAGE:String = "The singleton class has already been registered. Remove duplicate register calls.";
		
		/**
		 *  A map of fully-qualified interface names,
		 *  such as "mx.managers::IPopUpManager",
		 *  to singleton instances,
		 *  such as mx.managers.PopUpManagerImpl.
		 */
		[Bindable]
		public static var instanceMap:Object = {};
		
		/**
		 * Name of class to be registered under
		 **/
		public var name:String;
		
		/**
		 * If this is set to true then no errors are thrown if the same component type or name 
		 * is registered more than once. 
		 * This is a feature that attempts to support subapplications. Not thoroughly tested. 
		 **/
		public var ignoreMultipleRegisterAttempts:Boolean;
		
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
		public function RegisterSingleton() {
			var qualifiedClassName:String = flash.utils.getQualifiedClassName(this);
			var localInstance:Class = Singleton.getClass(qualifiedClassName);
			
			// register ourselves so get singleton instances can listen for events from us
			if (!localInstance) {
				_instance = this;
				Singleton.registerClass(qualifiedClassName, RegisterSingleton);
				//dispatchEvent(new Event(SINGLETON_REGISTERED));
			}
		}
		
		/**
		 * Instance of the RegisterSingleton class
		 **/
		public static function get instance():RegisterSingleton
		{
			if (!_instance) {
				var inst:RegisterSingleton = new RegisterSingleton();
			}
			
			return _instance;
		}

		/**
		 * Called when the document is initialized
		 **/
		public function initialized(document:Object, id:String):void {
			registerInstance();
			documentInitialized = true;
		}
		
		/**
		 * 
		 **/
		public function registerInstance():void {
			var itemInstance:* = instanceMap[name];
			var item:*;
			
			if (!target) {
				return;
			}
			
			if (name==null) {
				name = flash.utils.getQualifiedClassName(target);
				itemInstance = instanceMap[name];
			}
			
			if (!itemInstance) {
				
				if (target is String) {
					item = document[target];
				}
				else {
					item = target;
				}
				
				instanceMap[name] = item;
				dispatchEvent(new Event(SINGLETON_REGISTERED));
			}
			else {
				dispatchEvent(new Event(ALREADY_REGISTERED));
				
				if (!ignoreMultipleRegisterAttempts) {
					throw new Error(ALREADY_REGISTERED_MESSAGE);
				}
			}
			
		}
		
		/**
		 * 
		 **/
		private static var _instance:RegisterSingleton;
		
		/**
		 * 
		 **/
		private var _target:Object;
		
		/**
		 * Gets reference to the instance 
		 **/
		[Bindable]
		public function get target():Object {
			return _target;
		}
		
		/**
		 * Sets the reference to this instance 
		 **/
		public function set target(value:Object):void {
			var localInstance:*;
			_target = value;
			
			if (documentInitialized) { 
				registerInstance();
				// throw new Error("Class registered for interface '" + name + "'.");
			}
			
		}
		
		/**
		 * Gets the first created instance of this, the RegisterSingleton class.
		 **/
		public static function getInstance():RegisterSingleton {
			
			return instance;
		}
		
		/**
		 * Gets the instance by name or class name (if name was not specified)
		 **/
		public static function getInstanceByName(name:String):*
		{
			var item:* = instanceMap[name];
			return item;
		}
		
		/**
		 * Gets the instance by name or class name (if name was not specified)
		 **/
		public static function getInstanceByType(type:Class):*
		{
			var qualifiedClassName:String = flash.utils.getQualifiedClassName(type);
			
			var item:* = instanceMap[qualifiedClassName];
			return item;
		}
	}
}