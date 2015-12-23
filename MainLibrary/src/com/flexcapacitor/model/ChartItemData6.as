package com.flexcapacitor.model
{
	
	/**
	 * Holds chart data. Most arguments is 6.
	 * */
	public class ChartItemData6 extends Item {
		
		public function ChartItemData6(x:Number, y:Number, z:Number, a:Number, b:Number, c:Number):void {
			this.x = x;
			this.y = y;
			this.z = z;
			this.a = a;
			this.b = b;
			this.c = c;
		}
		
		public var a:Number;
		
		public var b:Number;
		
		public var c:Number;
		
		public var x:Number;
		
		public var y:Number;
		
		public var z:Number;
	}
}