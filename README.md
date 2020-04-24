# solocoin-ios
iOS repo for SoloCoin app for iPhones

Completed on boarding except API, i hope this helps and reduce efforts to build from scratch and will be easy to continue work efficiently.


## Few things about project setup:

Please use localisation, I already created and used same, so that app can be converted multi language anytime.
Created utils for color and fonts, use that only so that anytime it can be changed to darkTheme or multiple theme and also fonts.
Check out utils folder, most of the methods which can be used commonly in project, helps to ease our work.
Submit button, app icon, datepicker, photo/camera picker are made custom and generic which can be used and access from anywhere inside project.

Adding one more thing if want to use alamofire or any third party lib 
try to use it with a wrapper class over it so that if we want to change at any point of time, it will be easy and without breaking anything it can be changed.

Don't change the layout of the different objects in the app through code, as that will be changed and removed when making the switch to storyboard.
