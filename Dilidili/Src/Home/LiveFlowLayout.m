//
//  LiveFlowLayout.m
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LiveFlowLayout.h"
#import "LiveViewModel.h"

@interface LiveFlowLayout ()

/**
 直播列表节头大小
 */
@property (nonatomic) CGSize sectionHeaderSize;
/**
 直播列表头部大小
 */
@property (nonatomic) CGSize headerViewSize;
/**
 直播列表尾部大小
 */
@property (nonatomic) CGSize footerViewSize;
/**
 布局属性数组
 */
@property (nonatomic, strong) NSMutableArray *layoutAttributes;
/**
 滚动内容范围
 */
@property (nonatomic, assign) CGSize contentSize;

@end

@implementation LiveFlowLayout

NSString *const LiveCollectionElementKindHeaderView = @"LiveHeaderView";
NSString *const LiveCollectionElementKindFooterView = @"LiveFooterView";

- (instancetype)init
{
    if (self = [super init]) {
        self.minimumLineSpacing = 10.0;
        self.minimumInteritemSpacing = 10.0;
        self.itemSize = CGSizeMake(widthEx(144.0), heightEx(92.0) + 36.0);
        self.sectionHeaderSize = CGSizeMake(kScreenWidth, 30.0);
        self.headerViewSize = CGSizeMake(kScreenWidth, heightEx(96.0) + 86.0);
        self.footerViewSize = CGSizeMake(kScreenWidth, 46.0);
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
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

- (void)prepareLayout
{
    [super prepareLayout];
    [self.layoutAttributes removeAllObjects];
    if (self.viewModels.count) {
        UICollectionViewLayoutAttributes *headerViewLayoutAttribute = [self layoutAttributesForSupplementaryViewOfKind:LiveCollectionElementKindHeaderView atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self.layoutAttributes addObject:headerViewLayoutAttribute];
        
        UICollectionViewLayoutAttributes *footerViewLayoutAttribute = [self layoutAttributesForSupplementaryViewOfKind:LiveCollectionElementKindFooterView atIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.viewModels.count - 1]];
        [self.layoutAttributes addObject:footerViewLayoutAttribute];
        
        for (NSInteger i = 0; i < self.viewModels.count; i++) {
            NSIndexPath *indexPath = nil;
            indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            UICollectionViewLayoutAttributes *sectionHeaderLayoutAttribute = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
            [self.layoutAttributes addObject:sectionHeaderLayoutAttribute];
            
            LiveViewModel *viewModel = self.viewModels[i];
            NSUInteger count = 0;
            if (i == 0) {
                count = viewModel.model.lives.count;
            }else {
                count = 4;
            }
            for (NSInteger j = 0; j < count; j++) {
                indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                UICollectionViewLayoutAttributes *cellLayoutAttribute = [self layoutAttributesForItemAtIndexPath:indexPath];
                [self.layoutAttributes addObject:cellLayoutAttribute];
            }
        }
        
        self.contentSize = CGSizeMake(kScreenWidth, footerViewLayoutAttribute.frame.origin.y + footerViewLayoutAttribute.frame.size.height);
    }
}

- (CGSize)collectionViewContentSize
{
    return self.contentSize;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.layoutAttributes.copy;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    if ([elementKind isEqualToString:LiveCollectionElementKindHeaderView]) {
        
        layoutAttribute.frame = CGRectMake(0, 0, self.headerViewSize.width, self.headerViewSize.height);
        
    }else if ([elementKind isEqualToString:LiveCollectionElementKindFooterView]) {
        
        CGFloat originY = self.headerViewSize.height + self.viewModels.count * (self.sectionHeaderSize.height + self.sectionInset.top + self.sectionInset.bottom);
        for (NSInteger i = 0; i < self.viewModels.count; i++) {
            NSUInteger count = 0;
            if (i == 0) {
                LiveViewModel *viewModel = self.viewModels[i];
                count = viewModel.model.lives.count;
            }else {
                count = 4;
            }
            originY += ceil(count / 2.0) * (self.itemSize.height + self.minimumLineSpacing) - self.minimumLineSpacing;
        }
        layoutAttribute.frame = CGRectMake(0, originY, self.footerViewSize.width, self.footerViewSize.height);
        
    }else if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        CGFloat originY = self.headerViewSize.height + indexPath.section * (self.sectionHeaderSize.height + self.sectionInset.top + self.sectionInset.bottom);
        for (NSInteger i = 0; i < indexPath.section; i++) {
            NSUInteger count = 0;
            if (i == 0) {
                LiveViewModel *viewModel = self.viewModels[i];
                count = viewModel.model.lives.count;
            }else {
                count = 4;
            }
            originY += ceil(count / 2.0) * (self.itemSize.height + self.minimumLineSpacing) - self.minimumLineSpacing;
        }
        layoutAttribute.frame = CGRectMake(0, originY, self.sectionHeaderSize.width, self.sectionHeaderSize.height);
        
    }
    return layoutAttribute;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat originX = 0;
    if (indexPath.item % 2 == 0) {
        originX = self.sectionInset.left;
    }else {
        originX = kScreenWidth - self.sectionInset.right - self.itemSize.width;
    }
    UICollectionViewLayoutAttributes *sectionHeaderLayoutAttribute = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    CGFloat originY = sectionHeaderLayoutAttribute.frame.origin.y + sectionHeaderLayoutAttribute.frame.size.height + self.sectionInset.top;
    NSUInteger row = indexPath.item / 2;
    originY += row * (self.itemSize.height + self.minimumLineSpacing);
    layoutAttribute.frame = CGRectMake(originX, originY,self.itemSize.width, self.itemSize.height);
    
    return layoutAttribute;
}

@end
