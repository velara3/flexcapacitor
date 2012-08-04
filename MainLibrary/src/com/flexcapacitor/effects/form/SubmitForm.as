

package com.flexcapacitor.effects.form {
	
	import com.flexcapacitor.effects.form.supportClasses.SubmitFormInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	import com.flexcapacitor.form.FormAdapter;
	
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import mx.core.UIComponent;
	import mx.rpc.http.HTTPService;
	
	
	[Event(name="securityErrorEvent", type="flash.events.SecurityErrorEvent")]
	[Event(name="ioErrorEvent", type="flash.events.IOErrorEvent")]
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * Not complete.
	 * @see RequestServiceURL
	 * */
	public class SubmitForm extends ActionEffect {
		
		public static const RESULT_EVENT:String = "resultEvent";
		public static const FAULT_EVENT:String = "faultEvent";
		
		/**
		 *  Constructor.
		 *
		 *  @param target The Object to animate with this effect.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function SubmitForm(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			duration = 0;
			
			instanceClass = SubmitFormInstance;
			validate = true;
		}
		
		/**
		 * Reference to the Form Adapter instance. Required.
		 * */
		public var formAdapter:FormAdapter;
		
		/**
		 * When enabled validates the form elements.
		 * If the form is invalid the invalidFormEffect is played if set. 
		 * If the form is invalid the invalidFormEvent is dispatched if listeners have been added.
		 * */
		public var validate:Boolean;
		
		public var data:Object;
		
		/**
		 * If the target component in a form is null (has not yet been created)
		 * and we are creating the request data then when this value is true 
		 * we do not throw an error and the target is not added to the request 
		 * */
		public var suppressNullTargetErrors:Boolean;
		
		/**
		 * Request being submitted
		 * */
		public var request:URLRequest;
		
		/**
		 * Additional request data to send to the server. Overwrites if properties of same name exist.
		 * */
		public var requestData:Object;
		
		/**
		 * 
		 * */
		public var modeToSwitchToAfterSubmit:String;
		
		/**
		 * When set to true calls the save method on a class that is 
		 * assigned to the save class property 
		 * */
		public var saveAfterSubmit:Object;
		
		/**
		 * A view with the currentState property
		 * */
		public var view:UIComponent;
		
		/**
		 * Name of state to go to if changeViewState is enabled. 
		 * Changes the state in the view property.
		 * */
		public var stateToSwitchToAfterSubmit:String;
		
		/**
		 * Method to call that submits the item. Must accept at least one parameter which is the item.
		 * */
		public var submitMethod:Function;
		
		/**
		 * Form submission type. URLRequestMethod.POST or URLRequestMethod.GET
		 * 
		 * @copy mx.rpc.http.HTTPService#method
		 * @see mx.rpc.http.HTTPService#method
		 * */
		[Inspectable(enumeration="GET,get,POST,post,HEAD,head,OPTIONS,options,PUT,put,TRACE,trace,DELETE,delete", defaultValue="GET", category="General")]
		public var requestMethod:String = URLRequestMethod.POST;
		
		/**
		 * Method that saves the changes.
		 * */
		public var saveMethod:Function;
		
		/**
		 * URL to submit form to
		 * @copy mx.rpc.http.HTTPService#url
		 * */
		public var url:String;
		
		/**
		 * Result object returned from the server
		 * */
		public var result:Object;
		
		/**
		 * 
		 * @copy mx.rpc.http.HTTPService
		 * */
		public var service:HTTPService;
		
		/**
		 * When enabled resets the form after a successful submit.
		 * */
		public var resetForm:Boolean;
		
		/**
		 * Effect to run when a service fault is generated
		 * */
		public var faultEffect:ActionEffect;
		
		/**
		 * Effect to run when form is invalid. 
		 * */
		public var invalidFormEffect:ActionEffect;
		
		/**
		 * Inspects the request object
		 * */
		public var inspectRequestObject:Boolean;
		public var inspectResultObject:Boolean;
		
		/**
		 * @copy mx.rpc.http.AbstractOperation#resultFormat
		 * */
		[Inspectable(enumeration="object,array,xml,flashvars,text,e4x")]
		public var resultFormat:String;
	}
}