//
//  BSMultiViewControl.m
//
//  Created by BoxingWoo on 15/6/27.
//  Copyright (c) 2015年 BoxingWoo. All rights reserved.
//

#import "BSMultiViewControl.h"
#import "UIScrollView+MultiViewControlExtension.h"

@interface BSMultiViewControl () <UITableViewDataSource, UITableViewDelegate>
{
    CGFloat _lastOffsetX;
    NSUInteger _clickedIndex;
}

//是否需要在布局子视图
@property (nonatomic, assign) BOOL shouldLayoutSubViews;
//标题个数
@property (nonatomic, assign) NSUInteger itemsCount;
//标题栏
@property (nonatomic, weak) UIView *listBar;

/* 横向滚动式 */
//标题按钮栏滚动视图
@property (nonatomic, weak) UIScrollView *listBarScrollView;
//主滚动视图
@property (nonatomic, weak) UIScrollView *mainScrollView;
//标题按钮选中状态下划线
@property (nonatomic, weak) UIView *selectedButtonBottomLine;
//标题栏与内容滚动视图的分割线
@property (nonatomic, weak) UIView *separatedLine;
//下拉标题按钮框箭头按钮
@property (nonatomic, weak) UIButton *arrowBtn;
//下拉标题按钮栏标签
@property (nonatomic, weak) UILabel *buttonListBoxLabel;
//下拉标题按钮框
@property (nonatomic, weak) UIView *buttonListBox;
//下拉标题按钮框视图
@property (nonatomic, weak) UIControl *buttonListBoxView;

/* 竖向滚动式 */
//标题按钮栏表视图
@property (nonatomic, weak) UITableView *listBarTableView;
//主内容视图
@property (nonatomic ,weak) UIView *mainContentView;

@end

@implementation BSMultiViewControl

static CGFloat selectedButtonBottomLineHeight = 2.0;
static CGFloat arrowButtonWidth = 42.0;
static NSUInteger buttonListBoxColumns = 5;
static CGFloat animateDuration = 0.25;

#pragma mark - Initialization

