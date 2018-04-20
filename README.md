# weex-growingio
weex-growingio是GrowingIO对于Weex平台的打点插件，可以通过weexpack快速集成

支持的WeexSDK版本： >= 0.16.0

# 功能

# 快速使用
- 通过weexpack初始化一个测试工程 weextest
```
weex create weextest
```
- 添加ios平台
```
weex platform add ios
```
- 添加android平台
```
weex platform add android
```
- 添加插件
```
weex plugin add weex-growingio
```
# 项目地址
[github](https://github.com/growingio/weex-growingio)

# 已有工程集成
## iOS集成插件WeexGrowingIO
- 命令行集成
```
weex plugin add weex-growingio
```
- 手动集成
在podfile 中添加
```
pod 'WeexGrowingIO'
```
- 命令行输入
```
pod update
```
##### [添加官网配置(步骤5,6,8)](https://docs.growingio.com/sdk-20/sdk-20-api-wen-dang/ios-sdk-21-an-zhuang.html)

## 安卓集成插件WeexGrowingIO
### 导入SDK
- 命令行集成
```
weexpack plugin add weex-growingio
```
- 手动集成
在相应工程的build.gradle文件的dependencies中添加
```
compile 'com.growingio.android:vds-weex:0.0.1'
```

### 初始化SDK
首先需要配置build.gradle, 在android-> defaultConfig添加以下属性
``` 
android {
    defaultConfig {
        resValue("string", "growingio_project_id", "您的项目ID")
        resValue("string", "growingio_url_scheme", "您的URL Scheme")
    }
}
```

请将以下GrowingIO.startWithConfiguration加入到您的Application的onCreate方法中
``` java
public class WXApplication extends Application {

  @Override
  public void onCreate() {
    ...
	// 如果是手动集成的SDK， 需要手动注册
	// WXSDKEngine.registerModule("GrowingIO", WeexGrowingioModule.class)	
	
	GrowingIO.startWithConfiguration(this, new Configuration()
            .useID()
            .setRnMode(true)              // weex必须设置这个属性
            .setChannel("XXX应用商店")
            .setDebugMode(true));  // 打开调试日志
	
  }
}
```
具体函数含义请参见: [官网Android集成文档](https://docs.growingio.com/sdk-20/sdk-20-api-wen-dang/android-sdk-21-an-zhuang.html)
## 方法说明
1.track(event)

| 参数名 | 类型 | 是否必填 | 描述 |
|-----|-----|-----|----|
| event | object | 是 | key:eventId(string类型,必要key) value:(string类型)<br> key:eventLevelVariable(string类型,非必要key) value:(object类型)<br> key:number(string类型, 非必要key) value(number类型) |

2.page(page)

| 参数名 | 类型 | 是否必填 | 描述 |
|-----|-----|-----|----|
| page | string | 是 |

3.setPageVariable(page, pageLevelVariables)

| 参数名 | 类型 | 是否必填 | 描述 |
|-----|-----|-----|----|
| page | string | 是 |
| pageLevelVariables | object | 是 |

4.setEvar(conversionVariables)

| 参数名 | 类型 | 是否必填 | 描述 |
|-----|-----|-----|----|
| conversionVariables | object | 是 |

5.setPeopleVariable(peopleVariables)

| 参数名 | 类型 | 是否必填 | 描述 |
|-----|-----|-----|----|
| peopleVariables | object | 是 |

6.setUserId(userId)

| 参数名 | 类型 | 是否必填 | 描述 |
|-----|-----|-----|----|
| userId | string | 是 |

7.clearUserId()


## JS中调用方式:
```
var gio = weex.requireModule('GrowingIO');
var trackItem = {'eventId':'123', 'eventLevelVariable':{'city':'DaLian'},' number':65};

gio.track(trackItem);
```

