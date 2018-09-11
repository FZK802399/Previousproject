//
//  ShopNum1.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-6.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#ifndef ShopNum1V3_1_ShopNum1_h
#define ShopNum1V3_1_ShopNum1_h

//************************************************************************************
// imports
#import "AFAppAPIClient.h"
#import "AFNetworking.h"
#import "WFSViewController.h"
#import "UIColor+WS.h"
#import "TSMessage.h"
#import "UIFont+WS.h"
#import "MJRefresh.h"
#import "QCheckBox.h"
#import "ZJSwitch.h"
#import "DXAlertView.h"
#import "PAImageView.h"
#import "UIImage+Fit.h"
#import "TextStepperField.h"
//#import "ZBarSDK.h"
#import "StrikeThroughLabel.h"
#import "ZSYPopoverListView.h"
#import "UIHelper.h"
#import "XYSpriteHelper.h"
#import "BorderLabel.h"
#import "ShortCutPopView.h"
//#import <Frontia/Frontia.h>
#import "MBProgressHUD+LZ.h"
#import "NSMutableArray+SWUtilityButtons.h"
#import "UIView+Frame.h"
#import "LZButton.h"
// 即时通讯
#import "EaseMob.h"
#import "FMDB.h"
#import "DZYTools.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
///异步登录以后的通知
#define HUANXIN_LOGINEND_NOTICE @"HuanXin_LoginEnd_Notice"
#define HUANXIN_LOGOFFEND_NOTICE @"HuanXin_LogoffEnd_Notice"
#define HUANXIN_RECEIVE_NOTICE @"HuanXin_Receive_Notice"

//Abel421 商品信息cell
//Ext keyWord
#define kMesssageExtWeChat @"weichat"
#define kMesssageExtWeChat_ctrlType @"ctrlType"
#define kMesssageExtWeChat_ctrlType_enquiry @"enquiry"
#define kMesssageExtWeChat_ctrlType_inviteEnquiry @"inviteEnquiry"
#define kMesssageExtWeChat_ctrlType_transferToKfHint  @"TransferToKfHint"
#define kMesssageExtWeChat_ctrlType_transferToKf_HasTransfer @"hasTransfer"
#define kMesssageExtWeChat_ctrlArgs @"ctrlArgs"
#define kMesssageExtWeChat_ctrlArgs_inviteId @"inviteId"
#define kMesssageExtWeChat_ctrlArgs_serviceSessionId @"serviceSessionId"
#define kMesssageExtWeChat_ctrlArgs_detail @"detail"
#define kMesssageExtWeChat_ctrlArgs_summary @"summary"

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//

//************************************************************************************
// webservice

// /api/SignSet/?isSet=1 获取appid/appkey/appsign


#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]




///主题红
#define MYRED [UIColor colorWithRed:0.220 green:0.675 blue:0.710 alpha:1.000]
///字体黑
#define FONT_BLACK [UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1]
///字体浅灰
#define FONT_LIGHTGRAY [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]
///字体深灰
#define FONT_DARKGRAY [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]
///背景灰 246
#define BACKGROUND_GRAY [UIColor colorWithWhite:0.956 alpha:1.000]
///分割线浅灰 220
#define LINE_LIGHTGRAY [UIColor colorWithWhite:0.863 alpha:1.000]
///分割线深灰
#define LINE_DARKGRAY [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1]

// 主题绿
#define MAIN_GREEN [UIColor colorWithRed:0.447 green:0.686 blue:0.176 alpha:1.000]
// 主题蓝  47 157 166
#define MAIN_BLUE [UIColor colorWithRed:0.187 green:0.616 blue:0.651 alpha:1.000]
// 主题黄
#define MAIN_YELLOW [UIColor colorWithRed:0.980 green:0.749 blue:0.075 alpha:1.000]
// 主题橙  245  50  35
#define MAIN_ORANGE [UIColor colorWithRed:0.963 green:0.194 blue:0.137 alpha:1.000]

//======================通知====================
#define kNotificationWXPayComplete @"NotificationWXPayComplete"
#define KNotificationGoodsChange @"GoodsNumChange"
///用来是否需要更新
#define AppID nil

#define kWebAppGetAppSignPath @"/api/SignSet/?isSet=1"

//测试
//#define kWebMainBaseUrl @"http://senghong.groupfly.cn/"
//#define kWebAppBaseUrl @"http://senghongAPP.groupfly.cn/"

