//
//  XMWaterflowView.m
//  瀑布流效果
//
//  Created by 谢满 on 15/5/2.
//  Copyright (c) 2015年 谢满. All rights reserved.
//

#import "XMWaterflowView.h"

@interface XMWaterflowView ()



@property(nonatomic,assign) CGFloat cellWidth;
/**
 *  所有cell的frame数据
 */
@property(nonatomic,strong) NSMutableArray *cellFrames;

/**
 *  正在展示的cell
 */
@property(nonatomic,strong) NSMutableDictionary *displayingCells;


/**
 *  缓存池（yongset，存放离开屏幕的cell）
 */
@property(nonatomic,strong) NSMutableSet *reuseableCells;

@end

@implementation XMWaterflowView


-(NSMutableArray *)cellFrames{
    if (_cellFrames == nil) {
        _cellFrames = [[NSMutableArray alloc ] init];
    }
    return _cellFrames;
}

-(NSMutableDictionary *)displayingCells{
    if (!_displayingCells) {
        _displayingCells = [NSMutableDictionary dictionary];

    }
    return _displayingCells;
}

-(NSMutableSet *)reuseableCells{
    if (!_reuseableCells) {
        _reuseableCells = [[NSMutableSet alloc] init];
    }
    return _reuseableCells;
}


-(void)willMoveToSuperview:(UIView *)newSuperview{
    [self reloadData];
}

-(void)reloadData{
    
    [self.cellFrames removeAllObjects];
    [self.displayingCells.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.displayingCells removeAllObjects];
    [self.reuseableCells removeAllObjects];
    
    //cell个数
    NSUInteger numOfCells = [self.dataSource numberOfCellsInWaterflowView:self];
    //总列数
    NSUInteger numOfColoums = [self numOfColumns];
    
    //记录当前每一列的最大y值
    CGFloat maxOfColumns[numOfColoums];
    for (int i = 0; i < numOfColoums ; i++) {
        maxOfColumns[i] = 0;
    }
    
    //间隔
    CGFloat marginTop = [self magrinForType:XMWaterflowViewMarginTop];
    CGFloat marginBototm = [self magrinForType:XMWaterflowViewMarginBottom];
    CGFloat marginLeft = [self magrinForType:XMWaterflowViewMarginLeft];
    CGFloat marginRight = [self magrinForType:XMWaterflowViewMarginRight];
    CGFloat marginColumn = [self magrinForType:XMWaterflowViewMarginColoumn];
    CGFloat marginRow = [self magrinForType:XMWaterflowViewMarginRow];
    
    //cell宽度
    CGFloat cellW = (self.frame.size.width - marginLeft - marginRight - (numOfColoums - 1) * marginColumn) / numOfColoums;
    
    self.cellWidth = cellW;
    
    
    for (NSUInteger index = 0 ; index < numOfCells; index++) {
        //计算cell的y值（最短那一列的值）
        CGFloat cellY = maxOfColumns[0];
        
        /**
         *  cellColumn表示当前cell的列号
         */
        NSUInteger cellColumn = 0;
        for (int i = 1; i < numOfColoums; i ++) {
            if (cellY > maxOfColumns[i]) {
                cellY = maxOfColumns[i];
                cellColumn = i;
            }
        }
        
        if (cellY == 0.0) {
            //首行
            cellY = marginTop;
        }else{
            cellY = cellY +marginRow;
        }
        
        //cell高度
        CGFloat cellH = [self heightAtIndex:index];
        //cell x值
        CGFloat cellX = marginLeft + (marginColumn +cellW) * cellColumn;
        
        CGRect cellF = CGRectMake(cellX, cellY, cellW, cellH);
        [self.cellFrames addObject:[NSValue valueWithCGRect:cellF]];
        
        //更新列
        maxOfColumns[cellColumn] = CGRectGetMaxY(cellF);
    }
    
    CGFloat contentH = maxOfColumns[0];
    for (int i = 1 ; i < numOfColoums; i++) {
        if (maxOfColumns[i] > contentH) {
            contentH = maxOfColumns[i];
        }
    }
    
    self.contentSize = CGSizeMake(0, contentH + marginBototm);

}



-(void)layoutSubviews{
    [super layoutSubviews];
    
    NSUInteger numerOfcells = self.cellFrames.count;
    for (int i = 0; i < numerOfcells; i ++) {
        
        CGRect rect = [self.cellFrames[i] CGRectValue];
        
        //优先从字典里取cell
        XMWaterflowViewCell *cell = self.displayingCells[@(i)];
        
        if ((CGRectGetMaxY(rect) > self.contentOffset.y) && (CGRectGetMinY(rect) < self.contentOffset.y + self.frame.size.height)) {
            //在可视范围内
            if (!cell) {
                
                cell = [self.dataSource waterflowView:self cellAtIndex:i];
                cell.frame = rect;
                [self addSubview:cell];
                self.displayingCells[@(i)] = cell;
            }
        }else{
            if (cell) {
                //从scrollview和字典移除
                [cell removeFromSuperview];
                [self.displayingCells removeObjectForKey:@(i)];
                //放入缓存池
                [self.reuseableCells addObject:cell];
            }
        }
    }

    
}

-(id)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    
     __block XMWaterflowViewCell *reuseCell = nil;
    [self.reuseableCells enumerateObjectsUsingBlock:^(XMWaterflowViewCell *cell, BOOL *stop) {
        if ([cell.identifier isEqualToString:identifier]) {
            reuseCell = cell;
            *stop = YES;
        }
    }];
    if (reuseCell) {
        [self.reuseableCells removeObject:reuseCell];
    }
    return reuseCell;
}

#pragma mark - 事件处理
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    if (![self.delegate respondsToSelector:@selector(waterflowView:didSelectedAtIndex:)])
        return;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __block NSNumber *selectIndex = nil;
    [self.displayingCells enumerateKeysAndObjectsUsingBlock:^(id key, XMWaterflowViewCell *cell, BOOL *stop) {
        if (CGRectContainsPoint(cell.frame, point)) {
            selectIndex = key;
            *stop = YES;
        }
    }];
    if (selectIndex) {
        [self.delegate waterflowView:self didSelectedAtIndex:selectIndex.unsignedIntegerValue];
    }
}

#pragma mark - 私有方法
/**
 *  返回总共有多少列数据，默认是3行
 */
-(NSUInteger)numOfColumns{
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsInWaterflowView:)]) {
        return [self.dataSource numberOfColumnsInWaterflowView:self];
    }else{
        return 3;
    }
}
/**
 *  返回索引为index的cell的高度，默认是44
 */
-(CGFloat)heightAtIndex:(NSUInteger)index{
    if ([self.delegate respondsToSelector:@selector(waterflowView:heightAtIndex:)]) {
        return [self.delegate waterflowView:self heightAtIndex:index];
    }else{
        return 44;
    }
}

/**
 *  根据type返回cell的间隔，默认是5
 */
-(CGFloat)magrinForType:(XMWaterflowViewMarginType)type{
    
    if ([self.delegate respondsToSelector:@selector(waterflowView:marginForType:)]) {
        return [self.delegate waterflowView:self marginForType:type];
    }else{
        return 5;
    }
}

@end
