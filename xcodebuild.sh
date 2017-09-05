
#自动打包（需在项目中配置好描述文件、开发者证书）
#使用方式:
#将xcodebuild.sh中appName置换为项目工程名
#将文件放置于项目文件中和*.xcodeproj平级
#在终端中进入*.xcodeproj上级目录
#输入`./xcodebuild.sh`即可自动打包、如无执行权限则先执行`chmod +x xcodebuild.sh`

code_sign_identity="iPhone Distribution: Dabai Global Technology Co.,Ltd (8U489QFL4J)"

provisioning_profile="b5bdd25c-6f8e-421e-ab36-6126c0b025a8"

#工程名
project_name=VideoDemo

#打包模式 Debug/Release
development_mode=Release

#scheme名
scheme_name=VideoDemo

#plist文件所在路径
exportOptionsPlistPath=./AppStoreExportOptions.plist

#导出.ipa文件所在路径
exportFilePath=~/Desktop/${project_name}-ipa

echo '*** 正在 清理工程 ***'
xcodebuild \
clean -scheme ${scheme_name} -configuration Release
echo '*** 清理完成 ***'


echo '*** 正在 编译工程 For '${development_mode}
xcodebuild \
archive -scheme ${scheme_name} \
-configuration ${development_mode} \
-archivePath build/${project_name}.xcarchive \
CODE_SIGN_IDENTITY="${code_sign_identity}" \
PROVISIONING_PROFILE="${provisioning_profile}"
echo '*** 编译完成 ***'


echo '*** 正在 打包 ***'
xcodebuild -exportArchive -archivePath build/${project_name}.xcarchive \
-configuration ${development_mode} \
-exportPath ${exportFilePath} \
-exportOptionsPlist ${exportOptionsPlistPath}

# 删除build包
if [[ -d build ]]; then
rm -rf build -r
fi

if [ -e $exportFilePath/$scheme_name.ipa ]; then
echo "*** .ipa文件已导出 ***"
cd ${exportFilePath}
echo "*** 开始上传.ipa文件 ***"
#此处上传分发应用
echo "*** .ipa文件上传成功 ***"
else
echo "*** 创建.ipa文件失败 ***"
fi
echo '*** 打包完成 ***'
