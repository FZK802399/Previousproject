//
//  HKCountryChangController.m
//  ShopNum1V3.1
//
//  Created by Mac on 16/6/1.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import "HKCountryChangController.h"
#import "HKCountryCell.h"
#import "HKCountry.h"

static NSString * const reuseId = @"countryCellID";
@interface HKCountryChangController ()
//@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<HKCountry *> *> *countryDic;
@property (nonatomic, strong) NSMutableArray<NSString *> *firstCodeArr;
@property (nonatomic, strong) NSMutableArray<NSMutableArray<HKCountry *> *> *countryArr;
@end

@implementation HKCountryChangController
#pragma mark- 懒加载
//- (NSMutableDictionary *)countryDic
//{
//    if (!_countryDic) {
//        _countryDic = [NSMutableDictionary<NSString *, NSMutableArray<HKCountry *> *> dictionary];
//    }
//    return _countryDic;
//}
- (NSMutableArray *)firstCodeArr
{
    if (!_firstCodeArr) {
        _firstCodeArr = [NSMutableArray<NSString *> array];
    }
    return _firstCodeArr;
}

- (NSMutableArray *)countryArr
{
    if (!_countryArr) {
        _countryArr = [NSMutableArray<NSMutableArray<HKCountry *> *> array];
    }
    return _countryArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKCountryCell class]) bundle:nil] forCellReuseIdentifier:reuseId];
    self.tableView.sectionIndexBackgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0];
    [self loadCountryData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadCountryData
{
    [HKCountry getCountryListWithBlock:^(NSArray<HKCountry *> *arr, NSError *error) {
//        [self.countryDic removeAllObjects];
        NSMutableArray *arrA = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrB = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrC = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrD = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrE = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrF = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrG = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrH = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrI = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrJ = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrK = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrL = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrM = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrN = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrO = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrP = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrQ = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrR = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrS = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrT = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrU = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrV = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrW = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrX = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrY = [NSMutableArray<HKCountry *> array];
        NSMutableArray *arrZ = [NSMutableArray<HKCountry *> array];
        for (HKCountry *country in arr) {
            if ([country.FristCode isEqualToString:@"A"]) {
                [arrA addObject:country];
            }
            if ([country.FristCode isEqualToString:@"B"]) {
                [arrB addObject:country];
            }
            if ([country.FristCode isEqualToString:@"C"]) {
                [arrC addObject:country];
            }
            if ([country.FristCode isEqualToString:@"D"]) {
                [arrD addObject:country];
            }
            if ([country.FristCode isEqualToString:@"E"]) {
                [arrE addObject:country];
            }
            if ([country.FristCode isEqualToString:@"F"]) {
                [arrF addObject:country];
            }
            if ([country.FristCode isEqualToString:@"G"]) {
                [arrG addObject:country];
            }
            if ([country.FristCode isEqualToString:@"H"]) {
                [arrH addObject:country];
            }
            if ([country.FristCode isEqualToString:@"I"]) {
                [arrI addObject:country];
            }
            if ([country.FristCode isEqualToString:@"J"]) {
                [arrJ addObject:country];
            }
            if ([country.FristCode isEqualToString:@"K"]) {
                [arrK addObject:country];
            }
            if ([country.FristCode isEqualToString:@"L"]) {
                [arrL addObject:country];
            }
            if ([country.FristCode isEqualToString:@"M"]) {
                [arrM addObject:country];
            }
            if ([country.FristCode isEqualToString:@"N"]) {
                [arrN addObject:country];
            }
            if ([country.FristCode isEqualToString:@"O"]) {
                [arrO addObject:country];
            }
            if ([country.FristCode isEqualToString:@"P"]) {
                [arrP addObject:country];
            }
            if ([country.FristCode isEqualToString:@"Q"]) {
                [arrQ addObject:country];
            }
            if ([country.FristCode isEqualToString:@"R"]) {
                [arrR addObject:country];
            }
            if ([country.FristCode isEqualToString:@"S"]) {
                [arrS addObject:country];
            }
            if ([country.FristCode isEqualToString:@"T"]) {
                [arrT addObject:country];
            }
            if ([country.FristCode isEqualToString:@"U"]) {
                [arrU addObject:country];
            }
            if ([country.FristCode isEqualToString:@"V"]) {
                [arrV addObject:country];
            }
            if ([country.FristCode isEqualToString:@"W"]) {
                [arrW addObject:country];
            }
            if ([country.FristCode isEqualToString:@"X"]) {
                [arrX addObject:country];
            }
            if ([country.FristCode isEqualToString:@"Y"]) {
                [arrY addObject:country];
            }
            if ([country.FristCode isEqualToString:@"Z"]) {
                [arrZ addObject:country];
            }
        }
        
        if (arrA.count) {
//            [self.countryDic setObject:arrA forKey:@"A"];
            [self.firstCodeArr addObject:@"A"];
            [self.countryArr addObject:arrA];
        }
        
        if (arrB.count) {
//            [self.countryDic setObject:arrB forKey:@"B"];
            [self.firstCodeArr addObject:@"B"];
            [self.countryArr addObject:arrB];
        }
        if (arrC.count) {
//            [self.countryDic setObject:arrC forKey:@"C"];
            [self.firstCodeArr addObject:@"C"];
            [self.countryArr addObject:arrC];

        }
        if (arrD.count) {
//            [self.countryDic setObject:arrD forKey:@"D"];
            [self.firstCodeArr addObject:@"D"];
            [self.countryArr addObject:arrD];
        }
       
        if (arrE.count) {
//            [self.countryDic setObject:arrE forKey:@"E"];
            [self.firstCodeArr addObject:@"E"];
            [self.countryArr addObject:arrE];
        }
        if (arrF.count) {
//            [self.countryDic setObject:arrF forKey:@"F"];
            [self.firstCodeArr addObject:@"F"];
            [self.countryArr addObject:arrF];
        }
        if (arrG.count) {
//            [self.countryDic setObject:arrG forKey:@"G"];
            [self.firstCodeArr addObject:@"G"];
            [self.countryArr addObject:arrG];
        }
        if (arrH.count) {
//            [self.countryDic setObject:arrH forKey:@"H"];
            [self.firstCodeArr addObject:@"H"];
            [self.countryArr addObject:arrH];
        }
        if (arrI.count) {
//            [self.countryDic setObject:arrI forKey:@"I"];
            [self.firstCodeArr addObject:@"I"];
            [self.countryArr addObject:arrI];
        }
        if (arrJ.count) {
//            [self.countryDic setObject:arrJ forKey:@"J"];
            [self.firstCodeArr addObject:@"J"];
            [self.countryArr addObject:arrJ];
        }
        if (arrK.count) {
//            [self.countryDic setObject:arrK forKey:@"K"];
            [self.firstCodeArr addObject:@"K"];
            [self.countryArr addObject:arrK];
        }
        if (arrL.count) {
//            [self.countryDic setObject:arrL forKey:@"L"];
            [self.firstCodeArr addObject:@"L"];
            [self.countryArr addObject:arrL];
        }
        if (arrM.count) {
//            [self.countryDic setObject:arrM forKey:@"M"];
            [self.firstCodeArr addObject:@"M"];
            [self.countryArr addObject:arrM];
        }
        if (arrN.count) {
//            [self.countryDic setObject:arrN forKey:@"N"];
            [self.firstCodeArr addObject:@"N"];
            [self.countryArr addObject:arrN];
        }
        if (arrO.count) {
//            [self.countryDic setObject:arrO forKey:@"O"];
            [self.firstCodeArr addObject:@"O"];
            [self.countryArr addObject:arrO];
        }
        if (arrP.count) {
//            [self.countryDic setObject:arrP forKey:@"P"];
            [self.firstCodeArr addObject:@"P"];
            [self.countryArr addObject:arrP];
        }
        if (arrQ.count) {
            //            [self.countryDic setObject:arrQ forKey:@"Q"];
            [self.firstCodeArr addObject:@"Q"];
            [self.countryArr addObject:arrQ];
        }
        if (arrR.count) {
//            [self.countryDic setObject:arrR forKey:@"R"];
            [self.firstCodeArr addObject:@"R"];
            [self.countryArr addObject:arrR];
        }
        if (arrS.count) {
//            [self.countryDic setObject:arrS forKey:@"S"];
            [self.firstCodeArr addObject:@"S"];
            [self.countryArr addObject:arrS];
        }
        if (arrT.count) {
//            [self.countryDic setObject:arrT forKey:@"T"];
            [self.firstCodeArr addObject:@"T"];
            [self.countryArr addObject:arrT];
        }
        if (arrU.count) {
//            [self.countryDic setObject:arrU forKey:@"U"];
            [self.firstCodeArr addObject:@"U"];
            [self.countryArr addObject:arrU];
        }
        if (arrV.count) {
//            [self.countryDic setObject:arrV forKey:@"V"];
            [self.firstCodeArr addObject:@"V"];
            [self.countryArr addObject:arrV];
        }
        if (arrW.count) {
//            [self.countryDic setObject:arrW forKey:@"W"];
            [self.firstCodeArr addObject:@"W"];
            [self.countryArr addObject:arrW];
        }
        if (arrX.count) {
//            [self.countryDic setObject:arrX forKey:@"X"];
            [self.firstCodeArr addObject:@"X"];
            [self.countryArr addObject:arrX];
        }
        if (arrY.count) {
//            [self.countryDic setObject:arrY forKey:@"Y"];
            [self.firstCodeArr addObject:@"Y"];
            [self.countryArr addObject:arrY];
        }
        if (arrZ.count) {
//            [self.countryDic setObject:arrZ forKey:@"Z"];
            [self.firstCodeArr addObject:@"Z"];
            [self.countryArr addObject:arrZ];
        }
        
//        [self.countryDic keysSortedByValueUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
//            NSComparisonResult result = [obj1 compare:obj2];
//            return result;
//        }];
        
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.firstCodeArr.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.countryArr[section].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    cell.countryNameLabel.text = self.countryArr[indexPath.section][indexPath.row].country;
    return cell;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.firstCodeArr;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.firstCodeArr[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.delegate respondsToSelector:@selector(countryChangController:didFinishedSelectCountry:)]) {
        // 调用代理
        HKCountry *country = self.countryArr[indexPath.section][indexPath.row];
        [self.delegate countryChangController:self didFinishedSelectCountry:country];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
