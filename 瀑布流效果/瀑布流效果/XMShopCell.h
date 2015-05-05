//
//  ShopCell.h
//  瀑布流效果
//
//  Created by 谢满 on 15/5/2.
//  Copyright (c) 2015年 谢满. All rights reserved.
//

#import "XMWaterflowViewCell.h"
#import "XMWaterflowView.h"
#import "XMShop.h"


@interface XMShopCell : XMWaterflowViewCell

+(instancetype)cellWithWaterflowView:(XMWaterflowView *)view;


@property(nonatomic,strong) XMShop *shop;

@end
