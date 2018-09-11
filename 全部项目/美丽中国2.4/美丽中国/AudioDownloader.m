//
//  AudioDownloader.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/23.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "AudioDownloader.h"
#import "AFNetworking.h"

@interface AudioDownloader ()
{
    NSString *_url;
    NSString *_panoId;
    AudioDownloadType _audioDownloadType;
}
@end

@implementation AudioDownloader

- (id)initWithPanoID:(NSString *)panoId
{
    self = [super init];
    if (self) {
        //语音解说是否正在被下载 初始化的时候没有下载为NO
        _isAudioDownloading = NO;
        //下载语音解说
        _audioDownloadType = AUDIODOWNLOADER_AUDIO;
        //初始化下载完语音后的存储路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesPath = [paths lastObject];
        NSString *audioCachesPath = [cachesPath stringByAppendingPathComponent:@"AudioCache"];
        //如果路径audioCachesPath不存在 则创建
        if (![[NSFileManager defaultManager] fileExistsAtPath:audioCachesPath]) {
            [[NSFileManager defaultManager]
             createDirectoryAtPath:audioCachesPath
             withIntermediateDirectories:YES
             attributes:nil
             error:nil];
        }
        _audioFilePath = [audioCachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",panoId]];
        NSLog(@"语音解说存储路径 %@",_audioFilePath);

    }
    return self;
}

- (id)initWithUserID:(NSString *)userId commentOriginalTime:(NSString *)commentOriginalTime {
    self = [super init];
    if (self) {
        //评论语音是否正在被下载 初始化的时候没有下载为NO
        _isCommentAudioDownloading = NO;
        //下载语音评论
        _audioDownloadType = AUDIODOWNLOADER_COMMENT_AUDIO;
        //初始化下载完评论语音后的存储路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesPath = [paths lastObject];
        NSString *audioCachesPath = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",userId]];
        //如果路径audioCachesPath不存在 则创建
        if (![[NSFileManager defaultManager] fileExistsAtPath:audioCachesPath]) {
            [[NSFileManager defaultManager]
             createDirectoryAtPath:audioCachesPath
             withIntermediateDirectories:YES
             attributes:nil
             error:nil];
        }
        _audioFilePath = [audioCachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",commentOriginalTime]];
        NSLog(@"语音评论存储路径%@",_audioFilePath);
    }
    return self;
}

//下载语音
- (void)downloadWithUrl:(NSString *)urlString
{
    //下载开始
    if (_audioDownloadType == AUDIODOWNLOADER_AUDIO) {
        //语音解说是否正在被下载 调用downloadWithUrl方法开始下载为YES
        _isAudioDownloading = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(audioDownloaderStart)]) {
            [self.delegate audioDownloaderStart];
        }
    } else {
        //评论语音是否正在被下载 调用downloadWithUrl方法开始下载为YES
        _isCommentAudioDownloading = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(commentAudioDownloaderStart)]) {
            [self.delegate commentAudioDownloaderStart];
        }
    }
    
    //下载语音
    //初始化下载请求
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //创建一个请求操作operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //设置操作operation的输入流为下载地址
    operation.inputStream   = [NSInputStream inputStreamWithURL:url];
    //设置操作operation的输出流为存储路径
    operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:_audioFilePath append:NO];
    NSLog(@"_audioFilePath %@",_audioFilePath);
    
    //语音下载完成
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"语音下载完成");
        if (_audioDownloadType == AUDIODOWNLOADER_AUDIO) {
            //语音解说是否正在被下载 下载成功后为NO
            _isAudioDownloading = NO;
            if (self.delegate && [self.delegate respondsToSelector:@selector(audioDownloaderFinished)]) {
                [self.delegate audioDownloaderFinished];
            }
        } else {
            //评论语音是否正在被下载 下载成功后为NO
            _isCommentAudioDownloading = NO;
            if (self.delegate && [self.delegate respondsToSelector:@selector(commentAudioDownloaderFinished)]) {
                [self.delegate commentAudioDownloaderFinished];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"语音下载失败");
        if (_audioDownloadType == AUDIODOWNLOADER_AUDIO) {
            //语音解说是否正在被下载 下载成功后为NO
            _isAudioDownloading = NO;
            if (self.delegate && [self.delegate respondsToSelector:@selector(audioDownloaderFailed)]) {
                [self.delegate audioDownloaderFailed];
            }
        } else {
            //评论语音是否正在被下载 下载失败后为NO
            _isCommentAudioDownloading = NO;
            if (self.delegate && [self.delegate respondsToSelector:@selector(commentAudioDownloaderFailed)]) {
                [self.delegate commentAudioDownloaderFailed];
            }
        }
    }];
    
    //请求操作开始执行
    [operation start];

}

//- (void)cancelAudioDownloader
//{
//    isLoading = NO;
//    if (audioRequest) {
//        [audioRequest cancel];
//        audioRequest.delegate = nil;
//    }
//    NSLog(@"音频下载取消");
//}


@end
