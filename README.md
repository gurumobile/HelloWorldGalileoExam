# HelloWorldGalileoExam

# Installing SDK...

- Manual installation

Installation is as easy as adding the SDK folder to you project directory.

Download the SDK archive either in .zip format or .tar.gz.
Extract the archive to somewhere appropriate in your project direcory. For this guide you will extract the contents of the archive to a folder called Galileo-iOS-SDK, located in the root of the project directory.

- Installing as a git submodule

This method assumes you are using git for source control and have a git repository containing your Xcode project already set up.

Navigate to the root of you git repository and execute the following commands. This will create and initialise the submodule and commit the changes.

 git submodule add https://github.com/motrr/Galileo-iOS-SDK.git
 git commit -m "Added Galileo iOS SDK submodule"
At some point in the future you may wish to update you project’s copy of the SDK to the latest version. To do this, again navigate to the root directory and execture the following.

 cd Galileo-iOS-SDK
 git checkout master
 git pull
 cd ..
 git add Galileo-iOS-SDK
 git commit -m "Updated Galileo iOS SDK submodule"
 
 # Configuration XCode Project...
 
 our Xcode project will need to be configured to include the GalileoControl framework and its dependencies. You will also need to declare the use of Galileo’s External Accessory protocols.

- Adding the GalileoControl framework

Locate the GalileoControl.framework directory within your SDK folder. Drag and drop the .framework directory into the Frameworks group of your Xcode project.

When asked to confirm, ensure that “Copy items into destination group’s folder” is not selected.

Adding the GalileoControl framework
Adding additional dependencies

The GalileoControl framework also depends on the following Apple frameworks and libraries.

libxml2.dylib
ExternalAccessory.framework
CoreBluetooth.framework
QuartzCore.framework

- Adding them to your project can be done using the following steps.

In the project editor, select the target to which you want to add a library or framework.
Click Build Phases at the top of the project editor.
Open the Link Binary With Libraries section.
Click the Add (+) button to add a library or framework.
Select a library or framework from the list and click Add.

# Declaring External Accessory protocols

motrr defines one External Accessory protocols which must be declared in you project’s Info.plist file under the Supported external accessory protocols key.

com.motrr.galileo
Configure your Info.plist with the following steps.

In the project explorer, locate you project’s Info.plist file. It will be prefixed with project’s name and is typically located in the Supporting Files group.
In the property list editor, hold the pointer over an entry and click the Add (+) button.
Choose the key name Supported external accessory protocols from the pop-up menu.
Add an entry for the motrr protocol com.motrr.galileo.

# Connecting to Galileo...

Connecting to Galileo is performed asynchronously. Notification of a succesful connection is provided using the GCGalileoDelegate protocol whilst initiating a connection is done using the GCGalileo shared instance. A notification based alternative to the delegate protocol is also available, please refer to the documentation for details.

To begin with, ensure you include the GalileoControl.h header in any source files which make use of the GalileoControl framework.

 #import <GalileoControl/GalileoControl.h>
To initiate a connection, access the shared Galileo instance and call the waitForConnection method. Typically you would also set the delegate prior to this call.

[GCGalileo sharedGalileo].delegate = self;
[[GCGalileo sharedGalileo] waitForConnection];
In order to be notified when a connection is established you must also implement the GCGalileoDelegate protocol. The following code snippet alerts the user when Galileo connects by implementing the galileoDidConnect method.

 - (void) galileoDidConnect
 {
     UIAlertView* galileoConnectedAlert = [[UIAlertView alloc] initWithTitle:@"Galileo connected!"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
     [galileoConnectedAlert show];
 }
It is also normally a good idea to handle Galileo disconnecting in the event that the device is removed from the accessory or runs out of battery. A typical reaction might be to start waiting for the next connection, amongst other things.

  - (void) galileoDidDisconnect
 {
     [[GCGalileo sharedGalileo] waitForConnection];
 }
