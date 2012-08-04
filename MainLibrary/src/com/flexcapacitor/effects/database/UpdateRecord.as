

package com.flexcapacitor.effects.database {
	
	import com.flexcapacitor.data.database.SQLColumnData;
	import com.flexcapacitor.data.database.SQLColumnFilter;
	import com.flexcapacitor.effects.database.supportClasses.UpdateRecordInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.data.SQLConnection;
	
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
	 * Inserts a record into the database.
	 * AIR Only
	 * */
	public class UpdateRecord extends ActionEffect {
		
		public static const SUCCESS:String = "success";
		public static const FAULT:String = "fault";
		
		/**
		 *  Constructor.
		 * */
		public function UpdateRecord(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target) {
				target = new Object();
			}
			
			super(target);
			
			instanceClass = UpdateRecordInstance;
			
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
		public var fields:Vector.<SQLColumnData>;
		
		/**
		 * ID of the last row inserted. 
		 * */
		public var lastInsertRowID:uint;
		
		/**
		 * Array of columns and values to filter the update
		 * */
		public var filterFields:Vector.<SQLColumnFilter>;
		
	}
}