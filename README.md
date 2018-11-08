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
- **(optional)** GrowingIO推荐您添加**AdSupport.framework**依赖库,用于来源管理激活匹配,有利于您更好的分析的数据,添加项目依赖库的位置在项目设置target -> 选项卡General -> Linked Frameworks and Libraries
##### [添加官网配置(步骤5,6,8)](https://docs.growingio.com/sdk-ji-cheng/sdk-1.x-wen-dang/sdk-1.x-jie-ru-zhi-nan/sdk-jie-ru-zhi-nan-ios.html)

## 安卓集成插件WeexGrowingIO
### 导入SDK
- 命令行集成
```
weexpack plugin add weex-growingio
```
- 手动集成
在相应工程的build.gradle文件的dependencies中添加
```
compile 'com.growingio.android:vds-weex:0.3'
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
            .setChannel("XXX应用商店")
            .setDebugMode(true));  // 打开调试日志, 线上环境请关闭
	
  }
}
```
具体函数含义请参见: [官网Android集成文档](https://docs.growingio.com/sdk-20/sdk-20-api-wen-dang/android-sdk-21-an-zhuang.html)
## 方法说明
1.track(event)

| 参数名 | 类型 | 是否必填 | 参数描述 |
|-----|-----|-----|----|
| event | Object | 是 | event 为 JsonObject，它的 key 必须为以下名称：<br> key:eventId(string类型,必要key,限制合法值为大小写字母、数字和下划线，并且不能以数字开头) value:(string类型)<br> key:eventLevelVariable(string类型,非必要key) value:(object类型)<br> key:number(string类型, 非必要key) value(number类型) <br> |  

示例：  
1. gio.track({'eventId':'trackTest'});
2. gio.track({'eventId':'Test','number':65});
3. gio.track({'eventId':'Test','number':65,'eventLevelVariable':{'city':'dalian'}});   


2.setEvar(conversionVariables)

| 参数名 | 类型 | 是否必填 | 参数描述 |
|-----|-----|-----|----|
| conversionVariables | Object | 是 | key 长度限制50以内 |

示例：
gio.setEvar({'name':'TestGrowingIO_123'});  


3.setPeopleVariable(peopleVariables)

| 参数名 | 类型 | 是否必填 | 参数描述 |
|-----|-----|-----|----|
| peopleVariables | Object | 是 | key 长度限制50以内 |

示例：
gio.setPeopleVariable({'name':'Test','number':65});  


4.setUserId(userId)

| 参数名 | 类型 | 是否必填 | 参数描述 |
|-----|-----|-----|----|
| userId | string | 是 | 长度限制1000 |

示例：
gio.setUserId('growingio');  


5.clearUserId()

示例：
gio.clearUserId();  

6.setVisitor(visitorVariables)
| 参数             | 类型   | 是否必填 | 参数描述          |
| ------           | -----  | -----    | ------            |
| visitorVariables | Object | 是       | key长度限制50以内 |

示例: 
gio.setVisitor({'eventId':'trackTest');  

## JS中调用方式:
```
var gio = weex.requireModule('GrowingIO');
var trackItem = {'eventId':'123', 'eventLevelVariable':{'city':'DaLian'},' number':65};

gio.track(trackItem);
```

