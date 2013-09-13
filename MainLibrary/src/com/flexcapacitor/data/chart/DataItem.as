
package com.flexcapacitor.data.chart {
	
	/**
	 * Holds chart data
	 * */
	public class DataItem {
		
		public function DataItem(x:Number=0,y:Number=0,v:Number=0)
		{
			this.x = x;
			this.y = y;
			this.v = v;
		}
		
		public var x:Number;
		
		public var y:Number;
		
		public var v:Number;
	}
}