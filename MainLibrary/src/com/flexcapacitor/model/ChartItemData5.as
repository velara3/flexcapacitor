package com.flexcapacitor.model
{
	
	/**
	 * Holds chart data. Most arguments is 5.
	 * */
	public class ChartItemData5 extends Item {
		
		public function ChartItemData5(x:Number, y:Number, z:Number, a:Number, b:Number):void {
			this.x = x;
			this.y = y;
			this.z = z;
			this.a = a;
			this.b = b;
		}
		
		public var a:Number;
		
		public var b:Number;
		
		public var x:Number;
		
		public var y:Number;
		
		public var z:Number;
	}
}