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

### To run with a specific port:
+ In the root directory enter the following with a port number:
```./.build/debug/main <port>```

### To run tests:
+ In the root directory:
```./run_tests.sh```

### To Interact with server:
+ Make sure to follow run instructions before proceeding.
+ Send a cURL request in a separate CLI session:
```curl 127.0.0.1:3333/```