//构造方法
- (instancetype)initWithFrame:(CGRect)frame andStyle:(BSMultiViewControlStyle)style owner:(UIViewController *)parentViewController
{
    self = [self initWithFrame:frame];
    if (self) {
        _style = style;
        _parentViewController = parentViewController;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

//通用初始化
- (void)commonInit
{
    _style = BSMultiViewControlFixedSpace;
    _shouldLayoutSubViews = NO;
    _selectedIndex = 0;
    _listBarBackgroundColor = [UIColor clearColor];
    _listBarWidth = 0.0;
    _listBarHeight = 0.0;
    _fixedSpace = 12.0;
    _fixedPageSize = 5;
    _showSeparatedLine = YES;
    _showButtonListBox = NO;
    _bounces = YES;
    _scrollEnabled = YES;
    _buttonCellRowHeight = 44.0;
    _buttonCellLineColor = [UIColor colorWithWhite:203 / 255.0 alpha:1.0];
    _selectedButtonCellLineColor = _buttonCellLineColor;
    _lastOffsetX = 0.0;
    _clickedIndex = 0;
}

//创建标题栏
- (void)createListBar
{
    UIView *listBar = [[UIView alloc] init];
    _listBar = listBar;
    [self addSubview:listBar];
    listBar.backgroundColor = self.listBarBackgroundColor;
    
    //创建标题栏滚动视图
    UIScrollView *listBarScrollView = [[UIScrollView alloc] init];
    _listBarScrollView = listBarScrollView;
    [listBar addSubview:listBarScrollView];
    listBarScrollView.showsHorizontalScrollIndicator = NO;
    listBarScrollView.showsVerticalScrollIndicator = NO;
    listBarScrollView.bounces = _bounces;
    listBarScrollView.alwaysBounceHorizontal = _bounces;
    
    if (_showButtonListBox) {
        //箭头按钮
        UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _arrowBtn = arrowBtn;
        [self.listBar addSubview:arrowBtn];
        arrowBtn.backgroundColor = self.listBarBackgroundColor;
        arrowBtn.alpha = 0.98;
        [arrowBtn setImage:[self imageFromCustomBundle:@"ic_pinpai_arrow1@2x"] forState:UIControlStateNormal];
        [arrowBtn setImage:[self imageFromCustomBundle:@"ic_pinpai_arrow2@2x"] forState:UIControlStateSelected];
        [arrowBtn addTarget:self action:@selector(showButtonListBox:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < _itemsCount; i++) {
        UIButton *button = [self.dataSource multiViewControl:self buttonAtIndex:i];
        [self.listBarScrollView addSubview:button];
        [buttons addObject:button];
        button.tag = 10000 + i;
        [button addTarget:self action:@selector(handleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    _buttons = buttons;
    listBarScrollView.synScrollingContentViews = self.buttons;
    
    if (_selectedButtonBottomLineColor) {
        UIView *selectedButtonBottomLine = [[UIView alloc] init];
        _selectedButtonBottomLine = selectedButtonBottomLine;
        [self.listBarScrollView addSubview:selectedButtonBottomLine];
        selectedButtonBottomLine.backgroundColor = _selectedButtonBottomLineColor;
    }
    
    [self createMainScrollView];
    
    if (_showSeparatedLine) {
        UIView *separatedLine = [[UIView alloc] init];
        _separatedLine = separatedLine;
        [self addSubview:separatedLine];
        separatedLine.userInteractionEnabled = NO;
        separatedLine.backgroundColor = [UIColor colorWithWhite:203 / 255.0 alpha:1.0];
    }
}

//创建竖向列表式标题栏
- (void)createVerticalListBar
{
    UIView *listBar = [[UIView alloc] initWithFrame:CGRectZero];
    _listBar = listBar;
    [self addSubview:listBar];
    listBar.backgroundColor = self.listBarBackgroundColor;
    
    //设置表视图
    UITableView *listBarTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _listBarTableView = listBarTableView;
    [listBar addSubview:listBarTableView];
    
    listBarTableView.dataSource = self;
    listBarTableView.delegate = self;
    listBarTableView.backgroundColor = [UIColor clearColor];
    listBarTableView.rowHeight = _buttonCellRowHeight;
    listBarTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listBarTableView.showsVerticalScrollIndicator = NO;
    NSMutableArray *buttonCells = [[NSMutableArray alloc] init];
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < _itemsCount; i++) {
        UIButton *button = [self.dataSource multiViewControl:self buttonAtIndex:i];
        button.tag = 10000 + i;
        [button addTarget:self action:@selector(handleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:button];
        BSMultiViewControlButtonCell *cell = [[BSMultiViewControlButtonCell alloc] initWithTitleButton:button];
        cell.rightSeparatedLine.backgroundColor = self.buttonCellLineColor.CGColor;
        cell.bottomSeparatedLine.backgroundColor = self.buttonCellLineColor.CGColor;
        [buttonCells addObject:cell];
    }
    _buttonCells = buttonCells;
    
    [self createMainContentView];
}

//创建主滚动视图
- (void)createMainScrollView
{
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _mainScrollView = mainScrollView;
    [self addSubview:mainScrollView];
    
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.pagingEnabled = YES;
    mainScrollView.bounces = NO;
    mainScrollView.delegate = self;
    mainScrollView.scrollEnabled = _scrollEnabled;
    
    //添加子视图控制器和内容视图
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < _itemsCount; i++) {
        UIViewController *vc = [self.dataSource multiViewControl:self viewControllerAtIndex:i];
        [viewControllers addObject:vc];
        [self.parentViewController addChildViewController:vc];
        [self.mainScrollView addSubview:vc.view];
    }
    _viewControllers = viewControllers;
}

//创建主内容视图
- (void)createMainContentView
{
    UIView *mainContentView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.listBar.bounds), 0, CGRectGetWidth(self.bounds) - CGRectGetWidth(self.listBar.bounds), CGRectGetHeight(self.bounds))];
    _mainContentView = mainContentView;
    [self addSubview:mainContentView];
    
    //添加子视图控制器和内容视图
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < _itemsCount; i++) {
        UIViewController *vc = [self.dataSource multiViewControl:self viewControllerAtIndex:i];
        [viewControllers addObject:vc];
        [self.parentViewController addChildViewController:vc];
        vc.view.frame = self.mainContentView.bounds;
    }
    _viewControllers = viewControllers;
}

//布局子视图
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_style != BSMultiViewControlVertical) {
        if (_listBarWidth == 0) _listBarWidth = CGRectGetWidth(self.bounds);
        if (_listBarHeight == 0) _listBarHeight = 36.0;
        self.listBar.frame = CGRectMake((CGRectGetWidth(self.bounds) - _listBarWidth) / 2, 0, _listBarWidth, _listBarHeight);
        if (_showButtonListBox) {
            self.arrowBtn.frame = CGRectMake(_listBarWidth - arrowButtonWidth, 0, arrowButtonWidth, _listBarHeight);
            self.listBarScrollView.frame = CGRectMake(0, 0, _listBarWidth - arrowButtonWidth, _listBarHeight);
        }else {
            self.listBarScrollView.frame = self.listBar.bounds;
        }
        if (_showSeparatedLine) {
            self.separatedLine.frame = CGRectMake(0, _listBarHeight - 0.5, CGRectGetWidth(self.bounds), 0.5);
        }
        self.mainScrollView.frame = CGRectMake(0, _listBarHeight, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - _listBarHeight);
        
        UIButton *selectedBtn = nil;
        if (_style == BSMultiViewControlFixedSpace) {
            CGFloat totalWidth = _fixedSpace / 2;
            for (NSInteger i = 0; i < _itemsCount; i++) {
                UIButton *button = self.buttons[i];
                
                //适配
                [button.titleLabel sizeToFit];
                [button sizeToFit];
                button.center = CGPointMake(totalWidth + CGRectGetWidth(button.bounds) / 2, self.listBarScrollView.center.y);
                if (i == _itemsCount - 1) {
                    totalWidth += CGRectGetWidth(button.bounds) + _fixedSpace / 2;
                }else {
                    totalWidth += CGRectGetWidth(button.bounds) + _fixedSpace;
                }
            }
            CGSize contentSize = CGSizeMake(totalWidth, CGRectGetHeight(self.listBarScrollView.bounds));
            self.listBarScrollView.contentSize = contentSize.width > CGRectGetWidth(self.listBarScrollView.bounds) ? contentSize : self.listBarScrollView.bounds.size;
            
            selectedBtn = self.buttons[_selectedIndex];
            
        }else if (_style == BSMultiViewControlFixedPageSize) {
            CGFloat width = CGRectGetWidth(self.listBarScrollView.bounds) / _fixedPageSize;
            for (NSInteger i = 0; i < _itemsCount; i++) {
                UIButton *button = self.buttons[i];
                
                //适配
                [button.titleLabel sizeToFit];
                [button sizeToFit];
                CGFloat buttonHeight = CGRectGetHeight(button.bounds);
                button.frame = CGRectMake(i * width, (CGRectGetHeight(self.listBarScrollView.bounds) - buttonHeight) / 2, width, buttonHeight);
            }
            CGSize contentSize = CGSizeMake(width * self.itemsCount, CGRectGetHeight(self.listBarScrollView.bounds));
            self.listBarScrollView.contentSize = contentSize.width > CGRectGetWidth(self.listBarScrollView.bounds) ? contentSize : self.listBarScrollView.bounds.size;
            
            selectedBtn = self.buttons[_selectedIndex];
        }
        
        CGFloat width = CGRectGetWidth(self.mainScrollView.bounds);
        CGFloat height = CGRectGetHeight(self.mainScrollView.bounds);
        for (NSInteger i = 0; i < _itemsCount; i++) {
            UIViewController *vc = self.viewControllers[i];
            vc.view.frame = CGRectMake(i * width, 0, width, height);
        }
        self.mainScrollView.contentSize = CGSizeMake(width * self.itemsCount, height);
        [self.mainScrollView setContentOffset:CGPointMake(_selectedIndex * CGRectGetWidth(self.mainScrollView.bounds), 0)];
        if (self.style == BSMultiViewControlFixedSpace) {
            
            self.selectedButtonBottomLine.frame = CGRectMake(selectedBtn.frame.origin.x + (CGRectGetWidth(selectedBtn.bounds) - CGRectGetWidth(selectedBtn.titleLabel.bounds)) / 2, CGRectGetHeight(self.listBarScrollView.bounds) - selectedButtonBottomLineHeight, CGRectGetWidth(selectedBtn.titleLabel.bounds), selectedButtonBottomLineHeight);
            
        }else if (self.style == BSMultiViewControlFixedPageSize) {
            
            self.selectedButtonBottomLine.frame = CGRectMake(selectedBtn.frame.origin.x, CGRectGetHeight(self.listBarScrollView.bounds) - selectedButtonBottomLineHeight, CGRectGetWidth(selectedBtn.bounds), selectedButtonBottomLineHeight);
            
        }
    }else {
        if (_listBarWidth == 0) _listBarWidth = 84.0;
        if (_listBarHeight == 0) _listBarHeight = CGRectGetHeight(self.bounds);
        self.listBar.frame = CGRectMake(0, (CGRectGetHeight(self.bounds) - _listBarHeight) / 2, _listBarWidth, _listBarHeight);
        self.listBarTableView.frame = self.listBar.bounds;
        self.mainContentView.frame = CGRectMake(_listBarWidth, 0, CGRectGetWidth(self.bounds) - _listBarWidth, CGRectGetHeight(self.bounds));
        
        for (NSInteger i = 0; i < _itemsCount; i++) {
            UIViewController *vc = self.viewControllers[i];
            vc.view.frame = self.mainContentView.bounds;
        }
        [self.listBarTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    if (self.shouldLayoutSubViews) {
        self.shouldLayoutSubViews = NO;
        //设置选中
        self.selectedIndex = _selectedIndex;
    }
}

#pragma mark - Setter

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    if (self.viewControllers.count > selectedIndex) {
        if (self.style != BSMultiViewControlVertical) {
            [self.mainScrollView setContentOffset:CGPointMake(selectedIndex * CGRectGetWidth(self.mainScrollView.bounds), 0)];
            [self synSelectingAction:selectedIndex];
            if ([self.delegate respondsToSelector:@selector(multiViewControl:didSelectViewController:atIndex:)]) {
                [self.delegate multiViewControl:self didSelectViewController:self.viewControllers[selectedIndex] atIndex:selectedIndex];
            }
        }else {
            [self synSelectingAction:selectedIndex];
        }
    }
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.buttonCells[indexPath.row];
}

#pragma mark - Utility

//加载数据
- (void)reloadData
{
    if (!_dataSource || !_parentViewController) {
        return;
    }
    
    [self.viewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _viewControllers = nil;
    _buttonCells = nil;
    _buttons = nil;
    _clickedIndex = 0;
    _itemsCount = [self.dataSource numberOfItemsInMultiViewControl:self];
    if (_itemsCount) {
        if (_style != BSMultiViewControlVertical) {
            [self createListBar];
        }else {
            [self createVerticalListBar];
        }
        
        _shouldLayoutSubViews = YES;
    }
}

//更新视图
- (void)performUpdatesWithAnimateDuration:(NSTimeInterval)duration updates:(void (^)(BSMultiViewControl *))updates completion:(void (^)())completion
{
    if (duration == 0) {
        if (updates) {
            updates(self);
        }
        if (completion) {
            completion();
        }
    }else {
        [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (updates) {
                updates(self);
            }
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    }
}

//获取资源包图片
- (UIImage *)imageFromCustomBundle:(NSString *)imageName
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"BSMultiViewControl" ofType:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithPath:bundlePath];
    NSString *imagePath = [imageBundle pathForResource:imageName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:imagePath];
}

//展示标题按钮框
- (void)showButtonListBox:(UIButton *)btn
{
    btn.selected = !btn.isSelected;
    if (btn.isSelected) {
        
        //标题框背景视图
        UIControl *buttonListBoxView = [[UIControl alloc] initWithFrame:CGRectMake(0, self.mainScrollView.frame.origin.y, CGRectGetWidth(self.mainScrollView.bounds), CGRectGetHeight(self.mainScrollView.bounds))];
        _buttonListBoxView = buttonListBoxView;
        [self addSubview:buttonListBoxView];
        buttonListBoxView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [buttonListBoxView addTarget:self action:@selector(dismissButtonListBox) forControlEvents:UIControlEventTouchUpInside];
        
        //标题框标签
        UIButton *btnModel = self.buttons.firstObject;
        UILabel *buttonListBoxLabel = [[UILabel alloc] init];
        _buttonListBoxLabel = buttonListBoxLabel;
        [self.listBar addSubview:buttonListBoxLabel];
        buttonListBoxLabel.font = btnModel.titleLabel.font;
        buttonListBoxLabel.textColor = [btnModel titleColorForState:UIControlStateNormal];
        buttonListBoxLabel.text = NSLocalizedString(@"全部分类", nil);
        buttonListBoxLabel.alpha = 0;
        [buttonListBoxLabel sizeToFit];
        buttonListBoxLabel.center = CGPointMake(12 + CGRectGetWidth(buttonListBoxLabel.bounds) / 2, CGRectGetHeight(self.listBar.bounds) / 2);
        
        
        //标题框
        UIView *buttonListBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(buttonListBoxView.bounds), 0)];
        _buttonListBox = buttonListBox;
        buttonListBox.backgroundColor = [UIColor whiteColor];
        [buttonListBoxView addSubview:buttonListBox];
        
        self.listBarScrollView.hidden = YES;
        CGFloat x = buttonListBox.frame.size.width / buttonListBoxColumns;
        CGFloat y = 40.0;
        NSInteger rows = (_itemsCount % buttonListBoxColumns == 0 ? _itemsCount / buttonListBoxColumns : _itemsCount / buttonListBoxColumns + 1);
        
        [UIView animateWithDuration:animateDuration animations:^{
            buttonListBoxLabel.alpha = 1.0;
            buttonListBox.frame = CGRectMake(buttonListBox.frame.origin.x, buttonListBox.frame.origin.y, CGRectGetWidth(buttonListBox.bounds), y * rows);
        } completion:^(BOOL finished) {
            //添加按钮
            for (NSInteger i = 0; i < self.itemsCount; i++) {
                UIButton *buttonModel = self.buttons[i];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = 100 + i;
                button.frame = CGRectMake(i % buttonListBoxColumns * x , i / buttonListBoxColumns * y, x, y);
                [button setTitleColor:[buttonModel titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
                [button setTitleColor:[buttonModel titleColorForState:UIControlStateSelected] forState:UIControlStateSelected];
                button.titleLabel.font = buttonModel.titleLabel.font;
                button.titleLabel.textAlignment = NSTextAlignmentCenter;
                [button setTitle:[buttonModel titleForState:UIControlStateNormal] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(handleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                if (i == _selectedIndex) {
                    CGRect rect = CGRectMake(0, CGRectGetHeight(button.bounds) - selectedButtonBottomLineHeight, button.bounds.size.width, selectedButtonBottomLineHeight);
                    UIGraphicsBeginImageContext(button.bounds.size);
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    CGContextSetFillColorWithColor(context, self.selectedButtonBottomLineColor.CGColor);
                    CGContextFillRect(context, rect);
                    UIImage *selectedBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    [button setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
                    button.selected = YES;
                }
                [buttonListBox addSubview:button];
            }
            
        }];
    }else {
        [self dismissButtonListBox];
    }
}

//移除标题按钮框
- (void)dismissButtonListBox
{
    self.arrowBtn.selected = NO;
    for (UIView *subview in self.buttonListBox.subviews) {
        [subview removeFromSuperview];
    }
    [UIView animateWithDuration:animateDuration animations:^{
        self.buttonListBoxLabel.alpha = 0;
        self.buttonListBox.frame = CGRectMake(self.buttonListBox.frame.origin.x, self.buttonListBox.frame.origin.y, CGRectGetWidth(self.buttonListBox.bounds), 0);
    } completion:^(BOOL finished) {
        self.listBarScrollView.hidden = NO;
        [self.buttonListBoxView removeFromSuperview];
    }];
}

//点击标题按钮
- (void)handleButtonClick:(UIButton *)btn
{
    NSInteger index = btn.tag;
    if (index < 10000) {
        btn.selected = YES;
        index -= 100;
        [self dismissButtonListBox];
        
    }else {
        index -= 10000;
    }
    _clickedIndex = index;
    
    if (self.style != BSMultiViewControlVertical) {
        [self.mainScrollView setContentOffset:CGPointMake(index * CGRectGetWidth(self.mainScrollView.bounds), 0) animated:YES];
    }else {
        [self synSelectingAction:index];
    }
}

//同步选中
- (void)synSelectingAction:(NSInteger)index
{
    if (self.style != BSMultiViewControlVertical) {
        
        //取消选中
        for (NSInteger i = 0; i < _itemsCount; i++) {
            UIButton *button = self.buttons[i];
            button.selected = NO;
        }
        
        //设置选中
        UIButton *selectedBtn = self.buttons[index];
        selectedBtn.selected = YES;
        if (self.style == BSMultiViewControlFixedSpace) {
            
            self.selectedButtonBottomLine.frame = CGRectMake(selectedBtn.frame.origin.x + (CGRectGetWidth(selectedBtn.bounds) - CGRectGetWidth(selectedBtn.titleLabel.bounds)) / 2, CGRectGetHeight(self.listBarScrollView.bounds) - selectedButtonBottomLineHeight, CGRectGetWidth(selectedBtn.titleLabel.bounds), selectedButtonBottomLineHeight);
            
        }else if (self.style == BSMultiViewControlFixedPageSize) {
            
            self.selectedButtonBottomLine.frame = CGRectMake(selectedBtn.frame.origin.x, CGRectGetHeight(self.listBarScrollView.bounds) - selectedButtonBottomLineHeight, CGRectGetWidth(selectedBtn.bounds), selectedButtonBottomLineHeight);
            
        }
        
        
        //同步滑动
        if (self.style == BSMultiViewControlFixedSpace) {
            [self.listBarScrollView edgeSynScrollByIndexOfSubview:index andItemSpace:_fixedSpace];
        }else if (self.style == BSMultiViewControlFixedPageSize) {
            [self.listBarScrollView centerSynScrollByIndexOfSubview:index andPageSize:_fixedPageSize];
        }
        
    }else {
        //取消选中
        for (NSInteger i = 0; i < self.itemsCount; i++) {
            BSMultiViewControlButtonCell *cell = self.buttonCells[i];
            cell.bottomSeparatedLine.backgroundColor = self.buttonCellLineColor.CGColor;
            if (cell.titleButton.isSelected) {
                cell.titleButton.selected = NO;
//                cell.rightSeparatedLine.hidden = NO;
                cell.rightSeparatedLine.backgroundColor = self.buttonCellLineColor.CGColor;
                UIViewController *vc = self.viewControllers[i];
                [vc.view removeFromSuperview];
            }
        }
        
        //设置选中
        BSMultiViewControlButtonCell *selectedCell = self.buttonCells[index];
        selectedCell.titleButton.selected = YES;
//        selectedCell.rightSeparatedLine.hidden = YES;
        if (self.selectedButtonCellLineColor) {
            selectedCell.rightSeparatedLine.backgroundColor = self.selectedButtonCellLineColor.CGColor;
            selectedCell.bottomSeparatedLine.backgroundColor = self.selectedButtonCellLineColor.CGColor;
            if (index > 0) {
                BSMultiViewControlButtonCell *lastCell = self.buttonCells[index - 1];
                lastCell.bottomSeparatedLine.backgroundColor = self.selectedButtonCellLineColor.CGColor;
            }
        }
        UIViewController *vc = self.viewControllers[index];
        [self.mainContentView addSubview:vc.view];
        
        //顶格滑动
        [self.listBarTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        if ([self.delegate respondsToSelector:@selector(multiViewControl:didSelectViewController:atIndex:)]) {
            [self.delegate multiViewControl:self didSelectViewController:self.viewControllers[index] atIndex:index];
        }
    }
    
    _selectedIndex = index;
    _clickedIndex = index;
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.mainScrollView && self.selectedButtonBottomLineColor) {
        
        CGFloat offsetX = scrollView.contentOffset.x;
        if (offsetX <= 0 || offsetX >= scrollView.contentSize.width) {
            return;
        }
        
        CGFloat offsetXDelta = offsetX - _lastOffsetX;
        BOOL isForward = offsetXDelta >= 0 ? YES : NO;
        NSUInteger index;
        UIButton *targetBtn;
        CGFloat v1;
        if (_clickedIndex == _selectedIndex) {
            if (isForward) {
                _selectedIndex == self.buttons.count - 1 ? (index = self.buttons.count - 2) : (index = _selectedIndex);
                targetBtn = self.buttons[index + 1];
            }else {
                _selectedIndex == 0 ? (index = 1) : (index = _selectedIndex);
                targetBtn = self.buttons[index - 1];
            }
            v1 = isForward ? CGRectGetWidth(scrollView.bounds) : -CGRectGetWidth(scrollView.bounds);
        }else {
            index = _selectedIndex;
            targetBtn = self.buttons[_clickedIndex];
            v1 = (NSInteger)(_clickedIndex - index) * CGRectGetWidth(scrollView.bounds);
        }
        UIButton *selectedBtn = self.buttons[index];
        CGFloat v2;
        if (self.style == BSMultiViewControlFixedSpace) {
            v2 = (targetBtn.frame.origin.x + (CGRectGetWidth(targetBtn.bounds) - CGRectGetWidth(targetBtn.titleLabel.bounds)) / 2) - (selectedBtn.frame.origin.x + (CGRectGetWidth(selectedBtn.bounds) - CGRectGetWidth(selectedBtn.titleLabel.bounds)) / 2);
        }else if (self.style == BSMultiViewControlFixedPageSize) {
            v2 = (targetBtn.frame.origin.x - selectedBtn.frame.origin.x);
        }
        CGFloat originXDelta = offsetXDelta / v1 * v2;
        self.selectedButtonBottomLine.frame = CGRectMake(self.selectedButtonBottomLine.frame.origin.x + originXDelta, self.selectedButtonBottomLine.frame.origin.y, CGRectGetWidth(self.selectedButtonBottomLine.bounds), CGRectGetHeight(self.selectedButtonBottomLine.bounds));
        
        _lastOffsetX = offsetX;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.mainScrollView) {
        NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
        [self synSelectingAction:page];
        if ([self.delegate respondsToSelector:@selector(multiViewControl:didSelectViewController:atIndex:)]) {
            [self.delegate multiViewControl:self didSelectViewController:self.viewControllers[page] atIndex:page];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.mainScrollView) {
        NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
        [self synSelectingAction:page];
        if ([self.delegate respondsToSelector:@selector(multiViewControl:didSelectViewController:atIndex:)]) {
            [self.delegate multiViewControl:self didSelectViewController:self.viewControllers[page] atIndex:page];
        }
    }
}

@end
