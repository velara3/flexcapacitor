package com.flexcapacitor.utils
{
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.rpc.xml.Schema;
	import mx.rpc.xml.SchemaTypeRegistry;

	/**
	 * Takes a XML document and registers the classes under their namespace URI
	 * Merges SchemaTypeRegistry.xml.rpc.mx
	 * Merges SchemaManager
	 * We merge because the compiler was not stepping through the class correctly
	 * */
	public class ClassRegistry {
		
		public function ClassRegistry(domain:ApplicationDomain = null) {
			
			if (domain) {
				this.domain = domain;
			}
			initialScope = [];
			schemaStack = [];
		}
		
		private static var _instance:ClassRegistry;
		/**
		 * Returns the sole instance of this singleton class, creating it if it
		 * does not already exist.
		 *
		 * @return Returns the sole instance of this singleton class, creating it
		 * if it does not already exist.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function getInstance():ClassRegistry
		{
			if (_instance == null)
				_instance = new ClassRegistry();
			
			return _instance;
		}
		
		private var _namespaces:Object;
		public function get namespaces():Object {
			if (_namespaces == null)
				_namespaces = {};
			
			return _namespaces;
		}
		
		public function set namespaces(value:Object):void {
			_namespaces = value;
		}

		
		public function addNamespaces(map:Object):void {
			
			for (var prefix:String in map) {
				var ns:Namespace = map[prefix] as Namespace;
				namespaces[prefix] = ns;
			}
		}
		
		public function addNamespace(ns:Namespace):void {
			var prefix:String = ns.prefix;
			var uri:String = ns.uri;
			var oldNamespace:Namespace;
			
			if (namespaces[prefix]==null) {
				namespaces[prefix] = ns;
			}
			else {
				oldNamespace = namespaces[prefix];
				if (oldNamespace.uri!=ns.uri) {
					namespaces[prefix] = ns;
				}
			}
		}
		
		/**
		 * Resolves a prefixed name back into a QName based on the prefix to
		 * namespace mappings.
		 * 
		 * @param prefixedName The name to be resolved. Can be prefixed or unqualified.
		 * @param parent The XML node where prefixedName appears. Allows local xmlns
		 * declarations to be examined
		 * @param qualifyToTargetNamespace A switch controlling the behavior for
		 * unqualified names. If false, unqualified names are assumed to be prefixed
		 * by "" and a xmlns="..." declaration is looked up. If no xmlns=".."
		 * declaration is in scope, and the parent node is in the default namespace,
		 * the prefixedName is resolved to the default namespace. Otherwise, it is
		 * resolved to the targetNamespace of the current schema. If qualifyToTargetNamespace
		 * is true, unqualified names are assumed to be in the target namespace of
		 * the current schema, regardless of declarations for unprefixed namespaces.
		 * qualifyToTargetNamespace should be true when resolving names coming from
		 * the following schema attributes: name, ref.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */ 
		public function getQNameForPrefixedName(prefixedName:String, parent:XML=null,
												qualifyToTargetNamespace:Boolean=false):QName
		{
			var qname:QName;
			
			// Separate into prefix and local name
			var prefix:String;
			var localName:String;
			var prefixIndex:int = prefixedName.indexOf(":");
			if (prefixIndex > 0)
			{
				prefix = prefixedName.substr(0, prefixIndex);
				localName = prefixedName.substr(prefixIndex + 1);
			}
			else
			{
				localName = prefixedName;
			}
			
			var ns:Namespace;
			
			// First, map unqualified names to the target namespace, if the flag
			// is explicitly set. (Used when looking up unqualified names by "ref")
			if (prefix == null && qualifyToTargetNamespace == true && currentSchema)
			{
				ns = currentSchema.targetNamespace;
			}
			
			// Otherwise, assume that unqualified names are in the default namespace.
			if (prefix == null)
			{
				prefix = "";
			}
			
			// First, check if a parent XML has a local definition for this
			// namespace...
			if (ns == null)
			{
				if (parent != null)
				{
					var localNamespaces:Array = parent.inScopeNamespaces();
					for each (var localNS:Namespace in localNamespaces)
					{
						if (localNS.prefix == prefix)
						{
							ns = localNS;
							break;
						}
					}
				}
			}
			
			// Next, check top level namespaces
			if (ns == null)
			{
				ns = namespaces[prefix];
			}
			
			// Next, check current schema namespaces
			if (ns == null && currentSchema)
			{
				ns = currentSchema.namespaces[prefix];
			}
			
			if (ns == null)
			{
				// Check if parent XML node is in the default namespace
				var parentNS:Namespace = (parent != null) ? parent.namespace() : null;
				if (parentNS != null && parentNS.prefix == "") {
					ns = parentNS;
				}
				else if (currentSchema) {
					// Otherwise we use the target namespace of the current definition
					ns = currentSchema.targetNamespace;
				}
			}
			
			if (ns != null)
				qname = new QName(ns.uri, localName);
			else
				qname = new QName("", localName);
			
			return qname;
		}
		
		/**
		 * Returns the Schema that was last used to retrieve a definition.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get currentSchema():Schema
		{
			var schema:Schema;
			
			var schemaSet:Array = currentScope();
			if (schemaSet.hasOwnProperty("current"))
				schema = schemaSet["current"];
			
			return schema;
		}
		
		public function currentScope():Array
		{
			var current:Array = schemaStack.pop();
			if (current != null)
				schemaStack.push(current);
			else
				current = [];
			return current;
		}
		
		//--------------------------------------------------------------------------
		//
		// Methods
		// 
		//--------------------------------------------------------------------------
		
		/**
		 * Looks for a registered Class for the given type.
		 * @param type The QName or String representing the type name.
		 * @return Returns the Class for the given type, or null of the type
		 * has not been registered.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function getClass(type:Object, uri:String = null):Class {
			var c:Class;
			var key:String;
			var qname:QName;
			var definitionName:String;
			
			if (type != null) {
				if (key is String && uri!=null) {
					qname = new QName(uri, key);
				}
				
				key = getKey(type);
				definitionName = classMap[key] as String;
				
				if (definitionName != null && domain.hasDefinition(definitionName))
					// c = getDefinitionByName(definitionName) as Class;
					c = domain.getDefinition(definitionName) as Class;
			}
			return c;
		}
		
		/**
		 * Returns the Class for the collection type represented by the given
		 * Qname or String.
		 *
		 * @param type The QName or String representing the collection type name.
		 *
		 * @return Returns the Class for the collection type represented by 
		 * the given Qname or String.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function getCollectionClass(type:Object):Class
		{
			var c:Class;
			if (type != null)
			{
				var key:String = getKey(type);
				var definitionName:String = collectionMap[key] as String;
				
				if (definitionName != null)
					c = getDefinitionByName(definitionName) as Class;
			}
			return c;
		}
		
		/**
		 * Maps a type QName to a Class definition. The definition can be a String
		 * representation of the fully qualified class name or an instance of the
		 * Class itself.
		 * @param type The QName or String representation of the type name.
		 * @param definition The Class itself or class name as a String.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function registerClass(type:Object, definition:Object):void
		{
			register(type, definition, classMap);
		}
		
		/**
		 * Adds a namespace with the URI and prefix
		 */
		public function registerPrefix(uri:String, prefix:String):void
		{
			addNamespace(new Namespace(uri, prefix));
		}
		
		/**
		 * Maps a type name to a collection Class. A collection is either the 
		 * top level Array type, or an implementation of <code>mx.collections.IList</code>. 
		 * The definition can be a String representation of the fully qualified
		 * class name or an instance of the Class itself.
		 *
		 * @param type The QName or String representation of the type name.
		 *
		 * @param definition The Class itself or class name as a String.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function registerCollectionClass(type:Object, definition:Object):void
		{
			register(type, definition, collectionMap);
		}
		
		/**
		 * Removes a Class from the registry for the given type.
		 * @param type The QName or String representation of the type name.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function unregisterClass(type:Object):void
		{
			if (type != null)
			{
				var key:String = getKey(type);
				delete classMap[key];
			}
		}
		
		/**
		 * Removes a collection Class from the registry for the given type.
		 * @param type The QName or String representation of the collection type
		 * name.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function unregisterCollectionClass(type:Object):void
		{
			if (type != null)
			{
				var key:String = getKey(type);
				delete collectionMap[key];
			}
		}
		
		/**
		 * @private
		 * Converts the given type name into a consistent String representation
		 * that serves as the key to the type map.
		 * @param type The QName or String representation of the type name.
		 */
		private function getKey(type:Object):String
		{
			var key:String;
			if (type is QName)
			{
				var typeQName:QName = type as QName;
				if (typeQName.uri == null || typeQName.uri == "")
					key = typeQName.localName;
				else
					key = typeQName.toString();
			}
			else
			{
				key = type.toString();
			}
			return key;
		}
		
		/**
		 * @private
		 */
		private function register(type:Object, definition:Object, map:Object):void
		{
			var key:String = getKey(type);
			var definitionName:String;
			if (definition is String)
				definitionName = definition as String;
			else
				definitionName = getQualifiedClassName(definition);
			
			map[key] = definitionName;
		}
		
		//--------------------------------------------------------------------------
		//
		// Variables
		// 
		//--------------------------------------------------------------------------
		
		private var prefixMap:Object = {};
		private var classMap:Object = {};
		private var collectionMap:Object = {};
		
		/**
		 * A Stack of Schemas which records the current scope and the last Schema
		 * that was accessed to locate a definition. Multiple Schemas may be
		 * placed in Scope at any level by adding them to the Stack as an Array.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private var schemaStack:Array;
		private var initialScope:Array;
		private var _domain:ApplicationDomain;

		public function get domain():ApplicationDomain
		{
			if (_domain==null) {
				_domain = ApplicationDomain.currentDomain;
			}
			return _domain;
		}

		public function set domain(value:ApplicationDomain):void
		{
			_domain = value;
		}

	}
}