#!/bin/bash
set -e
swift test
cd cob_spec
mvn package
java -jar fitnesse.jar -c "PassingTestSuite?suite&format=text" 
