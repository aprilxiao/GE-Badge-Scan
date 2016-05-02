# GE Badge Scanning App
![App screenshot](https://raw.githubusercontent.com/aprilxiao/GE-Badge-Scan/master/screenshot.png =375x)

## Summary
The GE Badge Scanning App scans and stores employee badges for attendnace-tracking purposes. This data can be exported via email in a CSV format.

## Installation
Since the app is not on the App Store, installing it on an iPhone requires a development environment.

### Prerequisites
* A computer with OS X
* An iPhone (iPads will not work)
* Xcode (which can be installed via the App Store)

### Instructions
1. Click "Download ZIP" at the top-right of this page.
2. Extract the ZIP file.
3. In the resulting folder, navigate to GEmock.
4. Open GEmock.xcodeproj, which will launch Xcode.
5. Connect the iPhone to the computer via USB.
6. In the top-left corner of the screen, a button says "GEmock," immediately to the right of which is a device dropdown. If the name of your iPhone is not selected, choose it from the list.
7. Press the play button.
8. Xcode will take some time to build the project, after which the app should launch on the iPhone.

## Use
* While in the main dashboard, tap the top right corner of the screen to add a new event.
* Select an event from the dashboard list in order to scan or export data.
* In an event page, tap the large blue button to scan badges.
* Tap "Scan next" to scan a badge. Once the photo is taken, the app will take a second to process it, after which the read data will appear in the fields on the screen.
* Depending on the properties of the photo, the scan can fail. If necessary, fix the data displayed on the screen.
* Tap "Scan next" to save and scan another badge, or "Save" in the top-right corner of the screen to exit scanning.
* In an event page, tap the button at the top-right of the screen to export attendance data for that event.
