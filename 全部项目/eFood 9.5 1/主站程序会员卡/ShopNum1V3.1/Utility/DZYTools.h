//
//  DZYTools.h
//  支付宝测试
//
//  Created by yons on 15/12/2.
//  Copyright (c) 2015年 ShopNum1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define DZYWIDTH   [UIScreen mainScreen].bounds.size.width

#define DZYHEIGHT  [UIScreen mainScreen].bounds.size.height

/*
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

///主题红
#define MYRED [UIColor colorWithRed:239.0/255.0 green:45.0/255.0 blue:48.0/255.0 alpha:1]
///字体黑
#define FONT_BLACK [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]
///字体浅灰
#define FONT_LIGHTGRAY [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]
///字体深灰
#define FONT_DARKGRAY [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]
///背景灰
#define BACKGROUND_GRAY [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1]
///分割线浅灰
#define LINE_LIGHTGRAY [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1]
///分割线深灰
#define LINE_DARKGRAY [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1]
*/

@interface DZYTools : NSObject
///提示
+(void)showMessageWithStr:(NSString *)string;
///获取大小
+(CGSize )getSizeWithString:(NSString *)string FontNum:(CGFloat )num;
///加入购物车效果
+(void)addShopCartFromGoods:(UIImageView *)Goods ToCart:(UIImageView *)Cart;
///获取单个文件的大小
+(float)fileSizeAtPath:(NSString *)path;
///获取文件夹的大小
+(float)folderSizeAtPath:(NSString *)path;
///清空文件夹
+(void)clearCache:(NSString *)path;
///截图
+(UIImage *)getImageWithView:(UIView*)view;
///创建数据库 并插入数据
+(void)createTableWithName:(NSString *)Name andInsertJSON:(id)JSON DB:(FMDatabase *)DB;
///从数据库读取数据
+(NSDictionary *)loadDictWithName:(NSString *)Name DB:(FMDatabase *)DB;
@end



#pragma mark - DZYImageView 可点击imgView

@class DZYImageView;
@protocol DZYImageViewDelegate <NSObject>

-(void)DZYImageViewDidClickWith:(DZYImageView *)DZYImageView;

@end

@interface DZYImageView : UIImageView
@property (nonatomic,weak)id<DZYImageViewDelegate>delegate;
+(DZYImageView *)DZYImageViewWithFrame:(CGRect )frame Img:(UIImage*)img;
@end

#pragma mark - 笔记

 
#pragma mark - UINavigationBar 标题的颜色
 /*
 eg:
 self.title=@"微信";
 [self.navigationController.navigationBar setTitleTextAttributes:
 @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
 */

#pragma mark - UINavigationBar 添加系统自带按钮时可以设置其颜色
/*
eg:
UIBarButtonItem *rightBtn =
[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
[rightBtn setTintColor:[UIColor whiteColor]];
self.navigationItem.rightBarButtonItem=rightBtn;
*/

#pragma mark - 获取版本号
/*
//获取版本号  [[[UIDevice currentDevice] systemVersion] floatValue]
if (kCurrentSystemVersion >= 7.0) {
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}else{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"segmented_bg.png"] forBarMetrics:UIBarMetricsDefault];
}
*/

#pragma mark - 关联
/*
5. 关联  import <objc/runtime.h>

objc_setAssociatedObject              //添加关联
objc_getAssociatedObject              //获取关联
objc_removeAssociatedObjects          //断开所有关联

//objc_removeAssociatedObjects很少使用  一般使用set方法来断开一个关联
断开关联是使用objc_setAssociatedObject函数，传入nil值即可。
//这样就断开了overviewKey 关键字的关联
objc_setAssociatedObject(array, &overviewKey, nil, OBJC_ASSOCIATION_ASSIGN);
其中，被关联的对象为nil，此时关联策略也就无关紧要了。

objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)

1.被关联的对象，下面举的例子中关联到了UIAlertView
2.要关联的对象的键值，一般设置成静态的，用于获取关联对象的值
3.要关联的对象的值，从接口中可以看到接收的id类型，所以能关联任何对象
4.关联时采用的协议，有assign，retain，copy等协议，具体可以参考官方文档

eg:
1. 第一步

static char kUITableViewIndexKey;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ......
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"这里是xx楼"
                                                   delegate:self
                                          cancelButtonTitle:@"好的"
                                          otherButtonTitles:nil];
    //然后这里设定关联，此处把indexPath关联到alert上
    objc_setAssociatedObject(alert, &kUITableViewIndexKey, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [alert show];
}

2.第二步：
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSIndexPath *indexPath = objc_getAssociatedObject(alertView, &kUITableViewIndexKey);
        NSLog(@"%@", indexPath);
    }
}
*/

#pragma mark - 设置状态栏颜色
/*
 1. 设置状态栏颜色
 info.plist文件 添加  View controller-based status bar appearance 设置为NO
 
 //appdelegate 中添加代码 (添加到appdelegate中则app中全部为白色了)
 [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
*/

