

package com.flexcapacitor.effects.database.supportClasses {
	import com.flexcapacitor.data.database.SQLColumnData;
	import com.flexcapacitor.data.database.SQLColumnFilter;
	import com.flexcapacitor.effects.database.DeleteRecord;
	import com.flexcapacitor.effects.database.UpdateRecord;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.Event;
	
	
	/**
	 * @copy UpdateRecord
	 * */  
	public class UpdateRecordInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function UpdateRecordInstance(target:Object) {
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
			
			var action:UpdateRecord = UpdateRecord(effect);
			var connection:SQLConnection = action.connection;
			var tableName:String = action.tableName;
			var fields:Vector.<SQLColumnData> = action.fields;
			var filterFields:Vector.<SQLColumnFilter> = action.filterFields;
			var statement:SQLStatement;
			var request:String;
			var field:SQLColumnData;
			var filterField:SQLColumnFilter;
			var fieldsLength:int;
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
			parameters = statement.parameters;
			
			request = "UPDATE " + tableName + " SET ";
			
			fieldsLength = fields.length;
			
			// get column name and value
			for (var i:int;i<fieldsLength;i++) {
				if (i>0) request += ",";
				field = fields[i];
				alias = ":" + field.name;
				request += field.name + "=" + alias;
				parameters[alias] = field.value;
			}
			
			fieldsLength = filterFields ? filterFields.length : 0;
			
			// where clause
			if (fieldsLength>0) {
				request += " WHERE ";
				
				// get column name and value
				for (i=0;i<fieldsLength;i++) {
					if (i>0) request += ",";
					field = filterFields[i];
					alias = ":" + field.name;
					request += field.name + "=" + alias;
					parameters[alias] = field.value;
				}
			}
			
			
			// sql statement
			statement.text = request;
			
			try {
				statement.execute();
				successful = true;
			} catch (error:Error) {
				successful = false;
				
				if (action.traceErrorMessage) {
					traceMessage(error.message);
					
					if ("details" in error) {
						traceMessage(error['details']);
					}
				}
				
				if (action.hasEventListener(DeleteRecord.ERROR)) {
					dispatchActionEvent(new Event(DeleteRecord.ERROR));
				}
				
				if (action.errorEffect) {
					playEffect(action.errorEffect);
				}
			}
			
			// success
			if (successful) {
				
				if (hasEventListener(UpdateRecord.SUCCESS)) {
					dispatchActionEvent(new Event(UpdateRecord.SUCCESS));
				}
				
				if (action.successEffect) {
					playEffect(action.successEffect);
				}
			}
			else {
				
				// fault
				if (hasEventListener(UpdateRecord.FAULT)) {
					dispatchActionEvent(new Event(UpdateRecord.FAULT));
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