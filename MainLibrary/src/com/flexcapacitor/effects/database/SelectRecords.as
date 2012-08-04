

package com.flexcapacitor.effects.database {
	
	import com.flexcapacitor.data.database.SQLColumn;
	import com.flexcapacitor.data.database.SQLColumnFilter;
	import com.flexcapacitor.effects.database.supportClasses.SelectRecordsInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	
	import mx.effects.IEffect;
	
	/**
	 * Event dispatched when file is successfully open
	 * */
	[Event(name="success", type="flash.events.Event")]
	
	/**
	 * Event dispatched when file opening is unsuccessful
	 * */
	[Event(name="fault", type="flash.events.Event")]
	
	/**
	 * Selects records from the database.
	 * AIR Only
	 * */
	public class SelectRecords extends ActionEffect {
		
		public static const SUCCESS:String = "success";
		public static const FAULT:String = "fault";
		
		/**
		 *  Constructor.
		 * */
		public function SelectRecords(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target) {
				target = new Object();
			}
			
			super(target);
			
			instanceClass = SelectRecordsInstance;
			
		}
		
		
		/**
		 * The SQL Connection
		 * @see GetDatabase
		 * */
		[Bindable]
		public var connection:SQLConnection;
		
		/**
		 * Effect played if file open is successful.  
		 * */
		public var successEffect:IEffect;
		
		/**
		 * Effect played if file open is unsuccessful.  
		 * */
		public var faultEffect:IEffect;
		
		/**
		 * Name of table
		 * */
		public var tableName:String;
		
		/**
		 * Array of columns and values to insert into the new row
		 * */
		public var fields:Vector.<SQLColumn>;
		
		/**
		 * ID of the last row inserted. 
		 * */
		public var lastInsertRowID:uint;
		
		/**
		 * Fields used to filter the select clause
		 * */
		public var filterFields:Vector.<SQLColumnFilter>;
		
		/**
		 * This value indicates how many rows are returned at one time by the statement. 
		 * The default value is -1, indicating that all the result rows are returned at one time.
		 * */
		public var prefetch:int = -1;
		
		/**
		 * @copy flash.data.SQLStatement#itemClass
		 * */
		public var itemClass:Class;
		
		/**
		 * @copy flash.data.SQLResult
		 * */
		[Bindable]
		public var result:SQLResult;
		
		/**
		 * @copy flash.data.SQLResult#data
		 * */
		[Bindable]
		public var data:Array;
		
	}
}