#pragma mark - 控件发送消息 (执行事件)
/*
 2. 代码让控件执行相关事件
 [self.btn sendActionsForControlEvents:UIControlEventTouchUpInside];
*/

#pragma mark - 视图位置交换 (层级)
/*
 5. 一个视图的两个子视图 图层位置对换 配合动画效果
 
 CATransition *trans=[CATransition animation];
 trans.type=@"cube";
 trans.subtype=kCATransitionFromRight;  //翻页动画的开始位置
 trans.duration=1;
 trans.timingFunction = UIViewAnimationCurveEaseInOut;
 [self.mainView.layer addAnimation:trans forKey:nil];
 
 NSInteger red = [[self.mainView subviews] indexOfObject:[self.mainView viewWithTag:1]];
 NSInteger yellow = [[self.mainView subviews] indexOfObject:[self.mainView viewWithTag:2]];
 [self.mainView exchangeSubviewAtIndex:red withSubviewAtIndex:yellow];
*/

#pragma mark - 数据排序
/*
 6. NSArray 排序 (value为数值时)
 
 -(NSArray *)sortedArrWith:(NSArray *)arr
 {
 NSArray * newArr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
 if ([obj1 integerValue] > [obj2 integerValue]) {
 return (NSComparisonResult)NSOrderedDescending;
 }
 
 if ([obj1 integerValue] < [obj2 integerValue]) {
 return (NSComparisonResult)NSOrderedAscending;
 }
 return (NSComparisonResult)NSOrderedSame;
 }];
 return newArr;
 }
*/

#pragma mark - placeholder 颜色的修改
/*
 9. placeholder 颜色的修改
 [self.key setValue:FONT_LIGHTGRAY forKeyPath:@"_placeholderLabel.textColor"];
*/

#pragma mark - 字符串的拆分
/*
 10. 字符串的拆分
 model.AddressValue = @"河北省,秦皇岛市,山海关区|";
 
 NSMutableCharacterSet * charSet = [[NSMutableCharacterSet alloc]init];
 [charSet addCharactersInString:@","];
 [charSet addCharactersInString:@"|"];
 
 NSArray * addressArr = [model.AddressValue componentsSeparatedByCharactersInSet:charSet];
 NSMutableString * address = [[NSMutableString alloc]init];
 for (NSString * str in addressArr) {
 [address appendString:str];
 }
 
 /// 通过字符串拆分
 [string componentsSeparatedByString:@"123"]
*/

#pragma mark - UITextView 收键盘
/*
 -(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
 {
 NSLog(@"%@",text);
 if ([text isEqualToString:@"\n"]) {
 [textView resignFirstResponder];
 return NO;
 }
 return YES;
 }
*/

#pragma mark - 判断point是否在frame内
/*
 3.
 CGPoint point=[[touches anyObject] locationInView:self.superview];
 ///判断是否包含
 if(CGRectContainsPoint(self.sourceFrame,point))
 {
 return;
 }
 else
 {
 [self dismiss];
 }
*/

#pragma mark - 自定义相机视图的取消按钮
/*
 4.自定义相机视图的取消按钮
 - (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
 {
 UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
 rightBtn.tintColor = MYRED;
 [rightBtn setTitleTextAttributes:@{@"UITextAttributeTextColor":MYRED} forState:UIControlStateNormal];
 viewController.navigationItem.rightBarButtonItem = rightBtn;
 }
 
 -(void)pop
 {
 [self dismissViewControllerAnimated:YES completion:nil];
 }
*/

#pragma mark - 版本检测
/*
 6.版本检测
 -(void)checkDate
 {
 NSString * trackViewUrl ;
 NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
 CGFloat nowVersion = [[infoDict objectForKey:@"CFBundleVersion"] floatValue];
 
 NSError *error;
 NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=1021882655"];
 NSURLRequest *request= [NSURLRequest requestWithURL:url];
 NSData *response=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
 NSDictionary *dict=  [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
 NSArray *res= [dict objectForKey:@"results"];
 if([res count]){
 NSDictionary *resDict= [res objectAtIndex:0];
 CGFloat newVersion = [[resDict objectForKey:@"version"] floatValue];
 trackViewUrl=[resDict objectForKey:@"trackViewUrl"];
 
 if(nowVersion < newVersion)
 {
 NSString *message=[[NSString alloc] initWithFormat:@"当前版本为%g，最新版本为%g", nowVersion, newVersion];
 UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"检测版本更新" message:message   delegate:self     cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil ];
 [alert show];
 }else{
 UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"检测版本更新" message:@"已经是最新版本了" delegate:self     cancelButtonTitle:@"取消" otherButtonTitles:nil];
 [alert show];
 }
 }
 }
 
 -(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 if(buttonIndex == 1){
 NSURL *url= [NSURL URLWithString: self.trackViewUrl];
 [[UIApplication sharedApplication] openURL:url];
 }
 }
*/