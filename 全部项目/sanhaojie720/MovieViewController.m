//
//  MovieViewController.m
//  BeiJing360
//
//  Created by lin yuxin on 12-2-9.
//  Copyright (c) 2012年 __ChuangYiFengTong__. All rights reserved.
//

#import "MovieViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation MovieViewController
@synthesize theMovie;

-(void)dealloc {
    [theMovie release];
    [super dealloc];
    
}

-(void)myMovieFinishedCallback:(NSNotification*)aNotification {

    MPMoviePlayerController *theMovie1 = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie1];
   // [theMovie1 stop];
   // [theMovie stop];
    //[theMovie1 release];
 }


-(void)video_play{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Miniature" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
    theMovie = [[MPMoviePlayerController alloc] initWithContentURL:url];
    theMovie.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //theMovie.controlStyle = MPMovieControlStyleNone;
    theMovie.scalingMode = MPMoviePlaybackStatePlaying;
   // [theMovie setFullscreen:NO animated:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:theMovie];
    [theMovie prepareToPlay];
    [theMovie.view setFrame:self.view.bounds];
    theMovie.Fullscreen = YES;
    [self.view addSubview:theMovie.view];
    [theMovie play];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self video_play];
    [self.navigationController setNavigationBarHidden:NO
                                             animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated {
    if (theMovie != Nil)
        [theMovie stop];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"三好街视频简介";
    self.navigationController.navigationBar.backItem.leftBarButtonItem.title=@"关闭";
    //[self video_play];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidUnload
{   
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
