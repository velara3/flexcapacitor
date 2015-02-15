/**
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/


var StoreLogin = {

	getElement: function(element) {
		if (typeof element === 'string') {
			return document.getElementById(element);
		} else {
			return element;
		}
	},
	
	addElement: function(element, target) {
		var element = this.getElement(element);
		var target = this.getElement(target);
		if (!target) { target = document.body; }
		target.appendChild(element);
	},
	
	removeElement: function(element) {
		var element = this.getElement(element);
		element.parentNode.removeChild(element);
	},
	
	addListener: function() {
		if (window.addEventListener) {
			return function(element, type, handler) {
				this.getElement(element).addEventListener(type, handler, false);
			};
		} else if (window.attachEvent) {
			return function(element, type, listener) {
				var handler = function() {
					listener.call(this.getElement(element), window.event);
				};
				this.getElement(element).attachEvent('on' + type, handler);
			};
		}
	}(),

	resizeApplication: function(id, value) {
		var element = this.getElement(id);
		element.style.height = value;
		return true;
	},

	insertForm: function(id) {
		var form 		= document.createElement('form');
		var textinput 	= document.createElement('input');
		var password 	= document.createElement('input');

		form.id 		= id;
		textinput.id 	= "username";
		password.id 	= "password";
		password.type 	= "password";

		form.appendChild(textinput);
		form.appendChild(password);
		this.addElement(form);

		return true;
	},

	setFormValues: function(username, password) {
		var usernameInput = this.getElement('username');
		var passwordInput = this.getElement('password');
		usernameInput.value = username;
		passwordInput.value = password;
		return true;
	},

	getFormValues: function() {
		var usernameInput = this.getElement('username');
		var passwordInput = this.getElement('password');
		return [usernameInput.value, passwordInput.value];
	},

	clearFormValues: function() {
		var usernameInput = this.getElement('username');
		var passwordInput = this.getElement('password');
		usernameInput.value = "";
		passwordInput.value = "";
		return true;
	},

	getUsername: function() {
		var usernameInput = this.getElement('username');
		return usernameInput.value;
	},

	getPassword: function() {
		var passwordInput = this.getElement('password');
		return passwordInput.value;
	},

	submitForm: function(id) {
		var form = this.getElement(id);
		form.submit();
		form.submit();// chrome required two submits before prompt
		return true;
	},

	noDirectLogin: function() {
		return false;
	},

	checkForPassword: function(username) {
		var usernameInput = this.getElement('username');
		var passwordInput = this.getElement('password');
		usernameInput.value = username;
		if (username!="") {
			usernameInput.focus();
			usernameInput.blur();
		}
		else {
			passwordInput.value = "";
		}
		return passwordInput.value;
	},

	setFocusOnFlash: function(id) {
		var application = this.getElement(id);
		application.tabIndex = 0;
		application.focus();
		return true;
	},

	formExists: function(id) {
		var form = this.getElement(id);
		return form!=null;
	},

	showForm: function(id) {
		var form = this.getElement(id);
		form.style.display = "block";
		return true;
	},

	hideForm: function(id) {
		var form = this.getElement(id);
		form.style.display = "none";
		return true;
	},

	scriptConfirmation: function() {
		return true;
	}
};
