# SwiftServer [![Build Status](https://travis-ci.org/ericdrosado/Swift-Server.svg?branch=master)](https://travis-ci.org/ericdrosado/Swift-Server) 

### Setup
+ Clone this repository
+ Insure you have downloaded Swift to your machine. This project was built with Swift version 4.0.3.
+ In the root of your local repository:
```swift package resolve```
to download dependencies.
+ Still in the root:
```swift build```
to build the project.

### To run on port 5000:
+ In the root directory:
```swift run```

### To run with a specific port and serve from a particular directory:
+ In the root directory you can enter any of the following examples:
```
./.build/debug/main -p <port> //Default directory is ./public without -d
.//build/debug/main -d <directoryPath> //Default port is 5000 without -p
./.build/debug/main -p <port> -d <directoryPath>
```

### To run tests:
+ In the root directory:
```./run_tests.sh```

### To Interact with server:
+ Make sure to follow run instructions before proceeding.
+ Send a cURL request in a separate CLI session:
```curl 127.0.0.1:<port>/```
