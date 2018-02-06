#!/bin/bash

swift run &
PID=$!
cd cob_spec
mvn package
java -jar fitnesse.jar -c 'PassingTestSuite?suite&format=text'
kill -9 $PID
