package com.flexcapacitor.model
{
	
	/**
	 * Holds chart data. Most arguments is 4.
	 * */
	public class ChartItemData4 extends ChartItemData {
		
		public function ChartItemData4(x:Number, y:Number, z:Number, a:Number):void {
			this.x = x;
			this.y = y;
			this.z = z;
			this.a = a;
		}
		
		public var a:Number;
	}
}