#define kWebMainBaseUrl @"http://www.efood7.com"
#define kWebAppBaseUrl @"http://senghongapp.efood7.com"
//#define kWebAppBaseUrl @"http://192.168.3.134"

//公司内部测试用
//#define kWebAppBaseUrl @"http://192.168.3.26"
//#define kWebAppBaseUrl @"http://192.168.3.138"
//#define kWebAppBaseUrl @"http://192.168.3.45"
//#define kWebAppBaseUrl @"http://192.168.3.45:8099"
//#define kWebAppBaseUrl @"http://47.89.26.176:8080/efood/"


//#define kWebAppBaseUrl @"http://139.196.219.152:8080/efood/"
//http://139.196.219.152:2891/
//发短信
#define KWebSend @"http://senghongapp.efood7.com/api/GetMobileMessage"
//测试用
//在使用的
//http://139.196.219.152:58156/efood/
//192.168.3.134/api/
//卡
//添加储值卡
#define kWebAppCardNumberUrl @"http://192.168.3.45:8099/addCards.action"
//绑定用户
#define kWebAppPresonUrl @"http://139.196.219.152:58156/efood/bindingCardToUser.action"
//根据code查询卡信息
#define kWebAppQueryInformationUrl @"/api/getEntityCards.actiongetCardByCode.action"
//储值卡消费(充值)
#define kWebAppUseCardMoneyUrl @"http://139.196.219.152:58156/efood/useCardMoney.action"
//获得实体卡
#define kWebAppGetkWebAppGetVirtualCardsUrl @"http://139.196.219.152:58156/efood/getEntityCards.action"
//获得虚拟卡
#define kWebAppGetVirtualCardsUrl @"http://139.196.219.152:58156/efood/getVirtualCards.action"
//使用实体卡绑定用户
#define kWebAppBindingCardUrl @"http://139.196.219.152:58156/efood/bindingCardToUser.action"
//查询用户所拥有的储值卡
#define kWebAppGetUserCards @"http://139.196.219.152:58156/efood/getUserCards.action"
//#激活充值卡
#define kWebAppActiveCard @"http://139.196.219.152:58156/efood/activeCard.action"
//赠送卡非会员调用接口
#define kWebAppGiveCard @"api/GiveCard/"
//新注册绑定卡
#define kWebAppRegDingCard @"api/RegDingCard/"




//券
//获得一个用户所有的优惠券
#define kWebAppGetUserAllCoupon @"http://139.196.219.152:58156/efood/getUserAllCoupon.action"
//根据id查询优惠券规则
#define kWebAppGetCouponRuleByCouponId @"http://139.196.219.152:58156/efood/getCouponRuleByCouponId.action"
//通过code使用优惠券
#define kWebAppUseCoupon @"http://139.196.219.152:58156/efood/useCoupon.action"
//商品范围属性
#define kWebAppCouponRule @"http://139.196.219.152:58156/efood/CouponRule.action"





//签名地址
#define kWebAppSign (self.appConfig.appSign)
//测试
#define kWebTestAppSign @"6d7f36bfa18a9b68d528c0e1c71d87fe"

//获取签名地址
#define kWebServiceSignGetPath @"/api/SignGet/"  //?AppId=9c0c80c0adae4f438d71&AppKey=fe79808041bceafc44a513f16f0de021

//获取首页海报图片地址
#define kWebServiceBannersPath @"api/ShopGGlist/"  //?shopid=shopnum1_administrators&Type=1

//获取商品列表地址
#define kWebServiceHomeShopsPath @"/api/product2/type/"  //?type=2&sorts=ModifyTime&isASC=true&pageIndex=1&pageCount=5

//获取全部品牌地址
#define kWebServiceAllBandsPath @"/api/productbrandlist/"

//获取推荐品牌地址
#define kWebServiceRecommendBandsPath @"/api/productbrandlistisrecommend/"

//获取品牌详细地址
#define kWebServiceBandDetailPath @"/api/productbranddetail/" 

//获取用户足迹地址
#define kWebFootMarkPath @"/api/footprintget/"

//添加用户足迹
#define kWebAddFootMarkPath @"/api/footprintappend/"

//删除用户足迹地址
#define kWebDeleteFootMarkPath @"/api/footprintremove/"

//产品搜索
#define kWebSearchProductPath @"/api/product2/search/"

