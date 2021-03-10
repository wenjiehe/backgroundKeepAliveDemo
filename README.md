# backgroundKeepAliveDemo
后台保活机制

> app需要请求特殊的权限在background执行而不进入suspended状态，在iOS，只有几种特殊类型的app才允许运行在后台:

1. 在后台播放音视频类的app，比如音乐播放器
2. 在后台录音类的app
3. 需要实时通知用户坐标的app，比如导航类app
4. 支持VoIP的app
5. 需要定期下载和处理新内容的应用程序
6. 从外部配件接收定期更新的应用程序

> 注意：这些类型的app必须声明其支持的服务，并使用系统框架实现这些服务

## 后台保活方式

1. 无声音乐保活
2. 后台地理位置持续更新保活


## 调试

在xcode控制台中进行后台运行调试，使用如下命令:
> e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"TASK_IDENTIFIER"]


## 参考

1. [Downloading Files in the Background](https://developer.apple.com/documentation/foundation/url_loading_system/downloading_files_in_the_background?language=objc)
2. [Choosing Background Strategies for Your App](https://developer.apple.com/documentation/backgroundtasks/choosing_background_strategies_for_your_app?language=objc)
3. [掘金-iOS App 后台保活](https://juejin.cn/post/6844904041680470023)
4. [框架-Background Tasks](https://developer.apple.com/documentation/backgroundtasks?language=objc)
5. [VoIP官网文档](https://developer.apple.com/documentation/pushkit?language=objc)
