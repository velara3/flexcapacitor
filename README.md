Flex Capacitor Library
======

A library of resources for Flex projects (beta).

==A library of resources for Flex projects^beta^==
This library contains Flex controls, classes and utilities. The main feature of this library are the action effects classes (work in progress). Their goal is to take common Flex and AS3 code and wrap it up into an an abstract reusable class and apply it in MXML. In other environments these have been similar to or known as contracts, interactions, behaviors, commands, tasks and so on ([http://www.flexcapacitor.com/examples/LibraryExamples/examples demo]).<br/>

===Contents===
  * Webview - composes the StageWebView in a UIComponent 
  * Minimal Scroller - adds MacOSX style scroll bars
  * Mini Inspector - helps designers and developers design and develop and debug at runtime
  * Event Handler - adds event listener(s) to target(s) in MXML and runs actions on those events
  * Form classes - simplifies working with forms on the client and server 
  * Action Effects - common behaviors applied in MXML allowing synchronous behavior on asynchronous objects.<br/>


===Libraries===
There's two libraries, one general and one mobile. There are example projects for each (well, the general one so far). <br/>

*Library*<br/>
https://flexcapacitor.googlecode.com/svn/trunk/library<br/>
https://flexcapacitor.googlecode.com/svn/trunk/mobileLibrary<br/>

*Examples*<br/>
https://flexcapacitor.googlecode.com/svn/trunk/libraryExamples<br/>
https://flexcapacitor.googlecode.com/svn/trunk/mobileLibraryExamples<br/>

*Live Examples*<br/>
Here are some live examples of some of the effects in this library including sorting, filtering, browsing for files and loading files. Right click to view source.<br/>
http://www.flexcapacitor.com/examples/LibraryExamples<br/>
http://www.judahfrangipane.com/examples/uigraphics<br/>
<br/>

===Action Effects===
The action effects are the main attraction here. A few lines of MXML code can replace millions of lines of code (ed. - it's all relative). Below is example code for sorting and filtering an array collection:<br/>

{{{
    <fx:Declarations>
    
        <!-- SORT BY NAME -->
        <handlers:EventHandler eventName="creationComplete" >
            <data:SortCollection target="{arrayCollection}"  />
        </handlers:EventHandler>
        
        
        <!-- FILTER -->
        <handlers:EventHandler eventName="change" target="{filterInput}">
            <data:FilterCollection target="{arrayCollection}" 
                                   source="{filterInput}" 
                                   sourcePropertyName="text"/>
        </handlers:EventHandler>
    </fx:Declarations>

    <s:HGroup>
        <s:TextInput id="filterInput" width="80%" prompt="Search"/>
        <s:Button id="searchButton" label="search"/>
    </s:HGroup>
}}}
<br/>
In the code above the array collection is sorted on creation complete of the document. The array collection is filtered when the user types text into the search text input. The code above uses the EventHandler class to add event handlers via MXML and run the sequence of actions it contains. A live example is shown on the examples page.<br/>


===Action Effects Examples===
Here are some initial examples including sorting, filtering, browsing for files and loading files. Right click to view source. 
[http://www.flexcapacitor.com/examples/LibraryExamples/ Action Effects Examples]<br/>


===Action Effects Benefits===
  * Easy to read and apply - Easy to write MXML (XML) and set options easily. Same benefits as other MXML components and classes.
  * Less typing - You don't have to type the same things you type all the time.
  * Less error prone - Parameters and options are set through typed properties preventing incorrect values. Code is written once, not every time. Only the options change. 
  * Interactive error messages - Parameter values and options are validated at runtime and generate context sensitive error messages.
  * Human readable - Understandable names such as Open Camera Roll, Sort Collection, etc
  * Linear - Can be run in sequence, pause and resume. For example, a service call action can run and then wait to continue until after a result is received. No event listeners required.  
  * Non-Linear - Can branch to other sequences. For example, if working on an app that can run on mobile or browser you can check if you are on a mobile device and open the camera roll (OpenCameraRoll action) or if in the browser open a browse dialog (OpenBrowserDialog action) or run another sequence of actions. 
  * Easy to test - Can easily create tests. <br/>


===Action Effects Notes and Considerations===
The goal has been to wrap up commonly written code, typically code that has gotchas or has been complicated, so that it can be applied by setting properties in declarative MXML.

To accomplish this I've commandeered the Effects classes and extended them with the required features. There are a few things that the effects classes do that these do not. These do not add the effect class properties onto the effectInstance class. The standard effects do this. The standard effects then override the createInstance method on the effect class and set the those properties. These action effect instance classes get a reference to the effect class in the effect instance class (standard behavior) and accesses the properties it needs from it (not standard). 

This may create an opportunity for a memory leak if the effects class creates a strong reference to a variable in the effect instance (as I understand it). This has been considered during development and my conclusion is that the way the effects are used and the amount of cases that this would occur are such the benefits out weigh the issues (if they exist). In the case where they are not the properties should be moved to the instance class and the values set in the create instance method. 

In conclusion, my goal has been to finish these first and update them later (which can happen transparently in the background - no changes to your code) with the help of the community. In addition there are new telemetry tools in development (not released yet) that will determine and clarify what amount, if any, of these issues exist.<br/>


===Misc===
Over the years I've found many great code examples online. At first I was placing them in my main project library and then later keeping them separate. In creating this library I tried to remove all external library code. However, if I missed some let me know and I'll remove it or give attribution. And thanks to everyone that have ever posted examples online. <br/>


===Like to help?===
Please request to be added to the project or donate by sending me a project file. If you're not sure if it's coded right don't worry. I'd like to keep all action effects in one location so we can all use them and work on them together.<br/>