//平台产品类别
#define kWebAllSortsPath @"/api/productcatagory/"

//平台产品列表
#define kWebSortproductPath @"/api/product2/list/"

//限时抢购产品列表
#define kWebSaleLimitedproductPath @"/api/panicbuyinglist/"

//用户信息
#define kWebAccountInfoPath @"/api/accountget/"

//更新用户积分
#define kWebUpdateScorePath @"/api/memberscoreupdate/"

//获取可用积分进行抵用的商品
#define kWebGetScoreProductPath @"/api/productbysocre/"

//获取预存款明细
#define kWebGetAdvancePaymentModifyLog @"api/getAdvancePaymentModifyLog/"

//获取客户积分明细
#define kWebGetScoreDetailPath @"/api/getscoremodifylog/"

//判断用户是否存在
#define kWebUserNameIsExistPath @"/api/accountuserexist/"

//注册验证用户 手机号码 是否存在
#define kWebUserMobileIsExistPath @"/api/account/useremobileexist/"

//用户注册
//#define kWebUserRegistPath @"/api/accountregist/"
#define kWebUserRegistPath @"api/accountregistymgj/"




//登陆
#define kWebUserLogInPath @"/api/accountlogin/"

///登录密码修改
#define kWebChangeLogInPWDPath @"/api/updateloginpwd/"

//验证用户的支付密码是否与传入的密码相等
#define kWebCheckPayPWDPath @"/api/checkequalpaypwd/"

//修改预存款支付密码
#define kWebChangePayPWDPath @"/api/updatepaypwd/"

//产品详细
#define kWebProductDetailPath @"/api/product/"

//购物车列表
#define kWebShopCartListPath @"/api/shoppingcartget/"

//添加购物车
#define kWebShopCartAddPath @"/api/shoppingcartadd/"

//删除购物车产品
#define kWebShopCartDeletePath @"/api/shoppingcartdelete/"

//验证商品在该地区是否有库存
#define kWebProductStockByAreaPath @"/api/productstockbyarea/"

//规格查询价格
#define kWebProductSpecificationPricePath @"/api/Specification/"

//产品规格
#define kWebProductSpecificationPath @"/api/SpecificationList/"

//产品收藏列表
#define kWebShopCollectListPath @"/api/collectlist/"

//产品收藏删除
#define kWebShopCollectDeletePath @"/api/collectdelete/"

//产品收藏
#define kWebShopCollectAddPath @"/api/collectadd/"

//商品信誉评价
#define kWebProductcommentlistPath @"/api/product/commentlist/"

//买家商品评价
#define kWebAddProductcommentPath @"/api/ProductComment/Add"

//获取晒单记录
#define kWebgetbaskorderloglistPath @"/api/getbaskorderlogs/"

//添加晒单记录
#define kWebAddBaskOrderLogPath @"/api/addBaskorderlog/"

//省市区
#define kWebRegionlistPath @"/api/region/"

//生成订单号
#define kWebCreatOrderNumberPath @"api/getorderno/"

//提交订单
#define kWebPostOrderPath @"/api/orderadd/"

//提交积分订单
#define kWebPostScoreOrderPath @"/api/scoreorderappend/"

//订单列表
#define kWebGetOrderListPath @"/api/order/member/OrderList/"

//订单详情
#define kWebGetOrderDetailPath @"/api/orderget/"

//取消订单
#define kWebCancelOrderPath @"/api/ordercancel"

//确定收货
#define kWebUpdateShipmentStatusPath @"/api/order/UpdateShipmentStatus/"

//申请退货
#define kWebaddreturnorderPath @"/api/addreturnorder/"

//查看退货状态
#define kWebGetreturnorderStatuePath @"/api/getreturnorderlist/"//?MemLoginID=&OrderGuid=&AppSign=

///更新退货商品信息
#define kWebUpdatereturnorderPath @"/api/updatereturngoodsinfo/"

//收货地址列表
#define kWebGetAddressListPath @"/api/address/"

//添加收货地址
#define kWebAddAddressPath @"/api/addressadd/"

//删除收货地址
#define kWebDeleteAddressPath @"/api/addressdelete/"

//编辑收货地址
#define kWebEditAddressPath @"/api/addressupdate/"

//支付方式列表
#define kWebGetPaymentListPath @"/api/payment/"

