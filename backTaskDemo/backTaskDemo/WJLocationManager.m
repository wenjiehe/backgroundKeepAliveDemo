//
//  WJLocationManager.m
//  backTaskDemo
//
//  Created by 贺文杰 on 2021/3/9.
//

#import "WJLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface WJLocationManager ()<CLLocationManagerDelegate>

@property(nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic, strong) NSTimer * timer;
/// 后台运行时间
@property (nonatomic, assign) NSInteger  backgroundTimeLength;

@end

@implementation WJLocationManager

+ (instancetype)sharedIntance{
    static WJLocationManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WJLocationManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setupListener];
        [self startLocation];
    }
    return self;
}

// MARK: app进入后台
- (void)applicationDidEnterBackground:(NSNotification *)notify{
    [self startTimer];
}

// MARK: app开始进入前台
- (void)applicationDidBecomeActive:(NSNotification *)notify{
    // 进入前台,暂停播放音乐
    [self removeTimer];
    self.backgroundTimeLength = 0;
}

- (void)timerRun:(NSTimer *)timer{
    self.backgroundTimeLength++;
    NSLog(@"backgroundTimeLength = %ld", self.backgroundTimeLength);
    // 超过300秒, 退出播放
    if (self.backgroundTimeLength > 300) {
        [self removeTimer];
        self.backgroundTimeLength = 0;
    }
}

// 设置监听者
- (void)setupListener{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)startTimer{
    if (self.timer == nil) {
        self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)removeTimer{
    if (self.timer) {
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)startLocation
{
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    @try {
        self.locationManager.allowsBackgroundLocationUpdates = YES;
    } @catch (NSException *exception) {
        NSLog(@"异常:%@", exception);
    } @finally {
        
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations API_AVAILABLE(ios(6.0), macos(10.9))
{
    if (locations.count > 0) {
        CLLocation *loc = locations[0];
        NSLog(@"更新地理位置 latitude = %.f, longitude = %.f", loc.coordinate.latitude, loc.coordinate.longitude);
    }else{
        NSLog(@"没有获取到地理位置");
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didFailWithError:(NSError *)error
{
    NSLog(@"error = %@", error);
}

@end
