




package com.flexcapacitor.utils {
	import mx.formatters.DateFormatter;
	
	/**
	 * Date utilities. 
	 * */
	public class DateUtils {
		
		public function DateUtils() {
			
		}
		
		/**
		 * Creates a date string from the current date by reverse weight. Default format is 
		 * YYYY-MM-DD-HH-NN-SS (ie 2012-12-21 24-59-59)
		 * 
		 * @copy mx.formatters.DateFormatter.formatString
		 * */
		public static function dateName(delimiter:String="-", format:String = null):String {
			var formatter:DateFormatter = new DateFormatter();
			if (format==null) {
				formatter.formatString = "YYYY"+delimiter+"MM"+delimiter+"DD"+" "+"HH"+delimiter+"NN"+delimiter+"SS";
			}
			else {
				formatter.formatString = format;
			}
			return formatter.format(new Date());
		}
		
		/**
		 * Creates a date string from a date object or date string. Default format is 
		 * YYYY-MM-DD-HH-NN-SS (ie 2012-12-21 24-59-59)
		 * @copy mx.formatters.DateFormatter.formatString
		 * */
		public static function formatDate(date:Object, format:String = null, delimiter:String = "-"):String {
			var formatter:DateFormatter = new DateFormatter();
			
			if (format==null) {
				formatter.formatString = "YYYY"+delimiter+"MM"+delimiter+"DD"+" "+"HH"+delimiter+"NN"+delimiter+"SS";
			}
			else {
				formatter.formatString = format;
			}
			
			return formatter.format(date);
		}
	}
}