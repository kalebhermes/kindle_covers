# kindle_covers

With Flutter 2.0, Flutter Web was officially released. I wanted to play around with building a web app that behaved 'appropriately' on the web. 

If you're like me, you've got a mediumly large Kindle Library, but it's hard to visualize all those book covers on a little black & white Kindle screen. This app takes a list of ASIN and builds a GridView of Kindle book covers for easy visualization. There's also download links for high resolution versions of those images, and a bash script to download all of them at once.  

## Getting Started
1. Be sure you're running a version of Flutter >= 2.0.1
2. Clone the code
3. `cd` into the directory
4. run `flutter pub get`
5. run `flutter run -d chrome`