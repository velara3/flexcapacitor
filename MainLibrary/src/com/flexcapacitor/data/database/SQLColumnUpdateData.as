
package com.flexcapacitor.data.database {
	
	
	/**
	 * Same as SQLColumnData except that it sets getValueFromData to true. 
	 * @copy SQLColumnData
	 * */
	public class SQLColumnUpdateData extends SQLColumnData {
		
		public function SQLColumnUpdateData() {
			getValueFromData = true;
		}
		
	}
}