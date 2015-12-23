
package com.flexcapacitor.utils {
	import com.flexcapacitor.model.ChartItemData;
	import com.flexcapacitor.model.ChartItemData4;
	import com.flexcapacitor.model.ChartItemData5;
	import com.flexcapacitor.model.ChartItemData6;
	
	/**
	 * A class for generating random data
	 * */
	public class RandomData {
		
		/**
		 * Class type used in generating chart data
		 * */
		public var ChartItem:Class = ChartItemData;
		
		/**
		 * Letters used in generating random letter
		 * */
		public static var letters:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
		
		/**
		 * Constructor
		 * */
		public function RandomData()
		{
			
		}
		
		/**
		 * Generates generic chart data
		 * @see generateChartDataFloat
		 * */
        public function generateChartData(count:int = 10):Array {
            var newData:Array = [];
            var X:int;
            var Y:int;
            var V:int;
			
			
            for (var i:int;i<count;i++) {
				X = Math.floor(Math.random()*100);
                Y = Math.floor(Math.random()*100);
                V = Math.floor(Math.random()*10);
				
                newData.push(new ChartItem(X,Y,V));
            }
			
			return newData;
        }
		
		/**
		 * Generates generic chart data with float values
		 * */
        public function generateChartDataFloat(count:int = 10):Array {
            var newData:Array = [];
            var X:Number = Math.random() * 100 - 50;
            var Y:Number = X - Math.random() * 10;
            var V:Number = Math.random() * 100;
			
			
            for (var i:int;i<count;i++) {
				X = Math.random()*100;
                Y = Math.random()*100;
                V = Math.random()*10;
				
                newData.push(new ChartItem(X,Y,V));
            }
			
			return newData;
        }
        
		/**
		 * Generates chart data for the Line chart
		 * */
		public function generateLineData(count:int = 10):Array {
            var newData:Array = [];
            var X:Number = Math.random()*100 - 50;
            var Y:Number = X - Math.random() * 10;
            var V:Number = Math.random()*100;
			
            for(var i:int = 0;i<count;i++) {
                X = X + Math.random() * 10 - 5;
                Y = X - Math.random() * 10;
                V = Math.random() * 100;
				
                newData.push(new ChartItem(X,Y,V));
            }
			
			return newData;
        }
        
		/**
		 * Generates data for the data grid
		 * */
        public function generateDataGridData(count:int = 10, rows:int = 6):Array {
            var newData:Array = [];
			var X:int, Y:int, Z:int, A:int, B:int, C:int;
            var xMin:int = Math.random()*10000;
            var yMin:int = Math.random()*10000;
            var zMin:int = Math.random()*10000;
            var xMax:int = Math.random()*100000;
            var yMax:int = Math.random()*100000;
            var zMax:int = Math.random()*100000;

			
            for (var i:int;i<count;i++) {
				X = Math.floor(Math.random() * (xMax - xMin + 1)) + xMin;
                Y = Math.floor(Math.random() * (yMax - yMin + 1)) + yMin;
                Z = Math.floor(Math.random() * (zMax - zMin + 1)) + zMin;
				C = Math.floor(Math.random() * (xMax - xMin + 1)) + xMin;
				B = Math.floor(Math.random() * (xMax - xMin + 1)) + xMin;
				A = Math.floor(Math.random() * (xMax - xMin + 1)) + xMin;
				
				if (rows>5) {
	                newData.push(new ChartItemData6(X,Y,Z,A,B,C));
				}
				else if (rows>4) {
	                newData.push(new ChartItemData5(X,Y,Z,A,B));
				}
				else if (rows>3) {
					newData.push(new ChartItemData4(X,Y,Z,A));
				}
				else {
	                newData.push(new ChartItem(X,Y,Z));
				}
            }
			
			return newData;
        }
		
		
		/**
		 * Generate random letter
		 * */
		public function getRandomLetter(letterSet:String = null):String {
			if (letterSet==null) letterSet = letters;
			var location:int = Math.floor(Math.random() * letterSet.length);
			var letter:String = letterSet.charAt(location);
			return letter;
		}
	}
}


