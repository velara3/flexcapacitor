




package com.flexcapacitor.utils {
	import mx.formatters.DateFormatter;
	
	/**
	 * Date utilities. 
	 * */
	public class DateUtils {
		
		public function DateUtils() {
			
		}
		
		/**
		 * Creates a date string from the current date by reverse weight
		 * */
		public static function dateName(delimiter:String="-"):String {
			var formatter:DateFormatter = new DateFormatter();
			formatter.formatString = "YYYY"+delimiter+"MM"+delimiter+"DD"+delimiter+"LL"+delimiter+"NN"+delimiter+"QQQ";
			return formatter.format(new Date());
		}
	}
}