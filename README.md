iPhone-CTA-Bus-Tracker-App
==========================

Chicago Transit Authority Bus Tracker iPhone Application

CTA Bus Tracker is an iPhone Application that pulls and displays data from the Chicago Transit Authority API.
The application displays Bus Information which include Routes, Stops based on Route Direction, Estimated Arrival Times based on Bus Identification Numbers, and Service Bulletins for each Stop. It also displays the Current Location of the Bus while in transit and also display relevant details such as Stop Length, Latitude and Longitude of each Stop, as well as Waypoints within a selected Route.

The application is created using the IOS Swift Language, using XCode 6.1, and utilizes bridging headers for AFNetworking (http://afnetworking.com/), Reachability (https://github.com/tonymillion/Reachability), and RaptureXML (https://github.com/ZaBlanc/RaptureXML). It also uses MapKit, and a header for stripping HTML from an NSString. It was originally built for the iPhone 4 but is now optimised for the iPhone 5/5s screen.(You can see the difference in the Bus Location View Controller Background Image)

This repository is an collection of learnings from Sparrow (http://gamua.com/sparrow/), to UIKit and Objective C, and presently Swift. It is also a testament of learning from the many thousands who've helped along the way via StackOverflow (http://stackoverflow.com/) and awesome online tutorials (http://www.raywenderlich.com/). A good friend and mentor Jon (https://github.com/jondanao) was (and still remains) a huge factor in the creation and build of this application. Although the application might be a simple app for the countless gurus and ios wizards out there, I hope that this can inspire other aspiring developers like me to never stop learning.

Prerequisites for using the repository:
Sign up for a CTA Developer License here: http://www.ctabustracker.com/bustime/home.jsp
Input your CTA key (mine was a 25 character alphanumeric key) in the AppDelegate file inside the struct yourCTAkey{keyValue}.

All images were created via Adobe Photoshop and Illustrator. This application uses the Gotham font (http://www.typography.com/fonts/gotham/overview/).

To follow: Screenshots of the App
