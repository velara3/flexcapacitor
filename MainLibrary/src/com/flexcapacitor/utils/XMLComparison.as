package com.flexcapacitor.utils
{
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.net.LocalConnection;
	import flash.utils.Timer;
	
	import mx.controls.TextInput;
	
	import spark.components.NumericStepper;

	public class XMLComparison
	{
		public function XMLComparison()
		{
		}
		
		private var commandconnection:LocalConnection;
		public var fileName:TextInput;
		public var watching:TextInput;
		public var interval:NumericStepper;
		
		private function init():void
		{
			commandconnection = new LocalConnection();
			commandconnection.allowDomain("*");
			commandconnection.addEventListener(StatusEvent.STATUS, statusHandler);
		}
		
		private function statusHandler(event:Event):void
		{
		}
		
		private function search():void
		{
			var mxmlFilter:FileFilter = new FileFilter("MXML", "*.mxml");
			var f:File = new File();
			f.browseForOpen("Choose MXML File", [ mxmlFilter ]);
			f.addEventListener(Event.SELECT, selectHandler);
		}
		
		private function selectHandler(event:Event):void
		{
			var mxmlFile:File;
			mxmlFile = event.target as File;
			fileName.text = mxmlFile.nativePath;
		}
		
		private function watch():void
		{
			var mxmlFile:File;
			mxmlFile = new File(fileName.text);
			watching.text = "Watching " + fileName.text;
			checkFile();
			startTimer();
		}
		
		private var checkTimer:Timer = new Timer(1);
		
		private function startTimer():void
		{
			checkTimer.delay = interval.value;
			checkTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			checkTimer.start();
		}
		
		private function timerHandler(event:Event):void
		{
			checkFile();
		}
		
		private function intervalChanged():void
		{
			checkTimer.stop();
			startTimer();
		}
		
		private var lastModifiedTime:Number = 0;
		
		private function checkFile():void
		{
			var mxmlFile:File;
			try {
				mxmlFile = new File(fileName.text);
				if (mxmlFile.modificationDate.time == lastModifiedTime)
					return;
			} catch (e:Error) {
				// might check while file is open to be written so just ignore
				// and check on the next interval;
				return;
			}
			
			parseFile();
			computeChanges();
			applyChanges();
		}
		
		private var filter:Object = {
			"http://ns.adobe.com/mxml/2009::Script": 1,
			"http://ns.adobe.com/mxml/2009::Declarations": 1,
			"http://ns.adobe.com/mxml/2009::Style": 1
		}
		
		private var supportedAttributes:Object = {
			width: NaN,
			height: NaN,
			x: 0,
			y: 0,
			label: "",
			style: "",
			text: ""                
		}
		
		private function getAttributeName(attrName:String):String
		{
			var cp:int = attrName.indexOf(".");
			if (cp > -1)
				attrName = attrName.substring(0, cp);
			return attrName;
		}
		
		private function parseFile():void
		{
			var fs:FileStream = new FileStream();
			var mxmlFile:File;
			mxmlFile = new File(fileName.text);
			fs.open(mxmlFile, FileMode.READ);
			var xml:XML = new XML(fs.readUTFBytes(fs.bytesAvailable));
			fs.close();
			newDB = {};
			generatedIDCounter = 0;
			parseChildren(newDB, xml);
		}
		
		private var generatedIDCounter:int = 0;
		
		// assume it is an instance if the tag name starts with a capital letter
		private function isInstance(tagName:String):Boolean
		{
			var cp:int = tagName.indexOf("::");
			if (cp > -1)
				tagName = tagName.substring(cp + 2);
			var c:String = tagName.charAt(0);
			return c >= "A" && c <= "Z";
		}
		
		private function parseChildren(newDB:Object, parent:XML):void
		{
			var children:XMLList = parent.children();
			var n:int = children.length();
			for (var i:int = 0; i < n; i++)
			{
				var child:XML = children[i];
				var childName:String = child.name();
				if (childName == null)
					continue; // saw this for CDATA children
				if (filter[childName])
					continue;
				// we go deep first because that's how the Falcon compiler
				// generates IDs for tags that don't have id attributes set.
				parseChildren(newDB, child);
				if (isInstance(childName))
				{
					var effectiveID:String =  (child.@id.length() == 0) ?
						"#" + generatedIDCounter++ :
						child.@id;
					var attrs:XMLList = child.attributes();
					var m:int = attrs.length();
					var attrMap:Object;
					newDB[effectiveID] = attrMap = {};
					for (var j:int = 0; j < m; j++)
					{
						var attrName:String = attrs[j].name();
						if (supportedAttributes.hasOwnProperty(getAttributeName(attrName)))
							attrMap[attrName] = child["@" + attrName].toString();
					}
				}
			}
		}
		
		private var newDB:Object;
		private var oldDB:Object;
		private var changes:Object;
		private var removals:Object;
		
		private function computeChanges():void
		{
			changes = {};
			removals = {};
			if (oldDB == null)
			{
				oldDB = newDB;
				return;
			}
			// assume set of components with ids and their ids won't change
			for (var p:String in newDB)
			{
				var newValues:Object = newDB[p];
				var oldValues:Object = oldDB[p];
				for (var q:String in newValues)
				{
					var newValue:Object = newValues[q];
					var oldValue:Object = oldValues[q];
					if (newValue != oldValue)
					{
						var changeList:Object = changes[p];
						if (!changeList)
							changeList = changes[p] = {};
						changeList[q] = newValue;
					}
				}
				// look for deletions and set value back to default value
				for (q in oldValues)
				{
					if (!newValues.hasOwnProperty(q))
					{
						var removeList:Object = removals[p];
						if (!removeList)
							removeList = removals[p] = {};
						var propName:String = q;
						if (q.indexOf(".") > -1)
						{
							var parts:Array = q.split(".");
							propName = parts[0];
						}
						removeList[q] = supportedAttributes[propName];
					}
				}
			}
			oldDB = newDB;
		}
		
		private function applyChanges():void
		{
			for (var p:String in changes)
			{
				var changedValues:Object = changes[p];
				for (var q:String in changedValues)
				{
					commandconnection.send("_MXMLLiveEditPluginCommands", "setValue", p, q, changedValues[q]);
				}
			}
			for (p in removals)
			{
				var removedValues:Object = removals[p];
				for (q in removedValues)
				{
					commandconnection.send("_MXMLLiveEditPluginCommands", "setValue", p, q, removedValues[q]);
				}
			}
		}
	}
}