//预存款支付
#define kWebAdvancePayPath @"/api/order/BuyAdvancePayment/"

//邮费计算
#define kWeborderpricecaculatePath @"/api/orderpricecaculate/"

//积分订单邮费计算
#define kWebScoreOrderDispatchmodelistbycodePath @"/api/scoreordercaculateprice/"

///运送方式 and 邮费
#define kWebdispatchmodelistbycodePath @"/api/dispatchmodelistbycode/"

//会员消息列表
#define kWebmembermessagelistPath @"/api/membermessagelist/"

//删除会员消息
#define kWebmembermessagedeletePath @"/api/membermessagedelete/"

//修改会员消息已读状态
#define kWebmembermessageReadPath @"/api/membermessageisread/"//?id=&memLoginID=&AppSign=

///上传图片接口
#define kWebServiceUploadPath @"/api/uploadpic.ashx" //返回 uploadPath

///获取积分换算金额
#define kWebServiceGetScorepricePath @"/api/scoreprice/"

//获取推荐会员记录
#define kWebgetmemberlistPath @"/api/getmemberbycommendpeople/"

//获取推荐返利记录
#define kWebgetscoremodifylogListPath @"/api/getscoremodifylogbycommendpeoplefirst/"

//获取商品列表地址
#define kWebServiceScoreProductListHomeShopsPath @"/api/getscoreproductlist/"  

//按商品ID获取积分商品
#define kWebServiceScoreProductDetailPath @"/api/getscoreproductbyid/"

//添加积分商品购物车
#define kWebServiceScoreProductAddShopCartPath @"/api/appendscorecart/"

//90. 获取积分商品订单列表
#define kWebServiceScoreOrderListPath @"/api/getscoreorderinfolist/"

//96. 按父ID获取积分商品分类列表
#define kWebServiceGetScoreProductCategoryListPath @"/api/getscoreproductcategorylist/"

//93. 取消订单
#define kWebServiceCancelScoreOrderPath @"/api/cancelscoreorderinfo/"

//94. 积分确认收货
#define kWebServiceconfirScoreOrderPath @"/api/confirmgoodsreceipt/"

//91. 按订单编号获取订单
#define kWebServiceGetScoreOrderDetailPath @"/api/getbyscoreordernumber/"


//88. 获取积分商品购物车
#define kWebServiceGetScoreShopCartPath @"/api/getscorecart/"

//97. 删除积分商品购物车
#define kWebServiceDeleteScoreShopCartPath @"/api/removescorecart/"

//98. 扣除用户积分
#define kWebServiceCutMemberScorePath @"/api/CutMemberScore/"
//************************************************************************************



///share SDK AppKey
#define APP_KEY @"8Q9DrNVV81WA3OHIVvCz1Fd3"
#define REPORT_ID @"3801730"

#define IosAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define SAFE_RELEASE(_obj) if (_obj != nil) {[_obj release]; _obj = nil;}

//string
#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]
// marcros
#define kCurrentSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
#define HLYErrorLog(__error__) NSLog(@"error : %@", __error__)
#define HLYScreenBounds ([[UIScreen mainScreen] bounds])
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define NavigationBar_HEIGHT 44
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//use dlog to print while in debug model
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

//************************************************************************************
// notifications

#define WFSUploadDidEndNotification @"WFSUploadDidEndNotification"
//************************************************************************************
// segue

// 登录界面
#define ZDX_LOGIN [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil] instantiateViewControllerWithIdentifier:@"NavLoginViewController"]
// 根据ID返回SB加载的视图控制器
#define ZDX_VC(storyboardName, ID) [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:ID]

// 弱引用
#define ZDXWeakSelf(weakSelf) __weak __typeof(&*self) weakSelf = self;

#define kSegueHomeToFootmark @"kSegueHomeToFootmark"

#define kSeguerecommendMerchandiseDetail @"recommendMerchandiseDetail"

#define kSegueHomeToIntegral @"kSegueHomeToIntegral"

#define kSegueBrandCenterToResult @"kSegueBrandCenterToResult"

#define kSegueHomeToLogin @"kSegueHomeToLogin"

#define kSegueGetproductBySort @"kSegueGetproductBySort"

#define kSegueSortToSearchResult @"kSegueSortToSearchResult"

#define kSegueLoginToFootmark @"kSegueLoginToFootmark"

#define kSegueScoreProductDetail @"kSegueScoreProductDetail"

