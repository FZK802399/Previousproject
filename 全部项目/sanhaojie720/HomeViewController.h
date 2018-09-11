//
//  HomeViewController.h
//  BeiJing360
//
//  Created by baobin on 11-5-23.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SubHomeViewController;
@class TextViewController;
@class PhotoViewController;
@class MovieViewController;

@interface HomeViewController : UIViewController {
	
	//tag 1~9;
	UIButton				*btn1, *btn2, *btn3, *btn4, *btn5, *btn6, *btn7, *btn8;
    SubHomeViewController    *placesOfInterestViewController, *parkPlaceViewController, *beijingLocationViewController,
							 *cultureCustomsViewController;
    TextViewController *txtViewController;
    PhotoViewController *photoViewController;
    MovieViewController *movieViewController;
    
}

@property (nonatomic, retain) UIButton				*btn1, *btn2, *btn3, *btn4, *btn5, *btn6, *btn7, *btn8;
@property (nonatomic, retain) SubHomeViewController *placesOfInterestViewController, *parkPlaceViewController                           
                                                    , *beijingLocationViewController, *cultureCustomsViewController;
@property (nonatomic, retain) TextViewController *txtViewController;
@property (nonatomic, retain) PhotoViewController *photoViewController;
@property (nonatomic, retain) MovieViewController *movieViewController;

-(IBAction)showAbout:(id)sender;

@end
