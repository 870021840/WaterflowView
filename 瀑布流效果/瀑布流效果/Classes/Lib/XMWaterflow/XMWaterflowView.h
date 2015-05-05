//
//  XMWaterflowView.h
//  瀑布流效果
//
//  Created by 谢满 on 15/5/2.
//  Copyright (c) 2015年 谢满. All rights reserved.
//瀑布流view


#import <UIKit/UIKit.h>
#import "XMWaterflowViewCell.h"

typedef enum {
    /**
     *  顶部间隔
     */
    XMWaterflowViewMarginTop,
    /**
     *  底部间隔
     */
    XMWaterflowViewMarginBottom,
    /**
     *  左边间隔
     */
    XMWaterflowViewMarginLeft,
    /**
     *  右边间隔
     */
    XMWaterflowViewMarginRight,
    /**
     *  列与列的间隔
     */
    XMWaterflowViewMarginColoumn,
    /**
     *  行与行的间隔
     */
    XMWaterflowViewMarginRow
} XMWaterflowViewMarginType;

/**
 *  数据源方法
 */
@class XMWaterflowView,XMWaterflowViewCell;

@protocol XMWaterflowViewDataSource <NSObject>

@required

/**
 *  总共有多少个数据
 *
 *  @param waterflowView 瀑布流容器
 *
 *  @return 个数
 */
-(NSUInteger)numberOfCellsInWaterflowView:(XMWaterflowView *)waterflowView;

/**
 *  根据index的位置返回对应的cell
 *
 *  @param waterflowView 瀑布流容器
 *  @param index         索引
 *
 *  @return cell视图
 */
-(XMWaterflowViewCell *)waterflowView:(XMWaterflowView *)waterflowView cellAtIndex:(NSUInteger) index;

@optional
/**
 *  一共有多少列，默认是3列
 *
 *  @param waterflowView  瀑布流容器
 *
 *  @return 列数
 */
-(NSUInteger)numberOfColumnsInWaterflowView:(XMWaterflowView *)waterflowView;


@end


@protocol XMWaterflowViewDelegate <UIScrollViewDelegate>

@optional
/**
 *  第index位置的XMWaterflowViewCell的高度
 *
 *  @param waterflowView 瀑布流容器
 *  @param index         索引
 *
 *  @return 高度
 */
-(CGFloat)waterflowView:(XMWaterflowView *)waterflowView heightAtIndex:(NSUInteger)index;

/**
 *  选中第index位置的XMWaterflowViewCell
 *
 *  @param waterflowView 瀑布流容器
 *  @param index         索引
 */
-(void)waterflowView:(XMWaterflowView *)waterflowView didSelectedAtIndex:(NSUInteger)index;


/**
 *  第index位置的XMWaterflowViewCell的高度
 *
 *  @param waterflowView 瀑布流容器
 *  @param index         索引
 *
 *  @return 高度
 */
-(CGFloat)waterflowView:(XMWaterflowView *)waterflowView marginForType:(XMWaterflowViewMarginType)type;
@end


@interface XMWaterflowView : UIScrollView

/**
 *  数据源方法
 */
@property(nonatomic,weak) id<XMWaterflowViewDataSource>  dataSource;

/**
 *  代理方法
 */

@property(nonatomic,weak) id<XMWaterflowViewDelegate>  delegate;


/**
 *  cell的宽度
 *
 */

@property(nonatomic,assign,readonly) CGFloat cellWidth;

/**
 *  加载view
 */
-(void)reloadData;

/**
 *  根据标示去缓存池找可以循环利用的cell
 *
 *  @param identifier 标示
 *
 *  @return cell
 */
-(id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

@end
