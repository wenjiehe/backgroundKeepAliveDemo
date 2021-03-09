//
//  OFAudioManager.h
//  backTaskDemo
//
//  Created by 贺文杰 on 2021/3/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WJAudioManager : NSObject

/// 单例
+ (instancetype)sharedIntance;
/// 是否开启后台自动播放无声音乐
@property (nonatomic, assign) BOOL  openBackgroundAudioAutoPlay;

@end

NS_ASSUME_NONNULL_END
