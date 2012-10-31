

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
	 * Event dispatched when an error occurs
	 * */
	[Event(name="error", type="flash.events.Event")]
	
	
	/**
	 * Selects records from the database.
	 * AIR Only
<pre>
		
	&lt;s:ArrayCollection id="notes" source="{select.data}"/>
 
	&lt;database:SQLConnection id="connection"/>
 
	&lt;db:GetDatabase id="database" fileName="myData.db" connection="{connection}">
		&lt;db:notCreatedEffect>
			&lt;db:CreateTable connection="{connection}" tableName="notes" >
				&lt;db:fields>
					&lt;database:SQLColumn name="id" 
										 autoIncrement="true" 
										 dataType="INTEGER" 
										 primaryKey="true"/>
					&lt;database:SQLColumn name="title"  
										 dataType="TEXT" />
					&lt;database:SQLColumn name="content"  
										 dataType="TEXT" />
					&lt;database:SQLColumn name="creationDate"  
										dataType="TEXT" />
					&lt;database:SQLColumn name="modifyDate"  
										dataType="TEXT" />
				&lt;/db:fields>
			&lt;/db:CreateTable>
		&lt;/db:notCreatedEffect>
	&lt;/db:GetDatabase>

	
	&lt;db:SelectRecords id="select" 
					  tableName="notes" 
					  connection="{connection}"
					  itemClass="{Note}"
					  >
	&lt;/db:SelectRecords>
</pre>
	 * */
	public class SelectRecords extends ActionEffect {
		
		public static const SUCCESS:String = "success";
		public static const FAULT:String = "fault";
		public static const ERROR:String = "error";
		
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
		
		/**
		 * Effect played on error
		 * */
		public var errorEffect:IEffect;
		
		/**
		 * Reference to the error event
		 * */
		[Bindable]
		public var errorEvent:Error;
		
	}
}