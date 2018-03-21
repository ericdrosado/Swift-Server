# SwiftServer [![Build Status](https://travis-ci.org/ericdrosado/Swift-Server.svg?branch=master)](https://travis-ci.org/ericdrosado/Swift-Server) 

## Project Requirements
+ Swift 4.0.3
+ Java 8 - Needed to run `cob_spec` test suite.


## Setup

### Clone Repository
`git clone https://github.com/ericdrosado/Swift-Server`

### Initialize Submodule for cob_spec
+ In the root of your local repository:
```
git submodule init
git submodule update
```

### Unpack cob_spec
+ In `cob_spec` directory
`mvn package`

### Build Server
+ In the root directory `swift package resolve` to download dependencies.
+ Still in the root `swift build` to build the project.


## Run Server

### Run on port 5000
+ In the root directory:
```swift run```

### Run with a specific port and serve from a particular directory:
+ In the root directory you can enter any of the following examples:
```
./.build/debug/main -p <port>                     //Default directory is ./public without -d
.//build/debug/main -d <directoryPath>            //Default port is 5000 without -p
./.build/debug/main -p <port> -d <directoryPath>
```


## Run tests

### Run all Tests
+ In the root directory `./run_tests.sh`.

### Run Unit Tests
+ In the root directory `swift test`.
