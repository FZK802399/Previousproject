//
//  AudioDownloader.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/23.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    AUDIODOWNLOADER_AUDIO,
    AUDIODOWNLOADER_COMMENT_AUDIO,
} AudioDownloadType;

@protocol AudioDownloaderDelegate <NSObject>

//语音解说下载的代理方法
- (void)audioDownloaderStart;
- (void)audioDownloaderFinished;
- (void)audioDownloaderFailed;

//语音评论下载的代理方法
- (void)commentAudioDownloaderStart;
- (void)commentAudioDownloaderFinished;
- (void)commentAudioDownloaderFailed;

@end

@interface AudioDownloader : NSObject

@property (nonatomic, strong) NSString *audioFilePath;//语音存储地址
@property (nonatomic, assign) BOOL isCommentAudioDownloading;//评论语音是否正在被下载
@property (nonatomic, assign) BOOL isAudioDownloading;//语音解说是否正在被下载
@property (nonatomic, assign) id delegate;


- (id)initWithPanoID:(NSString *)panoId;

- (id)initWithUserID:(NSString *)userId commentOriginalTime:(NSString *)commentOriginalTime;


//下载
- (void)downloadWithUrl:(NSString *)urlString;

@end
