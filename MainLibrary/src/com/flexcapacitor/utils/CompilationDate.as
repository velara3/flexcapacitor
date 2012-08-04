



 
package com.flexcapacitor.utils {
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.core.FlexGlobals;
	import mx.core.FlexVersion;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.utils.StringUtil;
	
	[Event(name="creationComplete", type="flash.events.Event")]

	/**
	* Direct reading of SWF file to gather the SWF Compile information
	* 
	* Distributed under the new BSD License
	* @author Paul Sivtsov - ad@ad.by
	* @author Igor Costa
	* 
	* http://www.igorcosta.org/?p=220
	* 
	* Updated for use as an MXML tag, source of data binding for compile date, current date and version
	* 
	* 
	**/
	public class CompilationDate extends EventDispatcher {
		
		public static const DAY:int = 86400000;
		public static const HOUR:int = 3600000;
		public static const MINUTE:int = 60000;
		public static const SECOND:int = 1000;
		public static const ONE_HUNDREDTH:int = 100;
		public static const TEN_HUNDREDTH:int = 10;
		public static const MILLISECOND:int = 1;
		
		public static const CREATION_COMPLETE:String = "creationComplete";
		
		// date SWF was compiled
		[Bindable]
		public var compilationDate:Date = new Date();
		
		// date SWF was compiled last
		// this date is set to the same compilation date when it is run the client the first time
		[Bindable]
		public var previousCompiliationDate:Date = new Date();
		
		// current date
		[Bindable]
		public var currentDate:Date = new Date();
		
		// difference in milliseconds from last compile
		// only works when the application has been previously visited on your computer
		[Bindable]
		public var timeDifference:Number = 0;
		
		// difference from last compile formatted with days, hrs, mins, secs and optionally milliseconds
		// only difference when the application has been previously visited on your computer
		[Bindable]
		public var timeDifferenceFormatted:String = "";
		
		// difference from last compile formatted with milliseconds included
		// only difference when the application has been previously visited on your computer
		[Bindable]
		public var timeDifferenceMilliseconds:Boolean = false;
		
		// difference last compile array 'days','hrs','mins','secs','ms'
		// only works when the application has been previously visited on your computer
		[Bindable]
		public var timeDifferenceArray:Array = ["days","hrs","mins","secs","ms"];
		
		// difference in days from last compile 
		// only works when the application has been previously visited on your computer
		[Bindable]
		public var daysDifference:String = "0";
		
		// difference in hours from last compile
		// only works when the application has been previously visited on your computer
		[Bindable]
		public var hoursDifference:String = "0";
		
		// difference in minutes from last compile
		// only works when the application has been previously visited on your computer
		[Bindable]
		public var minutesDifference:String = "0";
		
		// difference in seconds from last compile
		// only works when the application has been previously visited on your computer
		[Bindable]
		public var secondsDifference:String = "0";
		
		// difference in milliseconds from last compile
		// only works when the application has been previously visited on your computer
		[Bindable]
		public var millisecondsDifference:String = "0";
		
		// year compiled
		[Bindable]
		public var year:String = "";
		
		// current year
		[Bindable]
		public var currentYear:String = "";
		
		// previous compile year
		[Bindable]
		public var previousCompileYear:String = "";
		
		// month name
		[Bindable]
		public var monthName:String = "";
		
		// current month name
		[Bindable]
		public var currentMonthName:String = "";
		
		// previous compile month name
		[Bindable]
		public var previousCompileMonthName:String = "";
		
		// month names
		[Bindable]
		public var monthNames:Array = ["January","February","March","April","May","June","July","August","September","October","November","December"];
		
		// month number
		[Bindable]
		public var monthNumber:String = "";
		
		// current month number
		[Bindable]
		public var currentMonthNumber:String = "";
		
		// previous compile month number
		[Bindable]
		public var previousCompileMonthNumber:String = "";
		
		// month index
		[Bindable]
		public var monthIndex:String = "";
		
		// current month index
		[Bindable]
		public var currentMonthIndex:String = "";
		
		// previous compile month index
		[Bindable]
		public var previousCompileMonthIndex:String = "";
		
		// day name
		[Bindable]
		public var dayName:String = "";
		
		// current day name
		[Bindable]
		public var currentDayName:String = "";
		
		// previous compile day name
		[Bindable]
		public var previousCompileDayName:String = "";
		
		// day name
		[Bindable]
		public var dayNames:Array = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
		
		// day number index
		[Bindable]
		public var dayIndex:String = "";
		
		// current day number index
		[Bindable]
		public var currentDayIndex:String = "";
		
		// previous compile day number index
		[Bindable]
		public var previousCompileDayIndex:String = "";
		
		// day of month number
		[Bindable]
		public var dayNumber:String = "";
		
		// current day of the month number
		[Bindable]
		public var currentDayNumber:String = "";
		
		// previous compile day of the month number
		[Bindable]
		public var previousCompileDayNumber:String = "";
		
		// hour
		[Bindable]
		public var hour:String = "";
		
		// previous compile hour
		[Bindable]
		public var previousCompileHour:String = "";
		
		// minute
		[Bindable]
		public var minute:String = "";
		
		// previous compile minute
		[Bindable]
		public var previousCompileMinute:String = "";
		
		// seconds
		[Bindable]
		public var seconds:String = "";
		
		// previous compile seconds
		[Bindable]
		public var previousCompileSeconds:String = "";
		
		// milliseconds
		[Bindable]
		public var milliseconds:String = "";
		
		// previous compile milliseconds
		[Bindable]
		public var previousCompileMilliseconds:String = "";
		
		// AM or PM
		[Bindable]
		public var ampm:String = "";
		
		// AM or PM
		[Bindable]
		public var previousCompileAmpm:String = "";
		
		// AM or PM array 
		[Bindable]
		public var ampmNames:Array = ["AM","PM"];
		
		// hour notation
		[Inspectable(type="String", enumeration="12,24", defaultValue="12")]
		[Bindable]
		public var hourNotation:String = "12";
		
		// flag that indicates the swf has changed since last time you viewed it in the browser
		[Bindable]
		public var changed:Boolean = false;
		
		// flag that indicates the swf has changed since last time you viewed it in the browser
		[Bindable]
		public var cached:Boolean = false;
		
		// track changes in a shared object
		// allows you to know if and how long ago changes were made 
		[Bindable]
		public var trackChanges:Boolean = true;
		
		// local version number unique to the computer the application is run on 
		[Bindable]
		public var version:String = "";
		
		// serial number
		[Bindable]
		public var serialNumber:ByteArray = new ByteArray();
		
		// reference to reload button
		[Bindable]
		public var reloadButton:* = new UIComponent();
		
		// Change me to force recompile / dirty the editor
		[Bindable]
		public var changeThisValue:String = "";
		
		private var isFlex3:Boolean = FlexVersion.compatibilityVersionString=="3.0.0";
		
		public var application:Object;
		
		public var enabled:Boolean = true;
		
		public function CompilationDate() {
			
			application = FlexGlobals.topLevelApplication;
			application.addEventListener(FlexEvent.APPLICATION_COMPLETE, applicationComplete, false, 0, true);
		}
		
		///////////////////////////////////////////////////////////////////////////
		// Set the compilation date variable after SWF is loaded
		///////////////////////////////////////////////////////////////////////////
		private function applicationComplete(event:FlexEvent):void {
			
			// remove listener
			application.removeEventListener(FlexEvent.APPLICATION_COMPLETE, applicationComplete);
			
			if (!enabled) return;
			var leadingZeros:LeadingZeros = new LeadingZeros();
			
			// get compilation date
			compilationDate = readCompilationDate();
			
			year = String(compilationDate.fullYear);
			monthName = String(monthNames[compilationDate.month]);
			monthNumber = String(compilationDate.month+1);
			monthIndex = String(compilationDate.month);
			dayName = String(dayNames[compilationDate.day]);
			dayIndex = String(compilationDate.day);
			dayNumber = String(compilationDate.date);
			hour = (hourNotation=="12") ? (compilationDate.hours==0) ? "12" : (compilationDate.hours<=11) ? String(compilationDate.hours) : String(compilationDate.hours - 12) : String(compilationDate.hours);
			hour = (hourNotation=="12" && hour=="0") ? "12" : hour;
			minute = String(LeadingZeros.padNumber(compilationDate.minutes, 2));
			seconds = String(LeadingZeros.padNumber(compilationDate.seconds, 2));
			milliseconds = String(LeadingZeros.padNumber(compilationDate.milliseconds, 3));
			ampm = (compilationDate.hours<12) ? ampmNames[0] : ampmNames[1];
			
			// get current date and time
			currentYear = String(currentDate.fullYear);
			currentMonthName = String(monthNames[currentDate.month]);
			currentMonthNumber = String(currentDate.month+1);
			currentMonthIndex = String(currentDate.month);
			currentDayName = String(dayNames[currentDate.day]);
			currentDayIndex = String(currentDate.day);
			currentDayNumber = String(currentDate.date);
			
			var sharedObjectName:String = application.className.toString() + "_CompilationDate";
			var sharedObject:SharedObject = SharedObject.getLocal(sharedObjectName);
			var localVersion:int = int(version);
			
			// previous changes found
			if (sharedObject.size!=0) {
				// get last saved compilation date
				previousCompiliationDate = new Date(sharedObject.data.compilationDate);
				// get last version number
				localVersion = sharedObject.data.version;
				// get time difference
				timeDifference = compilationDate.time - previousCompiliationDate.time;
				
				if (timeDifference>0) {
					changed = true;
					localVersion++;
				}
				else {
					cached = true;
				}
			}
			
			if (changed) {
				// get previous compile date and fill in properties
				previousCompileYear = String(previousCompiliationDate.fullYear);
				previousCompileMonthName = String(monthNames[previousCompiliationDate.month]);
				previousCompileMonthNumber = String(previousCompiliationDate.month+1);
				previousCompileMonthIndex = String(previousCompiliationDate.month);
				previousCompileDayName = String(dayNames[previousCompiliationDate.day]);
				previousCompileDayIndex = String(previousCompiliationDate.day);
				previousCompileDayNumber = String(previousCompiliationDate.date);
				previousCompileHour = (hourNotation=="12") ? (previousCompiliationDate.hours==0) ? "12" : (previousCompiliationDate.hours<11) ? String(previousCompiliationDate.hours) : String(previousCompiliationDate.hours - 12) : String(previousCompiliationDate.hours);
				previousCompileHour = (previousCompileHour =="0") ? "12" : previousCompileHour;
				previousCompileMinute = String(LeadingZeros.padNumber(previousCompiliationDate.minutes, 2));
				previousCompileSeconds = String(LeadingZeros.padNumber(previousCompiliationDate.seconds, 2));
				previousCompileMilliseconds = String(LeadingZeros.padNumber(previousCompiliationDate.milliseconds, 3));
				previousCompileAmpm = (previousCompiliationDate.hours<12) ? ampmNames[0] : ampmNames[1];
				
				// get difference in time since last compile time
				timeDifferenceFormatted = "";
				
				// get the difference in days
				var days1:int = Math.floor(timeDifference/DAY);
				days1 = (days1 < 0) ? 0 : days1;
				var remainder:Number = ((timeDifference/DAY) - Math.floor(timeDifference/DAY));
				timeDifferenceFormatted += (days1 < 1) ? "" : ((days1==1) ? days1 + String(timeDifferenceArray[0]).substr(0, String(timeDifferenceArray[0]).length-1) + " " : days1 + timeDifferenceArray[0] + " ");
				
				// get the remaining hours
				var num:Number = remainder * 24;
				var hours1:int = Math.floor(num);
				timeDifferenceFormatted += (hours1 < 1) ? "" : ((hours1==1) ? hours1 + String(timeDifferenceArray[1]).substr(0, String(timeDifferenceArray[1]).length-1) + " " : hours1 + timeDifferenceArray[1] + " ");
				remainder = num - hours1;
				num = remainder * 60;
				
				// get the remaining minutes
				var minutes1:int = Math.floor(num);
				timeDifferenceFormatted += (minutes1 < 1) ? "" : ((minutes1==1) ? minutes1 + String(timeDifferenceArray[2]).substr(0, String(timeDifferenceArray[2]).length-1) + " " : minutes1 + timeDifferenceArray[2] + " ");
				remainder = num - minutes1;
				num = remainder * 60;
				
				// get the remaining seconds
				var seconds1:int = Math.floor(num);
				timeDifferenceFormatted += (seconds1 < 1) ? "" : ((seconds1==1) ? seconds1 + String(timeDifferenceArray[3]).substr(0, String(timeDifferenceArray[3]).length-1) + " " : seconds1 + timeDifferenceArray[3] + " ");
				remainder = num - seconds1;
				num = remainder * 1000;
				
				// get the remaining milliseconds
				var milliseconds1:int = Math.floor(num);
				timeDifferenceFormatted += (milliseconds1==0 || !timeDifferenceMilliseconds) ? "" : milliseconds1 + timeDifferenceArray[4] + " ";
				
				timeDifferenceFormatted = StringUtil.trim(timeDifferenceFormatted);
				
				// set the difference in days, hours, min, sec, ms
				daysDifference = String(days1);
				hoursDifference = String(hours1);
				minutesDifference = String(minutes1);
				secondsDifference = String(seconds1);
				millisecondsDifference = String(milliseconds1);
				
			}
			else {
				// previous compile date is the same as compile date
				previousCompileYear = year;
				previousCompileMonthName = monthName;
				previousCompileMonthNumber = monthNumber;
				previousCompileMonthIndex = monthIndex;
				previousCompileDayName = dayName;
				previousCompileDayIndex = dayIndex;
				previousCompileDayNumber = dayNumber;
				previousCompileHour = hour
				previousCompileMinute = minute;
				previousCompileSeconds = seconds;
				previousCompileMilliseconds = milliseconds;
				previousCompileAmpm = ampm;
				
				timeDifferenceFormatted = "0" + timeDifferenceArray[4];
			}
			
			// save changes
			sharedObject.data.compilationDate = compilationDate.time;
			sharedObject.data.version = localVersion;
			version = String(localVersion);

			// save changes
			if (trackChanges) {
				try {
					sharedObject.flush();
				} catch (e:Event) {
					// can't save info for some reason
				}
			}
			
			// if we have button and the file hasn't changed we show the reload button
			if (reloadButton!=null && !changed && reloadButton is UIComponent) {
				UIComponent(reloadButton).visible = true;
				UIComponent(reloadButton).addEventListener(MouseEvent.CLICK, function():void {
					//SecurityError: Error #2060: Security sandbox violation: ExternalInterface caller 
					// requires you to have access to the wrapper 
					// IE be on a server, like localhost or yourdomain.com 
					try {
						ExternalInterface.call("eval", "document.location.reload(true)");
					}
					catch (event:Error) {} 
				});
			}
			
			dispatchEvent(new Event(CREATION_COMPLETE));
		}

		///////////////////////////////////////////////////////////////////////////
		// Returns compilation date of current module
		///////////////////////////////////////////////////////////////////////////
		public function readCompilationDate(serialNumber:ByteArray = null):Date {
			const compilationDate:Date = new Date;
			const DATETIME_OFFSET:uint = 18;

			if (serialNumber == null)
				serialNumber = readSerialNumber();

			/* example of filled SWF_SERIALNUMBER structure
			   struct SWF_SERIALNUMBER
			   {
			   UI32 Id;         // "3"
			   UI32 Edition;    // "6"
			   // "flex_sdk_4.0.0.3342"
			   UI8 Major;       // "4."
			   UI8 Minor;       // "0."
			   UI32 BuildL;     // "0."
			   UI32 BuildH;     // "3342"
			   UI32 TimestampL;
			   UI32 TimestampH;
			   };
			*/

			// the SWF_SERIALNUMBER structure exists in FLEX swfs only, not FLASH
			if (serialNumber == null)
				return null;

			// date stored as uint64
			serialNumber.position = DATETIME_OFFSET;
			serialNumber.endian = Endian.LITTLE_ENDIAN;
			compilationDate.time = serialNumber.readUnsignedInt() + serialNumber.readUnsignedInt()* (uint.MAX_VALUE + 1);
			
			return compilationDate;
		}

		///////////////////////////////////////////////////////////////////////////
		// Returns contents of Adobe SerialNumber SWF tag
		///////////////////////////////////////////////////////////////////////////
		public function readSerialNumber():ByteArray {
			const TAG_SERIAL_NUMBER:uint = 0x29;
			return findAndReadTagBody(TAG_SERIAL_NUMBER);
		}

		///////////////////////////////////////////////////////////////////////////
		// Returns the tag body if it is possible
		///////////////////////////////////////////////////////////////////////////
		public function findAndReadTagBody(theTagCode:uint):ByteArray {
			// getting direst access to unpacked SWF file
			// reported to cause security sandbox errors ->
			//const src:ByteArray = LoaderInfo.getLoaderInfoByDefinition(SWF).bytes;
			// erg this one throughs an error too TypeError: Error #1009: Cannot access a property or method of a null object reference.
			//const src:ByteArray = Application(FlexGlobals.topLevelApplication).loaderInfo.bytes;
			var src:ByteArray = new ByteArray();
			var loaderInfo:LoaderInfo = application.loaderInfo;
			
			// the swf has not loaded yet - wait until application complete
			if (loaderInfo.bytesLoaded!=loaderInfo.bytesTotal) { 
				return null;
			}
			const test:* = application.loaderInfo.bytes;
			src = application.loaderInfo.bytes;

			/*
			   SWF File Header
			   Field      Type  Offset   Comment
			   -----      ----  ------   -------
			   Signature  UI8   0        Signature byte: “F” indicates uncompressed, “C” indicates compressed (SWF 6 and later only)
			   Signature  UI8   1        Signature byte always “W”
			   Signature  UI8   2        Signature byte always “S”
			   Version    UI8   3        Single byte file version (for example, 0x06 for SWF 6)
			   FileLength UI32  4        Length of entire file in bytes
			   FrameSize  RECT  8        Frame size in twips
			   FrameRate  UI16  8+RECT   Frame delay in 8.8 fixed number of frames per second
			   FrameCount UI16  10+RECT  Total number of frames in file
			*/

			// skip AVM2 SWF header
			// skip Signature, Version & FileLength
			src.position = 8;
			// skip FrameSize
			const RECT_UB_LENGTH:uint = 5;
			const RECT_SB_LENGTH:uint = src.readUnsignedByte() >> (8 - RECT_UB_LENGTH);
			const RECT_LENGTH:uint = Math.ceil((RECT_UB_LENGTH + RECT_SB_LENGTH* 4) / 8);
			src.position += (RECT_LENGTH - 1);
			// skip FrameRate & FrameCount
			src.position += 4;

			while(src.bytesAvailable > 0) {
				with(readTag(src, theTagCode)) {
					if (tagCode == theTagCode)
						return tagBody;
				}
			}

			return null;
		}

		///////////////////////////////////////////////////////////////////////////
		// Returns tag from current read position
		///////////////////////////////////////////////////////////////////////////
		private function readTag(src:ByteArray, theTagCode:uint):Object {
			src.endian = Endian.LITTLE_ENDIAN;

			const tagCodeAndLength:uint = src.readUnsignedShort();
			const tagCode:uint = tagCodeAndLength >> 6;
			const tagLength:uint = function():uint {
					const MAX_SHORT_TAG_LENGTH:uint = 0x3F;
					const shortLength:uint = tagCodeAndLength & MAX_SHORT_TAG_LENGTH;
					return (shortLength == MAX_SHORT_TAG_LENGTH) ? src.readUnsignedInt() : shortLength;
				}();

			const tagBody:ByteArray = new ByteArray;
			if (tagLength > 0)
				src.readBytes(tagBody, 0, tagLength);

			return {tagCode:tagCode, tagBody:tagBody};
		}
	}
}
