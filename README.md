# flickrtest

Requires Xcode 8. To install:

```
git clone https://github.com/cbh2000/flickrtest.git
cd flickrtest

# Only required if Xcode 7 is your default. The default Xcode must be Xcode 8 or else carthage bootstrap might fail.
sudo xcode-select --switch /Applications/Xcode\ 8.app/

carthage bootstrap --platform iOS # Requires Carthage 0.18 or newer: https://github.com/Carthage/Carthage/releases

open FlickrTest.xcodeproj
```
