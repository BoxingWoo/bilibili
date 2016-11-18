//
//  BangumiFlowLayout.m
//  Dilidili
//
//  Created by iMac on 2016/11/14.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "BangumiFlowLayout.h"
#import "BangumiViewModel.h"

@interface BangumiFlowLayout ()

/**
 番剧网格单元格大小
 */
@property (nonatomic) CGSize girdCellItemSize;
/**
 番剧列表节头大小
 */
@property (nonatomic) CGSize sectionHeaderSize;
/**
 番剧列表节尾大小
 */
@property (nonatomic) CGSize sectionfooterSize;
/**
 番剧列表头部大小
 */
@property (nonatomic) CGSize headerViewSize;
/**
 布局属性数组
 */
@property (nonatomic, strong) NSMutableArray *layoutAttributes;
/**
 推荐布局属性数组
 */
@property (nonatomic, strong) NSMutableArray *recommendLayoutAttributes;
/**
 模型单元格
 */
@property (nonatomic, strong) BangumiListCell *modelCell;

@end

@implementation BangumiFlowLayout

NSString *const kBangumiCollectionElementKindHeaderView = @"BangumiHeaderView";

- (instancetype)init
{
    if (self = [super init]) {
        _viewModelDict = [[NSMutableDictionary alloc] init];
        _refreshType = BangumiFlowLayoutRefreshAll;
        self.minimumLineSpacing = 12.0;
        self.minimumInteritemSpacing = 8.0;
        self.girdCellItemSize = CGSizeMake(widthEx(96), heightEx(128) + 54);
        self.sectionHeaderSize = CGSizeMake(kScreenWidth, 40.0);
        self.sectionfooterSize = CGSizeMake(kScreenWidth, (kScreenWidth - 20) * 0.3 + 20);
        self.headerViewSize = CGSizeMake(kScreenWidth, heightEx(96.0) + 124.0);
        self.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
    }
    return self;
}

- (NSMutableArray *)layoutAttributes
{
    if (!_layoutAttributes) {
        _layoutAttributes = [[NSMutableArray alloc] init];
    }
    return _layoutAttributes;
}

- (NSMutableArray *)recommendLayoutAttributes
{
    if (!_recommendLayoutAttributes) {
        _recommendLayoutAttributes = [[NSMutableArray alloc] init];
    }
    return _recommendLayoutAttributes;
}

- (BangumiListCell *)modelCell
{
    if (!_modelCell) {
        _modelCell = [[BangumiListCell alloc] initWithFrame:CGRectZero];
    }
    return _modelCell;
}

- (void)prepareLayout
{
    [super prepareLayout];
    if (self.refreshType == BangumiFlowLayoutRefreshAll) {
        [self.layoutAttributes removeAllObjects];
    }else {
        [self.layoutAttributes removeObjectsInArray:self.recommendLayoutAttributes];
    }
    [self.recommendLayoutAttributes removeAllObjects];
    
    if (self.refreshType == BangumiFlowLayoutRefreshAll) {
        UICollectionViewLayoutAttributes *headerViewLayoutAttribute = [self layoutAttributesForSupplementaryViewOfKind:kBangumiCollectionElementKindHeaderView atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self.layoutAttributes addObject:headerViewLayoutAttribute];
        
        NSArray *serializing = self.viewModelDict[@"serializing"];
        if (serializing.count) {
            UICollectionViewLayoutAttributes *sectionHeaderLayoutAttribute = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            [self.layoutAttributes addObject:sectionHeaderLayoutAttribute];
            
            UICollectionViewLayoutAttributes *sectionFooterLayoutAttribute = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            [self.layoutAttributes addObject:sectionFooterLayoutAttribute];
            
            for (NSInteger i = 0; i < serializing.count; i++) {
                UICollectionViewLayoutAttributes *cellLayoutAttribute = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                [self.layoutAttributes addObject:cellLayoutAttribute];
            }
        }
        
        NSArray *previous = self.viewModelDict[@"previous"];
        if (previous.count) {
            UICollectionViewLayoutAttributes *sectionHeaderLayoutAttribute = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
            [self.layoutAttributes addObject:sectionHeaderLayoutAttribute];
            
            for (NSInteger i = 0; i < previous.count; i++) {
                UICollectionViewLayoutAttributes *cellLayoutAttribute = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:1]];
                [self.layoutAttributes addObject:cellLayoutAttribute];
            }
        }
    }
    
    NSArray *recommend = self.viewModelDict[@"recommend"];
    if (recommend.count) {
        UICollectionViewLayoutAttributes *sectionHeaderLayoutAttribute = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:2]];
        [self.recommendLayoutAttributes addObject:sectionHeaderLayoutAttribute];
        
        for (NSInteger i = 0; i < recommend.count; i++) {
            UICollectionViewLayoutAttributes *cellLayoutAttribute = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:2]];
            [self.recommendLayoutAttributes addObject:cellLayoutAttribute];
        }
        
        [self.layoutAttributes addObjectsFromArray:self.recommendLayoutAttributes];
    }
}

