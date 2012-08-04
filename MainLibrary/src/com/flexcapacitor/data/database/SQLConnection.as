
package com.flexcapacitor.data.database {
	import flash.data.SQLConnection;
	
	/**
	 * Note: Extends flash.data.SQLConnection so it can be declared in MXML.
	 * The flash.data class is excluded from MXML by default.
	 * 
	 * @copy flash.data.SQLConnection
	 * */
	public class SQLConnection extends flash.data.SQLConnection {
		
		public function SQLConnection() {
			super();
		}
	}
}