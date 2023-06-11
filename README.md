# 🌌 Space App!
This is a web app for creating random space patterns for users enjoyment. 

User can select color for background color gradient and they can save generated image as an .png file.
- App is written with Dart using Flutter Framework, built for web deployment (JS).
- Can be compiled into a mobile app (Android and iOS).
- Uses riverPod for statemanagement and Hive as local storage.

## ⭐ App can be tested [HERE](https://jyrispaceapp.web.app/#/)! 
```diff
- ⚠️ NOTE: App is buggy on mobile browsers. Desktop Browser is recommended.
```

# SCREENSHOTS:
![Screenshot 1](screenshots/screenshot1.png?raw=true "Screenshot 1")
![Screenshot 2](screenshots/screenshot2.png?raw=true "Screenshot 2")
![Screenshot 3](screenshots/screenshot3.png?raw=true "Screenshot 3")

&nbsp;

# 🐞 KNOWN BUGS:
## 🌐 WEB
- Does not work on mobile WebKit browsers.
    - iOS Safari and Android Chrome confirmed not to work.
    - Worked on Android Firefox
    - Might be related to Hive or Flutter Web?
## 📱 MOBILE
- Does not draw all planets when image is saved.

&nbsp;

# ✔️ TODO:
- Fix Bugs
- Write more Tests
- Add option for user to change number of stars and planets.
- More complex celestial objects (ringed planets), "Space Fog" and pre-defined patterns
- Create gallery for browsing saved patterns.