- (CGSize)collectionViewContentSize
{
    UICollectionViewLayoutAttributes *layoutAttribute = self.layoutAttributes.lastObject;
    return CGSizeMake(kScreenWidth, layoutAttribute.frame.origin.y + layoutAttribute.frame.size.height + self.sectionInset.bottom);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    if ([elementKind isEqualToString:kBangumiCollectionElementKindHeaderView]) {
        
        layoutAttribute.frame = CGRectMake(0, 0, self.headerViewSize.width, self.headerViewSize.height);
        
    }else if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        CGFloat originY = 0;
        if (indexPath.section == 0) {
            originY = self.headerViewSize.height;
        }else if (indexPath.section == 1) {
            CGRect frame = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]].frame;
            NSArray *serializing = self.viewModelDict[@"serializing"];
            NSUInteger row = ceil(serializing.count / 3.0);
            originY = frame.origin.y + frame.size.height + self.sectionInset.top + self.sectionInset.bottom + self.girdCellItemSize.height * row + self.minimumLineSpacing * (row - 1) + self.sectionfooterSize.height;
        }else if (indexPath.section == 2) {
            CGRect frame = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]].frame;
            NSArray *previous = self.viewModelDict[@"previous"];
            NSUInteger row = ceil(previous.count / 3.0);
            originY += frame.origin.y + frame.size.height + self.sectionInset.top + self.sectionInset.bottom + self.girdCellItemSize.height * row + self.minimumLineSpacing * (row - 1);
        }
        
        layoutAttribute.frame = CGRectMake(0, originY, self.sectionHeaderSize.width, self.sectionHeaderSize.height);
        
    }else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        if (indexPath.section == 0) {
            CGFloat originY = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]].frame.origin.y - self.sectionfooterSize.height;
            layoutAttribute.frame = CGRectMake(0, originY, self.sectionfooterSize.width, self.sectionfooterSize.height);
            
        }
    }
    
    return layoutAttribute;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    if (indexPath.section == 0 || indexPath.section == 1) {
        CGFloat inset = (kScreenWidth - (self.sectionInset.left + self.sectionInset.right + 3 * self.girdCellItemSize.width)) / 2;
        CGFloat originX = self.sectionInset.left + indexPath.item % 3 * (self.girdCellItemSize.width + inset);
        CGRect sectionHeaderFrame = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath].frame;
        CGFloat originY = sectionHeaderFrame.origin.y + sectionHeaderFrame.size.height + self.sectionInset.top + indexPath.item / 3 * (self.minimumLineSpacing + self.girdCellItemSize.height);
        layoutAttribute.frame = CGRectMake(originX, originY, self.girdCellItemSize.width, self.girdCellItemSize.height);
    }else {
        CGFloat originX = self.sectionInset.left;
        CGRect sectionHeaderFrame = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath].frame;
        CGFloat originY = sectionHeaderFrame.origin.y + sectionHeaderFrame.size.height + self.sectionInset.top;
        NSArray *recommend = self.viewModelDict[@"recommend"];
        
        for (NSInteger i = 0; i < indexPath.item; i++) {
            BangumiViewModel *viewModel = recommend[i];
            NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:i inSection:indexPath.section];
            originY += self.minimumInteritemSpacing + [viewModel cellSize:self.modelCell atIndexPath:itemIndexPath].height;
        }
        BangumiViewModel *viewModel = recommend[indexPath.item];
        CGSize cellSize = [viewModel cellSize:self.modelCell atIndexPath:indexPath];
        layoutAttribute.frame = CGRectMake(originX, originY, cellSize.width, cellSize.height);
    }
    
    return layoutAttribute;
}

@end
