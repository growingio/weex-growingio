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
- 命令行集成
```
weexpack plugin add weex-growingio
```
- 手动集成
 在相应工程的build.gradle文件的dependencies中添加
 ```
 compile '${groupId}:WeexGrowingIO:{$version}'
 ```
  注意：您需要自行指定插件的groupId和version并将构建产物发布到相应的依赖管理仓库内去（例如maven）, 您也可以对插件的name进行自定义，默认将使用插件工程的名称作为name
  
## 方法说明
1.track(event, callback)

| 参数名 | 类型 | 是否必填 | 描述 |
|-----|-----|-----|----|
| event | object | 是 | key:eventId(string类型,必要key) value:(string类型)<br> key:eventLevelVariable(string类型,非必要key) value:(object类型)<br> key:number(string类型, 非必要key) value(number类型) |
| callback | 函数 | 否 | callback {function (ret)}：执行完读取操作后的回调函数。<br>ret  为 callback 函数的参数，有两个属性:<br>result:结果2种 success, error 都为string类型<br> info:结果string类型 |

2.page(page, callback)

| 参数名 | 类型 | 是否必填 | 描述 |
|-----|-----|-----|----|
| page | string | 是 |
| callback | 函数 | 否 | callback {function (ret)}：执行完读取操作后的回调函数。<br>ret  为 callback 函数的参数，有两个属性:<br>result:结果2种 success, error 都为string类型<br> info:结果string类型 |

3.setPageVariable(page, pageLevelVariables, callback)

| 参数名 | 类型 | 是否必填 | 描述 |
|-----|-----|-----|----|
| page | string | 是 |
| pageLevelVariables | object | 是 |
| callback | 函数 | 否 | callback {function (ret)}：执行完读取操作后的回调函数。<br>ret  为 callback 函数的参数，有两个属性:<br>result:结果2种 success, error 都为string类型<br> info:结果string类型 |

4.setEvar(conversionVariables, callback)

| 参数名 | 类型 | 是否必填 | 描述 |
|-----|-----|-----|----|
| conversionVariables | object | 是 |
| callback | 函数 | 否 | callback {function (ret)}：执行完读取操作后的回调函数。<br>ret  为 callback 函数的参数，有两个属性:<br>result:结果2种 success, error 都为string类型<br> info:结果string类型 |

5.setPeopleVariable(peopleVariables, callback)

| 参数名 | 类型 | 是否必填 | 描述 |
|-----|-----|-----|----|
| peopleVariables | object | 是 |
| callback | 函数 | 否 | callback {function (ret)}：执行完读取操作后的回调函数。<br>ret  为 callback 函数的参数，有两个属性:<br>result:结果2种 success, error 都为string类型<br> info:结果string类型 |

6.setUserId(userId, callback)

| 参数名 | 类型 | 是否必填 | 描述 |
|-----|-----|-----|----|
| userId | string | 是 |
| callback | 函数 | 否 | callback {function (ret)}：执行完读取操作后的回调函数。<br>ret  为 callback 函数的参数，有两个属性:<br>result:结果2种 success, error 都为string类型<br> info:结果string类型 |

7.clearUserId(callback)

| 参数名 | 类型 | 是否必填 | 描述 |
|-----|-----|-----|----|
| callback | 函数 | 否 | callback {function (ret)}：执行完读取操作后的回调函数。<br>ret  为 callback 函数的参数，有两个属性:<br>result:结果2种 success, error 都为string类型<br> info:结果string类型 |

## JS中调用方式:
```
var gio = weex.requireModule('GrowingIO');
var trackItem = {'eventId':'123', 'eventLevelVariable':{'city':'DaLian'},' number':65};

gio.track(trackItem, function (ret) {
          var result = ret.result;
          if (result == 'success') {
            console.log('track success');
          }
        });
```

