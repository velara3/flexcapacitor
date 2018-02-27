package com.flexcapacitor.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import mx.rpc.xml.SchemaTypeRegistry;
	
	/**
	 * Dispatched when the manifest has loaded
	 * */
	[Event(name="manifestLoaded", type="flash.events.Event")]
	
	/**
	 * Dispatched when a namepsace has been parsed
	 * */
	[Event(name="namespaceLoaded", type="flash.events.Event")]
	
	/**
	 * Dispatched when all namepsaces have been parsed
	 * */
	[Event(name="namespacesLoaded", type="flash.events.Event")]
	
	/**
	 * Dispatched when file is not found
	 * */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * Loads a list of classes from the Flex SDK flex-config.xml file and adds them
	 * to a SchemaTypeRegistry
	 * */
	public class ClassLoader extends EventDispatcher
	{
		public function ClassLoader(target:IEventDispatcher=null) {
			super(target);
			
			if (configPath!=null) {
				load();
			}
		}
		
		public const NAMESPACES:String = "namespaces";
		public const NAMESPACE:String = "namespace";
		public const COMPONENT:String = "component";
		
		static public const MANIFEST_LOADED:String = "manifestLoaded";
		public static const NAMESPACE_LOADED:String = "namespaceLoaded";
		static public const NAMESPACES_LOADED:String = "namespacesLoaded";
		public const CLASS:String = "class";
		
		public static var debug:Boolean;
		
		public var configPath:String;
		public var configFileName:String = "flex-config.xml";
		public var uri:String;
		public var subDirectory:String;
		public var urlLoader:URLLoader;
		public var lastNamespaceURI:String;
		public var totalNamespaces:int;
		
		public function load():void {
			var request:URLRequest;
			
			// load flex-config.xml
			// get namespace nodes
			// load each namespace.xml
			// register namespace
			// get list of components
			// register components
			
			classRegistry = ClassRegistry.getInstance();
			
			uri = configPath + configFileName;
			
			request = new URLRequest(uri);
			urlLoader = new URLLoader();
			urlLoader.load(request);
			urlLoader.addEventListener(Event.COMPLETE, flexConfigHandler, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
		}
		
		protected function flexConfigHandler(event:Event):void {
			var xml:XML;
			var namespaces:XMLList;
			var namespaceList:XMLList;
			var typeRegistry:SchemaTypeRegistry;
			var namespaceURI:String;
			var namespaceManifest:String;
			var urlRequest:URLRequest;
			var currentURLLoader:URLLoader;
			var result:String;
			var url:String;
			
			if (hasEventListener(MANIFEST_LOADED)) {
				var configLoaded:Event = new Event(MANIFEST_LOADED);
				dispatchEvent(configLoaded);
			}
			
			currentURLLoader = event.currentTarget as URLLoader;
			result = currentURLLoader.data;
			xml = new XML(result);
			namespaces = xml.descendants(NAMESPACES);
			namespaceList = namespaces.descendants(NAMESPACE);
			//schema.addImport(namespace, schemaTest);
			typeRegistry = SchemaTypeRegistry.getInstance();
			totalNamespaces = namespaceList.length();
			
			for each (var namespaceNode:XML in namespaceList) {
				namespaceURI = namespaceNode.uri;
				namespaceManifest = namespaceNode.manifest;
				url = configPath + namespaceManifest;
				urlRequest = new URLRequest(url);
				currentURLLoader = new URLLoader();
				currentURLLoader.load(urlRequest);
				currentURLLoader.addEventListener(Event.COMPLETE, manifestLoadingHandler, false, 0, true);
				currentURLLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
				urlLoaders[currentURLLoader] = namespaceURI;
				
				if (debug) trace("Loading:" + namespaceURI);
			}
		}
		
		public var urlLoaders:Dictionary = new Dictionary(true);
		
		private var classRegistry:ClassRegistry;
		public var componentsList:XMLList;
		public var componentsArray:Array;
		
		protected function manifestLoadingHandler(event:Event):void {
			var namespaceURI:String;
			var componentName:String;
			var componentClass:String;
			var urlLoader:URLLoader;
			var namespaceLoaded:Event;
			var componentQName:QName;
			var result:String;
			var xml:XML;
			
			
			urlLoader = event.currentTarget as URLLoader;
			namespaceURI = urlLoaders[urlLoader];
			lastNamespaceURI = namespaceURI;
			result = urlLoader.data;
			xml = new XML(result);
			componentsList = xml.descendants(COMPONENT);
			componentsArray = [];
			
			if (debug) trace("Loaded:" + namespaceURI);
			
			if (classRegistry==null) {
				classRegistry = ClassRegistry.getInstance();
			}
			
			
			for each (var component:XML in componentsList) {
				componentName = component.@id;
				componentClass = component.attribute(CLASS);
				componentQName = new QName(namespaceURI, componentName);
				classRegistry.registerClass(componentQName, componentClass);
				componentsArray.push(componentQName);
				if (debug) trace(" Registering:" + componentClass);
			}
			
			if (hasEventListener(NAMESPACE_LOADED)) {
				namespaceLoaded = new Event(NAMESPACE_LOADED);
				dispatchEvent(namespaceLoaded);
			}
			
			urlLoaders[urlLoader] = null;
			delete urlLoaders[urlLoader];
			urlLoader.removeEventListener(Event.COMPLETE, manifestLoadingHandler);
			
			totalNamespaces--;
			
			if (totalNamespaces==0) {
				if (debug) trace("All files have loaded.");
				
				if (hasEventListener(NAMESPACES_LOADED)) {
					var namespacesLoaded:Event = new Event(NAMESPACES_LOADED);
					dispatchEvent(namespacesLoaded);
				}
			}
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void {
			if (debug) trace("file not found\n" + event.toString());
			totalNamespaces--;
			
			if (hasEventListener(IOErrorEvent.IO_ERROR)) {
				dispatchEvent(event);
			}
		}
	}
}