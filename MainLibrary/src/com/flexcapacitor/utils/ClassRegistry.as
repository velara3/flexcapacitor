package com.flexcapacitor.utils
{
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.rpc.xml.Schema;

	/**
	 * Manages classes and namespaces in an XML document
	 * 
	 * Merges SchemaTypeRegistry.xml.rpc.mx
	 * Merges SchemaManager
	 * We merged SchemaManager because the compiler was not stepping through the class correctly
	 * */
	public class ClassRegistry {
		
		public function ClassRegistry(domain:ApplicationDomain = null, defaultNamespace:QName = null) {
			
			if (domain) {
				this.domain = domain;
			}
			
			initialScope = [];
			schemaStack = [];
			initialScope.push(<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" 
					   targetNamespace="library://ns.adobe.com/flex/spark"
					   xmlns="library://ns.adobe.com/flex/spark"
					   elementFormDefault="qualified"/>);
			this.defaultNamespace = defaultNamespace;
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

		/**
		 * Adds multiple namespaces in an object. The object contains 
		 * a list of keys that are the prefix for the namespace instance
		 * 
		 * For example, 
<pre>
// add as object with namespaces
var object:Object = {};
object.s = new Namespace("s", "library://ns.adobe.com/flex/spark");
classRegistry.addNamespaces(object);

// add as xml
classRegistry.addNamespaces(xml);

// add as array
classRegistry.addNamespaces(xml.namespaceDeclarations());
</pre>
		 * 
		 * @see #namespaces
		 * @see #addNamespace()
		 * */
		public function addNamespaces(map:Object):void {
			var ns:Namespace;
			var numberOfNamespaces:int;
			
			if (map is XML) {
				map = XML(map).namespaceDeclarations();
			}
			
			if (map is Array) {
				numberOfNamespaces = map.length;
				for (var i:int; i < numberOfNamespaces; i++) {
					ns = map[i];
					addNamespace(ns);
				}
			}
			else {
				for (var prefix:String in map) {
					ns = map[prefix] as Namespace;
					addNamespace(ns);
				}
			}
		}
		
		/**
		 * Adds a namespace to the registered namespaces dictionary
		 * For example, you can register "new Namespace("s", "library://ns.adobe.com/flex/spark");"
		 * 
		 * Existing values will be overwritten. 
		 * 
		 * @see #namespaces
		 * @see #addNamespaces()
		 * @see #getNamespaceByPrefix()
		 * @see #getNamespaceByURI()
		 * */
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
		 * Gets the namespace by prefix. If you pass in "s" and you have a namespace
		 * registered with the prefix "s" then it returns that namespace instance
		 * or null if not found.
		 * 
		 * @see #getNamespaceByURI()
		 * @see #getPrefixForNamespace()
		 * */
		public function getNamespaceByPrefix(prefix:String):Namespace {
			var ns:Namespace;
			
			if (namespaces[prefix]!=null) {
				ns = namespaces[prefix];
			}
			
			return ns;
		}
		
		/**
		 * Gets the namespace by URI. If you pass in "library://ns.adobe.com/flex/spark" 
		 * and you have a namespace with a matching URI then it returns that namespace instance
		 * or null if not found.
		 * 
		 * @see #getNamespaceByPrefix()
		 * @see #getPrefixForNamespace()
		 * */
		public function getNamespaceByURI(uri:String):Namespace {
			
			for each (var ns:Namespace in _namespaces) {
				if (ns.uri==uri) {
					return ns;
				}
			}
			
			return null;
		}
		
		/**
		 * Get prefix for URI or null if not found
		 * 
		 * @see #getNamespaceByPrefix()
		 * @see #getNamespaceByURI()
		 * */
		public function getPrefixForURI(uri:String):String {
			var ns:Namespace = getNamespaceByURI(uri);
			
			if (ns!=null) {
				return ns.prefix;
			}
			
			return null;
		}
		
		/**
		 * Clears the registered namespaces
		 * */
		public function clearNamespaces():void {
			namespaces = {};
		}
		
		/**
		 * Resolves a prefixed name back into a QName based on the prefix to
		 * namespace mappings.
		 * 
		 * For example, if you pass in "s:Button" it returns "new QName("library://ns.adobe.com/flex/spark", "Button")"
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
		public function getQNameForPrefixedName(prefixedName:String, 
												parent:XML=null, 
												qualifyToTargetNamespace:Boolean=false):QName {
			var qname:QName;
			
			// Separate into prefix and local name
			var prefix:String;
			var localName:String;
			var prefixIndex:int = prefixedName.indexOf(":");
			
			if (prefixIndex > 0) {
				prefix = prefixedName.substr(0, prefixIndex);
				localName = prefixedName.substr(prefixIndex + 1);
			}
			else {
				localName = prefixedName;
			}
			
			var ns:Namespace;
			
			// First, map unqualified names to the target namespace, if the flag
			// is explicitly set. (Used when looking up unqualified names by "ref")
			if (prefix == null && qualifyToTargetNamespace == true && currentSchema) {
				ns = currentSchema.targetNamespace;
			}
			
			// Otherwise, assume that unqualified names are in the default namespace.
			if (prefix == null) {
				prefix = "";
			}
			
			// First, check if a parent XML has a local definition for this
			// namespace...
			if (ns == null) {
				
				if (parent != null) {
					var localNamespaces:Array = parent.inScopeNamespaces();
					
					for each (var localNS:Namespace in localNamespaces) {
						
						if (localNS.prefix == prefix) {
							ns = localNS;
							break;
						}
					}
				}
			}
			
			// Next, check top level namespaces
			if (ns == null) {
				ns = namespaces[prefix];
			}
			
			// Next, check current schema namespaces
			if (ns == null && currentSchema) {
				ns = currentSchema.namespaces[prefix];
			}
			
			if (ns == null) {
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
			
			if (ns != null) {
				qname = new QName(ns.uri, localName);
			}
			else {
				qname = new QName("", localName);
			}
			
			return qname;
		}
		
		/**
		 * Gets the qname for the type. 
		 * If you pass a Spark Button or "spark.controls.Button" it returns 
		 * new QName("s", "library://ns.adobe.com/flex/spark").
		 * 
		 * @param type Type can be an class or a string
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
		 * */
		public function getQNameForType(object:Object, qualifyToTargetNamespace:Boolean=false):QName {
			var qualifiedClassName:String;
			var qname:QName;
			var key:String;
			
			qualifiedClassName = getQualifiedClassName(object);
			
			key = definitionNameMap[qualifiedClassName];
			qname = getQNameFromKey(key);
			
			return qname;
		}
		
		/**
		 * Returns a prefixed name from an object or a string. 
		 * 
		 * If you pass a Spark Button it returns s:Button.
		 * 
		 * @param type Type can be an class or a string
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
		 * */
		public function getPrefixedNameForType(object:Object, parent:XML = null, qualifyToTargetNamespace:Boolean=false):String {
			var qualifiedClassName:String;
			var qname:QName;
			var prefixedName:String;
			var key:String;
			var ns:Namespace;
			var localNamespaces:Array;
			
			qualifiedClassName = getQualifiedClassName(object);
			
			key = definitionNameMap[qualifiedClassName];
			
			// First, map unqualified names to the target namespace, if the flag
			// is explicitly set. (Used when looking up unqualified names by "ref")
			if (key == null && qualifyToTargetNamespace == true && currentSchema) {
				ns = currentSchema.targetNamespace;
			}
			
			if (ns) {
				key = getKey(new QName(ns.uri, key));
				key = definitionNameMap[qualifiedClassName];
			}
			
			// First, check if a parent XML has a local definition for this
			// namespace...
			if (ns == null) {
				
				if (parent != null) {
					localNamespaces = parent.inScopeNamespaces();
					
					for each (var localNS:Namespace in localNamespaces) {
						break; // not implemented
						//if (localNS.prefix == prefix) {
							ns = localNS;
							break;
						//}
					}
				}
			}
			
			if (key) {
				prefixedName = getPrefixedNameFromKey(key);
			}
			
			return prefixedName;
		}
		
		/**
		 * Returns a class name from an object or a string. 
		 * 
		 * If you pass a Spark Button or "spark.controls.Button" it returns Button.
		 * 
		 * @param type Type can be an class or a string
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
		 * */
		public function getClassNameForType(object:Object, qualifyToTargetNamespace:Boolean=false):String {
			var qualifiedClassName:String;
			var qname:QName;
			var className:String;
			var key:String;
			
			qualifiedClassName = getQualifiedClassName(object);
			
			key = definitionNameMap[qualifiedClassName];
			className = getClassNameFromKey(key);
			
			return className;
		}
		
		/**
		 * Get a qname from a key. That is it returns the prefix and the namespace URI as a QName.
		 * 
		 * If key is "library://ns.adobe.com/flex/spark::spark.controls.Button"
		 * and "library://ns.adobe.com/flex/spark" is registered with the "s" namespace prefix
		 * then the QName returned is new QName("s", "library://ns.adobe.com/flex/spark"). 
		 * */
		public function getQNameFromKey(key:String):QName {
			var qname:QName;
			
			// Separate into prefix and local name
			var prefix:String;
			var uri:String;
			var uriIndex:int = key.lastIndexOf("::");
			var qualifiedClassName:String;
			
			if (uriIndex > 0) {
				uri = key.substr(0, uriIndex);
			}
			else {
				qualifiedClassName = key;
			}
			
			if (uri) {
				prefix = getPrefixForURI(uri);
			}
			
			qname = new QName(prefix, uri);
			
			return qname;
		}
		
		/**
		 * Get the prefix from a key. 
		 * 
		 * If key is "library://ns.adobe.com/flex/spark::spark.controls.Button"
		 * and "library://ns.adobe.com/flex/spark" is registered with the "s" namespace prefix
		 * then the value returned is "s:Button". 
		 * 
		 * @see #addNamespace()
		 * @see #addNamespaces()
		 * */
		public function getPrefixedNameFromKey(key:String):String {
			var qname:QName;
			
			// Separate into prefix and local name
			var prefix:String;
			var uri:String;
			var localName:String;
			var uriIndex:int = key.lastIndexOf("::");// could also use "::"
			
			if (uriIndex > 0) {
				uri = key.substr(0, uriIndex);
				localName = key.substr(uriIndex + 2);
			} else {
				localName = key;
			}
			
			if (uri) {
				prefix = getPrefixForURI(uri);
				
				if (prefix!=null) {
					return prefix + ":" + localName;
				}
			}
			
			return null;
		}
		
		/**
		 * Get the class name from a key. 
		 * 
		 * If key is "library://ns.adobe.com/flex/spark::spark.controls.Button"
		 * then the value returned is "Button". 
		 * */
		public function getClassNameFromKey(key:String):String {
			var localName:String;
			var uriIndex:int = key.lastIndexOf("::");
			
			if (uriIndex > 0) {
				localName = key.substr(uriIndex + 2);
			} else {
				localName = key;
			}
			
			return localName;
		}
		
		/**
		 * Get an array of all class names with prefixes. 
		 * 
		 * Returns ["s:Button", "s:Label", "s:List"];
		 * */
		public function getPrefixedClassNames(sort:Boolean = true):Array {
			var classNames:Array;
			var prefixedName:String;
			
			classNames = [];
			
			for (var key:String in classMap) {
				prefixedName = getPrefixedNameFromKey(key);
				
				if (prefixedName!=null) {
					classNames.push(prefixedName);
				}
			}
			
			if (sort) {
				//classNames.sortOn("value", [Array.CASEINSENSITIVE]);
				classNames.sort(Array.CASEINSENSITIVE);
			}
			
			return classNames;
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
		 * 
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
			var classe:Class;
			var key:String;
			var qname:QName;
			var definitionName:String;
			
			if (type != null) {
				if (type is String && uri!=null) {
					type = new QName(uri, type);
				}
				
				key = getKey(type);
				definitionName = classMap[key] as String;
				
				if (definitionName != null && domain.hasDefinition(definitionName)) {
					// classe = getDefinitionByName(definitionName) as Class;
					classe = domain.getDefinition(definitionName) as Class;
				}
			}
			
			return classe;
		}
		
		/**
		 * Get qualified class name from QName
		 **/
		public function getClassName(qname:QName, uri:String = null):String {
			var key:String;
			var definitionName:String;
			
			if (qname != null) {
				if (uri!=null) {
					qname = new QName(uri, qname.localName);
				}
				
				key = getKey(qname);
				definitionName = classMap[key] as String;
				
			}
			
			return definitionName;
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
		public function getCollectionClass(type:Object):Class {
			var classe:Class;
			
			if (type != null) {
				var key:String = getKey(type);
				var definitionName:String = collectionMap[key] as String;
				
				if (definitionName != null) {
					classe = getDefinitionByName(definitionName) as Class;
				}
			}
			
			return classe;
		}
		
		/**
		 * Maps a type QName to a Class definition. The definition can be a String
		 * representation of the fully qualified class name or an instance of the
		 * Class itself.
		 * 
<pre>
namespaceURI = "library://ns.adobe.com/flex/spark";
component = <component id="Button" class="spark.components.Button"/>
componentClass = component.attribute("class");
componentQName = new QName(namespaceURI, componentName);
classRegistry.registerClass(componentQName, componentClass);
</pre>
		 * @param type The QName or String representation of the type name.
		 * @param definition The Class itself or class name as a String.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function registerClass(type:Object, definition:Object):void {
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
		 * Converts the given type name into a consistent String representation
		 * that serves as the key to the type map.
		 * 
		 * @param type The QName or String representation of the type name.
		 */
		protected function getKey(type:Object):String {
			var key:String;
			
			if (type is QName) {
				var typeQName:QName = type as QName;
				
				if (typeQName.uri == null || typeQName.uri == "") {
					key = typeQName.localName;
				}
				else {
					key = typeQName.toString();
				}
			}
			else {
				key = type.toString();
			}
			
			return key;
		}
		
		/**
		 * @private
		 */
		private function register(type:Object, definition:Object, map:Object):void
		{
			var key:String;
			var definitionName:String;
			
			key = getKey(type);
			
			if (definition is String) {
				definitionName = definition as String;
			}
			else {
				definitionName = getQualifiedClassName(definition);
			}
			
			map[key] = definitionName;
			
			definitionNameMap[definitionName] = key;
		}
		
		//--------------------------------------------------------------------------
		//
		// Variables
		// 
		//--------------------------------------------------------------------------
		
		private var definitionNameMap:Object = {};
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
		
		public var defaultNamespace:QName;

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