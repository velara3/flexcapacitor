package com.flexcapacitor.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursorData;
	
	/**
	 * Helper class for cursor management
	 * There are two Mouse cursor classes in Flash and Flex
	 * CursorManager and Mouse. The Mouse class is the latest and
	 * is preferred.  
	 * */
	public class CursorUtils
	{
		public function CursorUtils()
		{
		}
		
		
		
		/**
		 * Creates a cursor instance used to get and set a cursor.
		 * 
		 * Usage:  
<pre>
[Embed(source="icons/hand.png")]
public static const HandCursor:Class;

// create cursor from class or bitmap data
var mouseCursorData:MouseCursorData = CursorUtils.createMouseCursorData(HandCursor, 0, 0);

// register it
var cursorID:String = "handCursor";
Mouse.registerCursor(cursorID, mouseCursorData);

// set
Mouse.cursor = cursorID;

// reset
Mouse.cursor = MouseCursor.AUTO;

// unregister
Mouse.registerCursor(cursorID);
</pre>
		 * 
		 * @param source a vector of BitmapData objects, a single instance of a BitmapData
		 * or a class (embeded image)
		 * @return an instance of MouseCursorData
		 * */
		public static function createMouseCursorData(source:*, cursorX:int = 0, cursorY:int = 0, frameRate:int = 0):MouseCursorData {
			var cursorData:MouseCursorData;
			var cursorBitmapDatas:Vector.<BitmapData>;
			var cursorBitmap:Bitmap;
			var CursorClass:Class;
			
			// Create a MouseCursorData object 
			cursorData = new MouseCursorData();
			
			// Create the bitmap cursor 
			// The bitmap must be 32x32 pixels or smaller, due to an OS limitation
			
			if (source is Class) {
				CursorClass = source;
				cursorBitmap = new CursorClass();
				cursorBitmapDatas = new Vector.<BitmapData>(1, true); 
				cursorBitmapDatas[0] = cursorBitmap.bitmapData;
			}
			else if (source is BitmapData) {
				cursorBitmapDatas[0] = source as BitmapData;
			}
			else if (source is Vector) {
				cursorBitmapDatas = source as Vector.<BitmapData>;
			}
			
			// Assign the bitmap to the MouseCursor object 
			cursorData.data = cursorBitmapDatas;
			
			// Specify the hotspot 
			cursorData.hotSpot = new Point(cursorX, cursorY); 
			cursorData.frameRate = frameRate;
			
			return cursorData;
		}
	}
}