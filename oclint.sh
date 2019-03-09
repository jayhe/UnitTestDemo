#!/bin/bash -il
#CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO ENABLE_BITCODE=NO
#rc Override the default behavior of rules
myworkspace=UnitTestDemo.xcworkspace
myscheme=UnitTestDemo
xcodebuild -workspace $myworkspace -scheme $myscheme clean&&
xcodebuild -workspace $myworkspace -scheme $myscheme \
-configuration Debug CLANG_ENABLE_MODULE_DEBUGGING=NO COMPILER_INDEX_STORE_ENABLE=NO \
| xcpretty -r json-compilation-database -o compile_commands.json&&
oclint-json-compilation-database -e Pods -- \
-report-type pmd -o oclint_result.xml \
-rc LONG_LINE=300 \
-rc LONG_METHOD=200 \
-rc LONG_VARIABLE_NAME=40 \
-rc LONG_Class=3000 \
-max-priority-1=100 \
-max-priority-2=100 \
-max-priority-3=200 \
-disable-rule=UnusedMethodParameter \
-disable-rule=AvoidPrivateStaticMembers \
-allow-duplicated-violations=false \
-enable-clang-static-analyzer=false \
-list-enabled-rules=true; \
rm compile_commands.json;
if [ -f ./oclint_result.xml ]; 
then echo 'done'
else echo "failed";
fi