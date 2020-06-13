# solocoin-iOS


This is Solocoin’s frontend iOS app Github repo. (https://github.com/solocoinapp/solocoin-ios)

Completed on boarding except API, i hope this helps and reduce efforts to build from scratch and will be easy to continue work efficiently.


## Few things about project setup:

Please use localisation, I already created and used same, so that app can be converted multi language anytime.
Created utils for color and fonts, use that only so that anytime it can be changed to darkTheme or multiple theme and also fonts.
Check out utils folder, most of the methods which can be used commonly in project, helps to ease our work.
Submit button, app icon, datepicker, photo/camera picker are made custom and generic which can be used and access from anywhere inside project.

Adding one more thing if want to use alamofire or any third party lib 
try to use it with a wrapper class over it so that if we want to change at any point of time, it will be easy and without breaking anything it can be changed.

Don't change the layout of the different objects in the app through code, as that will be changed and removed when making the switch to storyboard.


## Requirements

You need Xcode, knowledge of Swift, a Mac, and knowledge of using the storyboard in Xcode.

## Getting To The Xcode Project

In whichever directory or folder you want to have the git repository, type in

git clone  https://github.com/solocoinapp/solocoin-ios.git 

It should create a git repository in that area you git cloned in. Then

	cd solocoin-ios
 then
	cd Solocoin

	cd Solocoin

	open Solocoin.xcodeproj

## Committing To GitHub

This opens the Solocoin app. Here, you can work on the app. When pushing to GitHub, please

	git checkout -m dev

This makes it so that the master branch, or the main branch, doesn’t get affected until someone pushes it, which they will do once the file in the dev branch is 

	git status

	git add .

	git commit -m “Whatever you have done in this commit”

	git push

And you are done. Repeat this whenever pushing to the GitHub repo.

## How To Run The Project On Your Device

Keep in mind that when you run this on your iOS device, it will stay for only 7 days unless you have the Apple Developer Account. What you will have to do is re-run/install it every 7 days. Apple wants to give this downside of having to re-run every 7 days for people to buy the developer account.


## Requirements

To run this on your device, you will need to have a Mac with Xcode installed, an iOS device, and a chord that can plug into your Mac with Xcode and your iOS device.

## Setup

To set this up, if you haven’t already cloned the git repository, follow the ‘Getting To The Xcode Project’’s steps to do this.

You should have the Xcode project open if you have followed the ‘Getting To The Xcode Project’ steps.

## Running The App

To run the app, you will see a triangle as a run button in the top left.

Do not click it yet. What you want to do now, is take your chord and plug it in your Mac and iOS device that you want to run the app on. Next, there will be a device name (probably Iphone SE). Click on that device, and there will be a dropdown menu.

If you have plugged in your device, it will show your device in the very top. 

It might also say ‘untrusted’ in parenthesis next to the name. In this case, you will also get a ‘Trust this computer’ alert on the device, which you should accept. So click on your device name, and it should close the menu.

The area should now show your device’s name next to 'Solocoin'. The next thing to do is click run.

Then, it should run on your phone. Make sure you have logged into your phone.

If you get an error, go to Settings on your device, then go to Developer. In this, make sure you click ‘Trust this computer/developer’.
