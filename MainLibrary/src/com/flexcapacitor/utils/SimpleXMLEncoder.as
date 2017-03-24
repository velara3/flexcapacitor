
////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

package com.flexcapacitor.utils
{
	
	import flash.utils.Dictionary;
	
	import mx.utils.NameUtil;
	import mx.utils.ObjectUtil;
	
	/**
	 * The SimpleXMLEncoder class takes ActionScript Objects and encodes them to XML
	 * using default serialization. Updated to e4x. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class SimpleXMLEncoder {
		
		/**
		 *  Constructor.
		 *
		 *  @param myXML The XML object.
		 */
		public function SimpleXMLEncoder(myXML:XML = null)
		{
			super();
			
			this.myXMLDoc = myXML ? myXML : new XML();
		}
		
		public static var classRegistry:ClassRegistry;
		
		private static const NUMBER_TYPE:uint   = 0;
		private static const STRING_TYPE:uint   = 1;
		private static const OBJECT_TYPE:uint   = 2;
		private static const DATE_TYPE:uint     = 3;
		private static const BOOLEAN_TYPE:uint  = 4;
		private static const XML_TYPE:uint      = 5;
		private static const ARRAY_TYPE:uint    = 6;  // An array with a wrapper element
		private static const MAP_TYPE:uint      = 7;
		private static const ANY_TYPE:uint      = 8;
		// We don't appear to use this type anywhere, commenting out
		//private static const COLL_TYPE:uint     = 10; // A collection (no wrapper element, just maxOccurs)
		private static const ROWSET_TYPE:uint   = 11;
		private static const QBEAN_TYPE:uint    = 12; // CF QueryBean
		private static const DOC_TYPE:uint      = 13;
		private static const SCHEMA_TYPE:uint   = 14;
		private static const FUNCTION_TYPE:uint = 15; // We currently do not serialize properties of type function
		private static const ELEMENT_TYPE:uint  = 16;
		private static const BASE64_BINARY_TYPE:uint = 17;
		private static const HEX_BINARY_TYPE:uint = 18;
		
		/**
		 * @private
		 */
		private static const CLASS_INFO_OPTIONS:Object = {includeReadOnly:false, includeTransient:false};
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		public static var defaultNamespace:String = "library://ns.adobe.com/flex/spark";
		
		private var myXMLDoc:XML;
		
		public var encodePrimitivesAsAttributes:Boolean = false;
		public var skipNaNValues:Boolean = true;
		public var skipEmptyArrays:Boolean = true;
		
		public var namespaceDefinitions:Dictionary = new Dictionary(true);
		
		public var encodeColorFunction:Function;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Encodes an ActionScript object to XML using default serialization.
		 *  
		 *  @param obj The ActionScript object to encode.
		 *  
		 *  @param qname The qualified name of the child node.
		 *  
		 *  @param parentNode An XML under which to put the encoded
		 *  value.
		 *
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 *
		 *  @return The XML object. 
		 */
		public function encodeValue(object:Object, qname:QName = null, parentNode:XML = null, depth:int = 100, skipProperties:Array = null):XML {
			var myElement:XML;
			var nodeName:String;
			var isColorPossibly:Boolean;
			var childIndex:int;
			var typeType:uint;
			var qualifiedClassName:QName;
			
			if (depth < 0) {
				return null;
			}
			
			if (object == null) {
				return null;
			}
			
			if (object is Number && isNaN(Number(object)) && skipNaNValues) {
				return null;
			}
			
			if (object is Array && (object as Array).length==0 && skipEmptyArrays) {
				return null;
			}
			
			// Skip properties that are functions
			typeType = getDataTypeFromObject(object);
			
			if (typeType == SimpleXMLEncoder.FUNCTION_TYPE) {
				return null;
			}
			
			if (typeType == SimpleXMLEncoder.XML_TYPE) {
				myElement = XML(object).copy();
				parentNode.appendChild(myElement);
				return myElement;
			}
			
			if (parentNode==null) {
				parentNode = new XML(<foo/>);
			}
			
			myElement = new XML(<foo/>);
			
			if (qname) {
				nodeName = qname.localName;
			}
			else if ("className" in object && object.className) {
				nodeName = object.className;
			}
			else {
				nodeName = NameUtil.getUnqualifiedClassName(object);
			}
			
			if (nodeName && nodeName.indexOf("::")!=-1) {
				nodeName = nodeName.replace("::", ".");
			}
			
			if (classRegistry==null) {
				classRegistry = ClassRegistry.getInstance();
			}
			
			if (qname==null) {
				qualifiedClassName = classRegistry.getQNameForType(object);
				var namespaceForType:Namespace = classRegistry.getNamespaceForType(object);
				//prefixedName = classRegistry.getQNameForType(object);
				if (qualifiedClassName!=null) {
					qname = qualifiedClassName;
					//nodeName = qname.localName;
				}
			}
			
			
			myElement.setName(nodeName);
			
			if (skipProperties!=null && skipProperties.length) {
				if (skipProperties.indexOf(nodeName)!=-1) {
					if (encodePrimitivesAsAttributes) {
						
						if (parentNode && myElement.childIndex()!=-1) {
							delete parentNode[myElement.localName()][myElement.childIndex()];
							childIndex = myElement.childIndex();
							delete parentNode[myElement.name()][myElement.childIndex()];
							childIndex = myElement.childIndex();
						}
					}
					return null;
				}
			}
			
			
			if (qname && qname.uri) {
				//myElement.setNamespace(qname.uri);
				myElement.setNamespace(qname);
			}
			else {
				myElement.setNamespace(defaultNamespace);
			}
			
			if (nodeName.indexOf("color")!=-1) {
				isColorPossibly = true;
			}
			
			if (encodePrimitivesAsAttributes && 
				(typeType == SimpleXMLEncoder.OBJECT_TYPE ||
				typeType == SimpleXMLEncoder.ARRAY_TYPE)) {
				
				parentNode.appendChild(myElement);
				childIndex = myElement.childIndex();
			}
			
			if (typeType == SimpleXMLEncoder.OBJECT_TYPE)
			{
				var classInfo:Object = ObjectUtil.getClassInfo(object, null, CLASS_INFO_OPTIONS);
				var properties:Array = classInfo.properties;
				var pCount:uint = properties.length;
				
				for (var p:uint = 0; p < pCount; p++)
				{
					var fieldName:String = properties[p];
					var propQName:QName = new QName("", fieldName);
					encodeValue(object[fieldName], propQName, myElement, depth-1, skipProperties);
				}
			}
			else if (typeType == SimpleXMLEncoder.ARRAY_TYPE)
			{
				var numMembers:uint = object.length;
				//var itemQName:QName = new QName("", "item");
				var itemQName:QName; // let it be named after it's kind
				
				for (var i:uint = 0; i < numMembers; i++)
				{
					encodeValue(object[i], itemQName, myElement, depth-1, skipProperties);
				}
			}
			else
			{
				// Simple types fall through to here
				var valueString:String;
				
				if (typeType == SimpleXMLEncoder.DATE_TYPE)
				{
					valueString = encodeDate(object as Date, "dateTime");
				}
				else if (typeType == SimpleXMLEncoder.NUMBER_TYPE)
				{
					if (object == Number.POSITIVE_INFINITY)
						valueString = "INF";
					else if (object == Number.NEGATIVE_INFINITY)
						valueString = "-INF";
					else
					{
						var rep:String = object.toString();
						// see if its hex
						var start:String = rep.substr(0, 2);
						if (start == "0X" || start == "0x")
						{
							if (isColorPossibly && encodeColorFunction!=null) {
								valueString = encodeColorFunction(rep);
							}
							else {
								valueString = parseInt(rep).toString();
							}
						}
						else
						{
							if (isColorPossibly && encodeColorFunction!=null) {
								valueString = encodeColorFunction(rep);
							}
							else {
								valueString = rep;
							}
						}
					}
				}
				else
				{
					valueString = object.toString();
				}
				
				if (valueString!==null && valueString!=="") {
					
					if (encodePrimitivesAsAttributes) {
						parentNode.@[nodeName] = valueString;
						//parentNode.@[nodeName] = valueString;
						if (parentNode && myElement.childIndex()!=-1) {
							delete parentNode[myElement.localName()][myElement.childIndex()];
							childIndex = myElement.childIndex();
							delete parentNode[myElement.name()][myElement.childIndex()];
							childIndex = myElement.childIndex();
						}
					}
					else {
						//var valueNode:XML = myXMLDoc.createTextNode(valueString);
						//var valueNode:XML = new XML(valueString);
						myElement.appendChild(valueString);
					}
				}
			}
			
			return myElement;
		}
		
		/**
		 *  @private
		 */
		private function getDataTypeFromObject(obj:Object):uint
		{
			if (obj is Number)
				return SimpleXMLEncoder.NUMBER_TYPE;
			else if (obj is Boolean)
				return SimpleXMLEncoder.BOOLEAN_TYPE;
			else if (obj is String)
				return SimpleXMLEncoder.STRING_TYPE;
			else if (obj is XML)
				return SimpleXMLEncoder.XML_TYPE;
			else if (obj is Date)
				return SimpleXMLEncoder.DATE_TYPE;
			else if (obj is Array)
				return SimpleXMLEncoder.ARRAY_TYPE;
			else if (obj is Function)
				return SimpleXMLEncoder.FUNCTION_TYPE;
			else if (obj is Object)
				return SimpleXMLEncoder.OBJECT_TYPE;
			else
				// Otherwise force it to string
				return SimpleXMLEncoder.STRING_TYPE;
		}
		
		/**
		 * @private
		 */
		static internal function encodeDate(rawDate:Date, dateType:String):String
		{
			var s:String = new String();
			var n:Number;
			
			if (dateType == "dateTime" || dateType == "date")
			{
				s = s.concat(rawDate.getUTCFullYear(), "-");
				
				n = rawDate.getUTCMonth()+1;
				if (n < 10) s = s.concat("0");
				s = s.concat(n, "-");
				
				n = rawDate.getUTCDate();
				if (n < 10) s = s.concat("0");
				s = s.concat(n);
			}
			
			if (dateType == "dateTime")
			{
				s = s.concat("T");
			}
			
			if (dateType == "dateTime" || dateType == "time")
			{
				n = rawDate.getUTCHours();
				if (n < 10) s = s.concat("0");
				s = s.concat(n, ":");
				
				n = rawDate.getUTCMinutes();
				if (n < 10) s = s.concat("0");
				s = s.concat(n, ":");
				
				n = rawDate.getUTCSeconds();
				if (n < 10) s = s.concat("0");
				s = s.concat(n, ".");
				
				n = rawDate.getUTCMilliseconds();
				if (n < 10) s = s.concat("00");
				else if (n < 100) s = s.concat("0");
				s = s.concat(n);
			}
			
			s = s.concat("Z");
			
			return s;
		}
	}
	
}

