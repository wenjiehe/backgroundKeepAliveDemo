//
//  OFAudioManager.m
//  backTaskDemo
//
//  Created by 贺文杰 on 2021/3/8.
//
#import <AVFoundation/AVFoundation.h>
#import "WJAudioManager.h"
#import <UIKit/UIKit.h>

@interface WJAudioManager()<AVAudioPlayerDelegate>
/// 播放会话
@property (nonatomic, strong) AVAudioSession * audioSession;
/// 背景播放器
@property (nonatomic, strong) AVAudioPlayer * backgroundAudioPlayer;
/// 后台运行时间
@property (nonatomic, assign) NSInteger  backgroundTimeLength;
/// timer
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation WJAudioManager


#pragma mark --------Notifications--------
+ (instancetype)sharedIntance{
    static WJAudioManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WJAudioManager alloc] init];
    });
    return instance;
}

// MARK: app进入后台
- (void)applicationDidEnterBackground:(NSNotification *)notify{
    [self startTimer];
    if (self.openBackgroundAudioAutoPlay) {
        NSError *error = nil;
        // 激活会话, 开始播放音乐
        [self.audioSession setActive:YES error:&error];
        if (!error) {
            [self.backgroundAudioPlayer prepareToPlay];
            [self.backgroundAudioPlayer play];
        }else{
            NSLog(@"播放失败");
        }
    }
}

// MARK: app开始进入前台
- (void)applicationDidBecomeActive:(NSNotification *)notify{
    // 进入前台,暂停播放音乐
    [self removeTimer];
    self.backgroundTimeLength = 0;
    
    if (!self.openBackgroundAudioAutoPlay) {
        return;
    }
    
    [self.backgroundAudioPlayer pause];
    [self.audioSession setActive:NO error:nil];
}

// MARK: 声音被打断
- (void)audioSessionInterruption:(NSNotification *)notify{
    if (!self.openBackgroundAudioAutoPlay) {
        return;
    }
    NSDictionary *userInfo = notify.userInfo;
    if ([userInfo isKindOfClass:[NSDictionary class]]) {
        NSNumber * interruptionTypeNumber = userInfo[AVAudioSessionInterruptionTypeKey];
        if (interruptionTypeNumber) {
            AVAudioSessionInterruptionType interruptionType = interruptionTypeNumber.integerValue;
            if (interruptionType == AVAudioSessionInterruptionTypeBegan) {
                // 中断开始, 音乐被打断
            }
            else if(interruptionType == AVAudioSessionInterruptionTypeEnded){
                // 中断结束, 音乐继续
                if (!self.backgroundAudioPlayer.isPlaying) {
                    [self.audioSession setActive:YES error:NULL];
                    [self.backgroundAudioPlayer prepareToPlay];
                    [self.backgroundAudioPlayer play];
                }
            }
        }
    }
}

- (instancetype)init{
    if (self = [super init]) {
        // 设置
        self.audioSession = [AVAudioSession sharedInstance];
        
        [self setupListener];
    }
    return self;
}

// 设置监听者
- (void)setupListener{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterruption:) name:AVAudioSessionInterruptionNotification object:nil];
}

// MARK: 配置会话
- (void)setupAudioSession{
    if ([self.audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:NULL]) {
        [self.audioSession setActive:NO error:NULL];
    }
}

// MARK: 配置音乐播放器
- (void)setupBackgroundAudioPlayer{
    // FIXME: 填写无声音乐的路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"silence" ofType:@"mp3"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    if (self.backgroundAudioPlayer == nil) {
        self.backgroundAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
    }
    
    self.backgroundAudioPlayer.numberOfLoops = -1;
    self.backgroundAudioPlayer.volume = 1;
    self.backgroundAudioPlayer.delegate = self;
    
}

- (void)setOpenBackgroundAudioAutoPlay:(BOOL)openBackgroundAudioAutoPlay{
    _openBackgroundAudioAutoPlay = openBackgroundAudioAutoPlay;
    if (openBackgroundAudioAutoPlay) {
        // 设置会话
        [self setupAudioSession];
        // 设置背景播放器
        [self setupBackgroundAudioPlayer];
    }
    else{
        // 关闭后台播放音乐
        if (self.backgroundAudioPlayer && self.backgroundAudioPlayer.isPlaying) {
            [self.backgroundAudioPlayer stop];
        }
        self.backgroundAudioPlayer = nil;
        // 设置激活状态为NO
        [self.audioSession setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:NULL];
    }
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

- (void)timerRun:(NSTimer *)timer{
    self.backgroundTimeLength++;
    NSLog(@"backgroundTimeLength = %ld", self.backgroundTimeLength);
    // 超过300秒, 退出播放
    if (self.backgroundTimeLength > 300) {
        [self stopBackMode];
    }
}

// MARK: 退出后台常驻模式
- (void)stopBackMode{
    [self removeTimer];
    self.backgroundTimeLength = 0;
    if (!self.openBackgroundAudioAutoPlay) {
        return;
    }
    [self.backgroundAudioPlayer pause];
    [self.audioSession setActive:NO error:nil];
}


#pragma mark --------AVAudioDelegate--------
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    // TODO: 播放完成
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    // TODO: 编码类型
}

@end
