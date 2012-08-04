

package com.flexcapacitor.effects.database.supportClasses {
	import com.flexcapacitor.data.database.SQLColumn;
	import com.flexcapacitor.data.database.SQLColumnFilter;
	import com.flexcapacitor.effects.database.SelectRecords;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.Event;
	
	
	/**
	 * @copy SelectRecords
	 * */  
	public class SelectRecordsInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function SelectRecordsInstance(target:Object) {
			super(target);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 * */
		override public function play():void {
			// Dispatch an effectStart event
			super.play();
			
			var action:SelectRecords = SelectRecords(effect);
			var connection:SQLConnection = action.connection;
			var tableName:String = action.tableName;
			var fields:Vector.<SQLColumn> = action.fields;
			var filterFields:Vector.<SQLColumnFilter> = action.filterFields;
			var itemClass:Class = action.itemClass;
			var prefetch:int = action.prefetch;
			var statement:SQLStatement;
			var request:String;
			var field:SQLColumn;
			var filterField:SQLColumnFilter;
			var fieldsLength:int;
			var result:SQLResult;
			var successful:Boolean;
			var parameters:Object;
			var alias:String;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!connection) {
					dispatchErrorEvent("A connection is required");
				}
				if (!tableName) {
					dispatchErrorEvent("A table name must be specified");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			statement = new SQLStatement();
			statement.sqlConnection = connection;
			statement.itemClass = action.itemClass;
			parameters = statement.parameters;
			
			// build request statement
			request = "SELECT ";
			
			
			fieldsLength = fields ? fields.length : 0;
			
			if (fieldsLength) {
				// get column names
				for (var i:int;i<fieldsLength;i++) {
					if (i>0) request += ",";
					field = fields[i];
					request += field.name;
				}
			}
			else {
				request += " *";
			}
			
			request += " FROM " + tableName;
			
			fieldsLength = filterFields ? filterFields.length : 0;
			
			// where clause
			if (fieldsLength>0) {
				request += " WHERE ";
				
				// get column name and value
				for (i=0;i<fieldsLength;i++) {
					if (i>0) request += ",";
					field = filterFields[i];
					alias = ":" + field.name;
					request += filterField.name + "=" + alias;
					parameters[alias] = filterField.value;
				}
			}
			
			// sql statement
			statement.text = request;
			
			try {
				statement.execute(prefetch);
				result = statement.getResult();
				successful = true;
			} catch(error:Error) {
				trace(error.message);
				successful = false;
			}
			
			// sql result
			action.result = result;

			// records data
			action.data = result.data;
			
			// success
			if (successful) {
				
				if (hasEventListener(SelectRecords.SUCCESS)) {
					dispatchEvent(new Event(SelectRecords.SUCCESS));
				}
				
				if (action.successEffect) {
					playEffect(action.successEffect);
				}
			}
			else {
				
				// fault
				if (hasEventListener(SelectRecords.FAULT)) {
					dispatchEvent(new Event(SelectRecords.FAULT));
				}
				
				if (action.faultEffect) {
					playEffect(action.faultEffect);
				}
			}
			
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
	}
}