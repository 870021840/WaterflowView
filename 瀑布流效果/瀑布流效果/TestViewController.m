//
//  TestViewController.m
//  瀑布流效果
//
//  Created by 谢满 on 15/5/2.
//  Copyright (c) 2015年 谢满. All rights reserved.
//

#import "TestViewController.h"
#import "XMWaterflowView.h"
#import "XMShop.h"
#import "MJExtension.h"
#import "XMShopCell.h"


@interface TestViewController ()<XMWaterflowViewDelegate,XMWaterflowViewDataSource>


@property(nonatomic,strong) NSMutableArray *data;

@property(nonatomic,strong) XMWaterflowView *waterflowView;


@property(nonatomic,strong) UIRefreshControl *refView;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
    self.data = [[NSMutableArray alloc] init];
    
    NSArray *newShops = [XMShop objectArrayWithFilename:@"2.plist"];
    [self.data addObjectsFromArray:newShops];
    
    XMWaterflowView *waterflowView = [[XMWaterflowView alloc] init];
    waterflowView.frame = self.view.bounds;
    waterflowView.delegate = self;
    waterflowView.dataSource = self;
    [self.view addSubview:waterflowView];
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    [control addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [waterflowView addSubview:control];
    self.refView = control;
    
    self.waterflowView = waterflowView;
}

-(void)refresh:(UIRefreshControl *)refreshControl{
    
    NSArray *newShops = [XMShop objectArrayWithFilename:@"1.plist"];
    [self.data insertObjects:newShops atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newShops.count)]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refView endRefreshing];
        [self.waterflowView reloadData];
    });
    
}

-(NSUInteger)numberOfCellsInWaterflowView:(XMWaterflowView *)waterflowView{
    
    return self.data.count;
}

-(NSUInteger)numberOfColumnsInWaterflowView:(XMWaterflowView *)waterflowView{
    return 3;
}

-(XMWaterflowViewCell *)waterflowView:(XMWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index{
    static NSString *ID = @"CELL";
    XMShopCell *cell = [waterflowView dequeueReusableCellWithIdentifier:ID ];
    if (cell == nil) {
        cell = [[XMShopCell alloc] init];
        cell.identifier = ID;
        
    }

    cell.shop = self.data[index];
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
    return cell;
}

-(CGFloat)waterflowView:(XMWaterflowView *)waterflowView marginForType:(XMWaterflowViewMarginType)type{
    switch (type) {
        case XMWaterflowViewMarginLeft:
            return 5;
            break;
        case XMWaterflowViewMarginBottom:
            return 5;
            break;
        case XMWaterflowViewMarginTop:
            return 5;
            break;
        case XMWaterflowViewMarginRight:
            return 5;
            break;
        case XMWaterflowViewMarginColoumn:
            return 5;
            break;
        case XMWaterflowViewMarginRow :
            return 5;
            break;
        default:
            return 10;
            break;
    }
}

-(CGFloat)waterflowView:(XMWaterflowView *)waterflowView heightAtIndex:(NSUInteger)index{
    
    XMShop *shop = self.data[index];
    return  waterflowView.cellWidth * shop.h / shop.w;
}


-(void)waterflowView:(XMWaterflowView *)waterflowView didSelectedAtIndex:(NSUInteger)index{
    NSLog(@"点击了－－%ld",index);
}

@end
