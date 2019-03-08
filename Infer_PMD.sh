# import path
export PYTHONIOENCODING=UTF-8
export LC_CTYPE=en_US.UTF-8
export PATH=${PATH}:/usr/local/bin
# import what we have in bash_profile
if [[ -e ~/.bash_profile ]]; then
	echo "source bash_profile"
 	source ~/.bash_profile
fi

if [[ -e ~/.zshrc ]]; then
	echo "source zshrc"
	source ~/.zshrc
fi

# infer
tempPath=""
target_name=$1
project_scheme=$2
analyze_type=$3
workspace_name=""
project_name=""

if [[ ${#target_name} == 0 ]]; then
	echo "Error: Project or workspace name cannot be null"
	exit
fi

if [[ ${#project_scheme} == 0 ]]; then
	echo "Error: Sheme cannot be null"
	exit
fi

if [[ ${#project_name} == 0 ]]; then
	project_name=`find . -type d -name "${target_name}.xcodeproj" -depth 1`
fi

if [[ ${#workspace_name} == 0 ]]; then
	workspace_name=`find . -type d -name "${target_name}.xcworkspace" -depth 1`
fi

if [[ analyze_type == 0 ]]; then
	analyze_type = 1
fi

# 普通模式
if [[ ${analyze_type} == 1 ]];then
    echo "清除infer-out"
    rm -rf infer-out

	echo "开始执行编译"
	echo "Clean Project"
	#使用workspace
	if [[ ${#workspace_name} > 0 ]]; then
		echo "use xcworkspace"
		# https://github.com/facebook/infer/issues/939
		xcodebuild -workspace ${target_name}.xcworkspace -scheme ${project_scheme} -configuration Debug -sdk iphonesimulator COMPILER_INDEX_STORE_ENABLE=NO clean build | tee xcodebuild.log
		xcpretty -r json-compilation-database -o compile_commands.json < xcodebuild.log
		infer run --compilation-database compile_commands.json --keep-going --pmd-xml
		# old way
		# xcodebuild -workspace ${target_name}.xcworkspace -configuration Debug -scheme ${project_scheme} -arch "armv7" ONLY_ACTIVE_ARCH=YES VALID_ARCHS="armv7" clean
		# infer --pmd-xml --keep-going --no-xcpretty -- xcodebuild -workspace ${target_name}.xcworkspace -configuration 'Debug' -scheme ${project_scheme} -arch "armv7" ONLY_ACTIVE_ARCH=YES VALID_ARCHS="armv7" clean build
	else
		echo "use xcodeproj"
		# https://github.com/facebook/infer/issues/939
		xcodebuild -workspace ${target_name}.xcodeproj -scheme ${project_scheme} -configuration Debug -sdk iphonesimulator COMPILER_INDEX_STORE_ENABLE=NO clean build | tee xcodebuild.log
		xcpretty -r json-compilation-database -o compile_commands.json < xcodebuild.log
		infer run --compilation-database compile_commands.json --keep-going --pmd-xml
		# old way
		# xcodebuild -workspace ${target_name}.xcodeproj -configuration Debug -scheme ${project_scheme} -arch "armv7" ONLY_ACTIVE_ARCH=YES VALID_ARCHS="armv7" clean
		# infer --pmd-xml --keep-going --no-xcpretty -- xcodebuild -project ${target_name}.xcodeproj -configuration 'Debug' -scheme ${project_scheme} -arch "armv7" ONLY_ACTIVE_ARCH=YES VALID_ARCHS="armv7" clean build
	fi
#增量模式
else
	current_branch=`git symbolic-ref --short -q HEAD`	
	# get list of changed files
	git diff --name-only ${current_branch} origin/develop > diffsIndex.txt
	## first run: feature branch
	# run infer on the feature branch
	# infer capture -- make -j 4  # assuming a machine with 4 cores
	# infer analyze --changed-files-index diffsIndex.txt
	# # store the infer report
	# cp infer-out/report.json report-feature.json
	# ## second run: master branch
	# git checkout develop
	# # run capture in reactive mode so that previously-captured source files are kept if they are up-to-date
	# infer capture --reactive -- make -j 4
	# infer analyze --reactive --changed-files-index diffsIndex.txt
	# # compare reports
	# infer reportdiff --report-current report-feature.json --report-previous infer-out/report.json
	# git checkout current_branch

	echo "开始执行编译"
	#使用workspace
	if [[ ${#workspace_name} > 0 ]]; then
		# xcodebuild -workspace ${target_name}.xcworkspace -configuration Debug -sdk iphonesimulator -scheme ${project_scheme} -arch "armv7" ONLY_ACTIVE_ARCH=YES VALID_ARCHS="armv7"
		# infer --pmd-xml --reactive --keep-going --no-xcpretty --changed-files-index diffsIndex.txt -- xcodebuild -workspace ${target_name}.xcworkspace -configuration 'Debug' -sdk 'iphonesimulator' -scheme ${project_scheme} -arch "x86_64" ONLY_ACTIVE_ARCH=YES VALID_ARCHS="armv7 x86_64"
		echo "use xcworkspace"
		infer --reactive --keep-going --no-xcpretty -- xcodebuild -workspace ${target_name}.xcworkspace -configuration 'Debug' -scheme ${project_scheme} -arch "armv7" ONLY_ACTIVE_ARCH=YES VALID_ARCHS="armv7"
		infer analyze --pmd-xml --reactive --changed-files-index diffsIndex.txt
	else
		# xcodebuild -workspace ${target_name}.xcodeproj -configuration Debug -sdk iphonesimulator -scheme ${project_scheme} -arch "armv7" ONLY_ACTIVE_ARCH=YES VALID_ARCHS="armv7"
		# infer --pmd-xml --reactive --keep-going --no-xcpretty --changed-files-index diffsIndex.txt -- xcodebuild -project ${target_name}.xcodeproj -configuration 'Debug' -sdk 'iphonesimulator' -scheme ${project_scheme} -arch "x86_64" ONLY_ACTIVE_ARCH=YES VALID_ARCHS="armv7 x86_64"
		echo "use xcodeproj"
		infer --reactive --keep-going --no-xcpretty -- xcodebuild -workspace ${target_name}.xcodeproj -configuration 'Debug' -scheme ${project_scheme} -arch "armv7" ONLY_ACTIVE_ARCH=YES VALID_ARCHS="armv7" 
		infer analyze --pmd-xml --reactive --changed-files-index diffsIndex.txt
	fi

	echo "删除临时文件"
	rm -rf diffsIndex.txt
fi

exit
