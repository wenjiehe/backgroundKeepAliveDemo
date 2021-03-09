//
//  SceneDelegate.m
//  backTaskDemo
//
//  Created by 贺文杰 on 2021/3/8.
//

#import "SceneDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "WJAudioManager.h"
#import "WJLocationManager.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//    _isBackPlay = NO;
//    [OFAudioManager sharedIntance].openBackgroundAudioAutoPlay = YES;
    [WJLocationManager sharedIntance];
    NSLog(@"重新打开app %s ", __FUNCTION__);
}

//当场景与app断开连接是调用（注意，以后它可能被重新连接）
- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    NSLog(@"%s ", __FUNCTION__);
}

//当用户开始与场景进行交互（例如从应用切换器中选择场景）时，会调用
- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    NSLog(@"%s ", __FUNCTION__);
}

//当用户停止与场景交互（例如通过切换器切换到另一个场景）时调用
- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    NSLog(@"%s 即将进入后台", __FUNCTION__);
}

//当场景变成活动窗口时调用，即从后台状态变成开始或恢复状态
- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
    NSLog(@"%s 后台状态变成开始或恢复状态", __FUNCTION__);
}

//当场景进入后台时调用，即该应用已最小化但仍存活在后台中
- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    NSLog(@"%s 进入后台", __FUNCTION__);
}





@end