#define kSegueSearchResult @"kSegueSearchResult"

#define kSegueShopCartToLogin @"kSegueShopCartToLogin"

#define kSeguePersonalToLogin @"kSeguePersonalToLogin"

#define kSegueLoginToResigter @"kSegueLoginToResigter"

#define kSegueFootMarkToDetail @"kSegueFootMarkToDetail" 

#define kSegueloginToIntegral @"kSegueloginToIntegral"

#define kSegueResultToDetail @"kSegueResultToDetail"

#define kSegueDetailtoMore @"kSegueDetailtoMore"

#define kSegueFavToLogin @"kSegueFavToLogin"

#define kSegueDetailToShopCart @"kSegueDetailToShopCart"

#define kSegueDetailToAppraisal @"kSegueDetailToAppraisal"

#define kSeguePersonToCollect @"kSeguePersonToCollect"

#define kSegueDetailToBuy @"kSegueDetailToBuy"

#define kSeguePresonalToAddress @"kSeguePresonalToAddress"

#define kSegueChooseAddress @"kSegueChooseAddress"

#define kSegueRegistertoProtocol @"kSegueRegistertoProtocol"

#define kSegueAddressToEdit @"kSegueAddressToEdit"

#define kSeguePersonalToScoreDetail @"kSeguePersonalToScoreDetail"

#define kSeguePersonalToOrderList @"kSeguePersonalToOrderList"

#define kSegueShopCartToSubmit @"kSegueShopCartToSubmit"

#define kSegueSubmitOrderlToPay @"kSegueSubmitOrderlToPay"

#define kSegueOrderToDetail @"kSegueOrderToDetail"

#define kSegueOrderListToPay @"kSegueOrderListToPay"

#define kSegueShopCartToDetail @"kSegueShopCartToDetail"

#define kSegueSubmitToOrderList @"kSegueSubmitToOrderList"

#define kSegueOrderDetailToReturn @"kSegueOrderDetailToReturn"

#define kSegueReturnOrderToUpdate @"kSegueReturnOrderToUpdate"

#define kSeguePersonalToMessage @"kSeguePersonalToMessage"

#define kSegueMessagListToDetail @"kSegueMessagListToDetail"

#define kSegueProductListToComment @"kSegueProductListToComment"

#define kSeguePersonalToSecurity @"kSeguePersonalToSecurity"

#define kSegueOrderListToLogistics @"kSegueOrderListToLogistics"

#define kSegueSecurityToLoginPWD @"kSegueSecurityToLoginPWD"

#define kSegueSecurityToPayPWD @"kSegueSecurityToPayPWD"

#define kSegueSubmitOrderToUseScore @"kSegueSubmitOrderToUseScore"

#define kSeguePersonalToRecommend @"kSeguePersonalToRecommend"

#define kSegueScoreProductToList @"kSegueScoreProductToList"

#define kSegueScoreProductToSort @"kSegueScoreProductToSort"

#define kSegueScoreSortToList @"kSegueScoreSortToList"

//************************************************************************************
// NSUserDefaults keys

//************************************************************************************
// cell identifier
#define kBrandCollectionCellMainView @"BrandCollectionViewCell"

#define kAllBrandCollectionCellMainView @"AllBrandCollectionViewCell"

#define kSortBrandCollectionCellMainView @"SortBrandCollectionViewCell"

#define kScoreProductCollectionCellMainView @"ScoreProductCollectionViewCell"

#define kFootMarkTableViewCellMainView @"FootMarkTableViewCell"

#define kSearchResultTableViewCellMainView @"SearchResultTableViewCell"

#define kShopCartTableViewCellMainView @"ShopCartCellTableViewCell"

#define kSearchHistoryTableViewCellMainView @"SearchHistoryCellTableViewCell"

#define kPersonalTableViewCellMainView @"PersonalCellTableViewCell"

#define kAppraisalTableViewCellMainView @"AppraisalCellTableViewCell"

#define kAddressTableViewCellMainView @"AddressTableViewCell"

#define kScoreTableViewCellMainView @"ScoreTableViewCell"

#define SecurityCenterTableViewCellID @"SecurityCenterTableViewCellID"

#define RecommendPersonTableViewCellID @"RecommendPersonTableViewCellID"

#define RecommendScoreTableViewCellID @"RecommendScoreTableViewCellID"

#endif
