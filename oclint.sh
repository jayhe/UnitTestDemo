#!/bin/bash -il

#CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO ENABLE_BITCODE=NO

myworkspace=UnitTestDemo.xcworkspace
myscheme=UnitTestDemo
xcodebuild -workspace $myworkspace -scheme $myscheme clean&&
xcodebuild -workspace $myworkspace -scheme $myscheme \
-configuration Debug CLANG_ENABLE_MODULE_DEBUGGING=NO COMPILER_INDEX_STORE_ENABLE=NO \
| xcpretty -r json-compilation-database -o compile_commands.json&&
oclint-json-compilation-database -e Pods -- \
-report-type html -o oclint_result.html \
-rc LONG_LINE=200 \
-max-priority-1=100000 \
-max-priority-2=100000 \
-max-priority-3=100000; \
rm compile_commands.json;
if [ -f ./oclint_result.html ]; 
then echo 'done'
else echo "failed";
fi