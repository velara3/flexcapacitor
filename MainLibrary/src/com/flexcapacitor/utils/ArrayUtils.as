
package com.flexcapacitor.utils {
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
	/**
	 * Utils for working with Arrays
	 * */
	public class ArrayUtils {
		
		public function ArrayUtils() {
			
		}
		
		/**
		 * Returns true if an item is found
		 * */
		public static function hasItem(haystack:*, property:String, needle:String, caseSensitive:Boolean = true):Object {
			var value:Object = find(haystack, property, needle, caseSensitive);
			return value!=null;
		}
		
		/**
		 * Finds a item by a value by comparing to the value in a property on the item in the array
<pre>
	var person1:Object = new Object();
	person1.name = "John";
	var person2:Object = new Object();
	person2.name = "Linda";
	var people:Array = [person1, person2];
	var person:Person = ArrayUtils.find(people, "name", "john", false);
	trace(person); // john
	
	var peopleArrayList:ArrayList = new ArrayList([person1, person2]);
	var person:Person = ArrayUtils.find(peopleArrayList, "name", "john", false);
	trace(person); // john
	
	var peopleArrayCollection:ArrayCollection = new ArrayCollection([person1, person2]);
	var person:Person = ArrayUtils.find(peopleArrayCollection, "name", "linda", false);
	trace(person); // linda
	
	var peopleArrayCollection:ArrayCollection = new ArrayCollection([person1, person2]);
	var person:Person = ArrayUtils.find(peopleArrayCollection, "name", "bill", false);
	trace(person); // null
</pre>
		 * */
		public static function find(haystack:*, property:String, needle:*, caseSensitive:Boolean = true, findAll:Boolean = false):Object {
			var needleLowerCase:* = !caseSensitive && needle is String ? needle.toLowerCase() : needle;
			var total:int = haystack.length;
			var sourceArray:Array;
			var value:Object;
			var item:Object;
			var all:Array = [];
			
			if (haystack is ArrayCollection || haystack is ArrayList) {
				sourceArray = haystack.source;
			}
			else {
				sourceArray = haystack;
			}
			
			for (var i:int;i<total;i++) {
				
				if (property==null) {
					value = sourceArray[i];
				}
				else {
					value = sourceArray[i][property];
				}
				
				if (caseSensitive) {
					if (value==needle) {
						item = sourceArray[i];
						if (findAll) {
							all.push(item);
							continue;
						}
						else {
							break;
						}
					}
				}
				else {
					if (value==needleLowerCase || 
						(value!=null && value.toString().toLowerCase()==needleLowerCase)) {
						item = sourceArray[i];
						if (findAll) {
							all.push(item);
							continue;
						}
						else {
							break;
						}
					}
				}
			}
			
			if (findAll) {
				return all;
			}
			else {
				return item;
			}
		}
		
		/**
		 * Removes an item from an array, array list or array collection
		 * */
		public static function remove(haystack:*, item:Object, findAll:Boolean = false):void {
			var total:int = haystack.length;
			var sourceArray:Array;
			var value:Object;
			var item:Object;
			var all:Array = [];
			
			if (haystack is ArrayCollection || haystack is ArrayList) {
				sourceArray = haystack.source;
			}
			else {
				sourceArray = haystack;
			}
			
			
			for (var i:int;i<total;i++) {
				value = sourceArray[i];
				
				if (value==item) {
					if (findAll) {
						sourceArray.splice(i,1);
						i = i-1;
						total = total-1;
						if (total==0) break;
						continue;
					}
					else {
						sourceArray.splice(i,1);
					}
				}
			}
		}
	}
}