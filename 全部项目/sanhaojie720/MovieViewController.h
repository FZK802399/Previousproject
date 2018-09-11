//
//  MovieViewController.h
//  BeiJing360
//
//  Created by lin yuxin on 12-2-9.
//  Copyright (c) 2012年 __ChuangYiFengTong__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MovieViewController : UIViewController {
    MPMoviePlayerController *theMovie;
}

@property (nonatomic, retain) MPMoviePlayerController *theMovie;

@end
