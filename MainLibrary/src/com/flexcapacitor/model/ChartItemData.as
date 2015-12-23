package com.flexcapacitor.model
{
	
	/**
	 * Holds chart data. 
	 * */
	public class ChartItemData extends Item {
		
		public function ChartItemData(...Arguments):void {
			var numOfArguments:int = Arguments.length;
			this.x = numOfArguments>0 ? Arguments[0] : 0;
			this.y = numOfArguments>1 ? Arguments[1] : 0;
			this.z = numOfArguments>2 ? Arguments[2] : 0;
		}
		
		
		public var x:Number;
		
		public var y:Number;
		
		public var z:Number;
	}
}