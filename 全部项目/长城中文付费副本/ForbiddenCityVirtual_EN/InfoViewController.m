//
//  InfoViewController.m
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-7-2.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import "InfoViewController.h"
#import "FMDatabase.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

@synthesize delegate = _delegate;


- (void)dealloc
{
    Release(_closeButton);
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithSceneTag:(NSInteger)tag
{
    if (self = [super init])
    {
        _tag = tag;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"info_bg.jpg"]];
    
    _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(kLCDH - 61, 0, 61, 56)];
    [_closeButton setImage:[UIImage imageNamed:@"phclose.png"] forState:UIControlStateNormal];
    [_closeButton setImage:[UIImage imageNamed:@"phclose_h.png"] forState:UIControlStateHighlighted];
    [_closeButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    [self.view addGestureRecognizer:tap];
    
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLCDH / 2 - 600 / 2, 70, 600, 40)];
    
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setFont:[UIFont fontWithName:kFont_Name size:24.0f]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [_titleLabel setText:@"Forbidden City Pano"];
    
    [self.view addSubview:_titleLabel];
    
    
    _info = [[UITextView alloc] initWithFrame:CGRectMake(35.0f, 130.0f, kLCDH - 35 * 2, kLCDW - 130 - 20 - 100)];
    [_info setBackgroundColor:[UIColor clearColor]];
    [_info setDelegate:self];
    _info.font = [UIFont fontWithName:kFont_Name size:22.0f];
    [self.view addSubview:_info];
    
    [self loadInfo];
    
    [_info addGestureRecognizer:tap];
    
}



- (void)loadInfo
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sceneinfos" ofType:@"db"];
    FMDatabase *db = [[FMDatabase alloc] initWithPath:path];   
    if (![db open])
    {
        NSLog(@"database can not open");
        return;
    }
    FMResultSet *results = nil;
    if ([[USER_DEFAULTS objectForKey:kCurrent_Language] intValue] == English)
    {
        results = [db executeQuery:@"select * from info_en where id = ?", [NSNumber numberWithInt:_tag]];
    }
    else
    {
        results = [db executeQuery:@"select * from info_cn where id = ?", [NSNumber numberWithInt:_tag]];
    }
    while ([results next])
    {
        _titleLabel.text = [results stringForColumn:@"title"];
        NSString *content = [results stringForColumn:@"info"];
        
        _info.text = [content stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];  
    }
    [results close];
    [db release];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

- (void)dismissSelf
{
    [_delegate performSelector:@selector(viewRelease)];
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
