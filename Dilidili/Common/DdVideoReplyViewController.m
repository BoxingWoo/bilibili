//
//  DdVideoReplyViewController.m
//  Dilidili
//
//  Created by iMac on 16/9/13.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdVideoReplyViewController.h"
#import "DdReplyViewModel.h"
#import "DdRefreshNormalHeader.h"
#import "DdRefreshActivityIndicatorFooter.h"

@interface DdVideoReplyViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, YYTextKeyboardObserver>

/**
 视频评论视图模型
 */
@property (nonatomic, strong) DdReplyViewModel *viewModel;
/**
 评论视图
 */
@property (nonatomic, weak) UIView *replyView;
/**
 遮罩视图
 */
@property (nonatomic, weak) UIControl *overlayView;
/**
 表视图
 */
@property (nonatomic, weak) UITableView *tableView;
/**
 表头视图
 */
@property (nonatomic, strong) UITableView *tableHeaderView;

/** 热门评论数组 */
@property (nonatomic, copy) NSArray <DdReplyListViewModel *> *hots;
/** 评论列表数组 */
@property (nonatomic, copy) NSArray <DdReplyListViewModel *> *replies;
/** 页面信息 */
@property (nonatomic, copy) NSDictionary *page;
/** 页数 */
@property (nonatomic, assign) NSUInteger pageNum;

@end

@implementation DdVideoReplyViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBgColor;
    
    _pageNum = 1;
    
    [self bindViewModel];
    
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    DDLogWarn(@"%@ dealloc！", [self.class description]);
}

#pragma mark - Initialization

- (void)bindViewModel
{
    [super bindViewModel];
    @weakify(self);
    [RACObserve(self.viewModel, replySignal) subscribeNext:^(RACSignal *replySignal) {
        @strongify(self);
        if (replySignal != nil) {
            [self refreshData:replySignal];
        }
    }];
}

- (void)createUI
{
    UIView *replyView = [[UIView alloc] init];
    _replyView = replyView;
    replyView.backgroundColor = [UIColor whiteColor];
    
    UIButton *emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    emojiBtn.adjustsImageWhenHighlighted = NO;
    [emojiBtn setImage:[UIImage imageNamed:@"video_emoji"] forState:UIControlStateNormal];
    [emojiBtn setImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateSelected];
    [replyView addSubview:emojiBtn];
    [emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(replyView.mas_right).offset(-12.0);
        make.centerY.equalTo(replyView.mas_centerY);
    }];
    [emojiBtn setContentHuggingPriority:252 forAxis:UILayoutConstraintAxisHorizontal];
    
    UITextField *replyTextField = [[UITextField alloc] init];
    replyTextField.delegate = self;
    replyTextField.borderStyle = UITextBorderStyleNone;
    replyTextField.backgroundColor = kBgColor;
    replyTextField.tintColor = kThemeColor;
    replyTextField.textColor = kTextColor;
    replyTextField.font = [UIFont systemFontOfSize:14];
    replyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    replyTextField.returnKeyType = UIReturnKeySend;
    UIFont *placeholderFont = [UIFont systemFontOfSize:13];
    NSMutableParagraphStyle *style = [replyTextField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    style.minimumLineHeight = replyTextField.font.lineHeight - (replyTextField.font.lineHeight - placeholderFont.lineHeight) / 2;
    [replyTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"说点什么" attributes:@{NSFontAttributeName:placeholderFont, NSForegroundColorAttributeName:[UIColor lightGrayColor], NSParagraphStyleAttributeName:style}]];
    CGFloat margin = 12.0;
    CGFloat height = 30.0;
    replyTextField.layer.cornerRadius = margin;
    replyTextField.layer.masksToBounds = YES;
    replyTextField.layer.borderWidth = 1.0;
    replyTextField.layer.borderColor = kBorderColor.CGColor;
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, margin, height)];
    replyTextField.leftViewMode = UITextFieldViewModeAlways;
    replyTextField.leftView = emptyView;
    replyTextField.rightViewMode = UITextFieldViewModeAlways;
    replyTextField.rightView = emptyView;
    [replyView addSubview:replyTextField];
    [replyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(replyView.mas_left).offset(8.0);
        make.right.equalTo(emojiBtn.mas_left).offset(-8.0);
        make.centerY.equalTo(replyView.mas_centerY);
        make.height.mas_equalTo(height);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.userInteractionEnabled = NO;
    line.backgroundColor = kBorderColor;
    [replyView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(replyView);
        make.height.mas_equalTo(0.5);
    }];
    
#pragma mark Action - 切换表情键盘
    [[emojiBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
        button.selected = !button.isSelected;
        
    }];
    
    [self.view addSubview:replyView];
    [replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(49.0);
    }];
}

#pragma mark - LazyLoad

- (UIControl *)overlayView
{
    if (!_overlayView) {
        UIControl *overlayView = [[UIControl alloc] init];
        _overlayView = overlayView;
        overlayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        [[overlayView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
            [self.view endEditing:YES];
        }];
        [self.view insertSubview:overlayView belowSubview:self.replyView];
        [overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _overlayView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView = tableView;
        [tableView registerClass:[DdVideoReplyCell class] forCellReuseIdentifier:kvideoReplyCellID];
        [tableView registerClass:[DdVideoReplySubCell class] forCellReuseIdentifier:kvideoReplySubCellID];
        [tableView registerClass:[DdVideoReplySectionFooter class] forHeaderFooterViewReuseIdentifier:kvideoReplySectionFooterID];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, -1 / kScreenScale, 0);
        tableView.layoutMargins = UIEdgeInsetsZero;
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView.tableFooterView = [UIView new];
        @weakify(self);
        tableView.mj_header = [DdRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.pageNum = 1;
            [[self.viewModel requestReplyDataByPageNum:self.pageNum] execute:nil];
        }];
        tableView.mj_footer = [DdRefreshActivityIndicatorFooter footerWithRefreshingBlock:^{
            @strongify(self);
            if (self.replies.count < [self.page[@"acount"] unsignedIntegerValue]) {
                self.pageNum++;
                [[self.viewModel requestReplyDataByPageNum:self.pageNum] execute:nil];
            }else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
        [self.view insertSubview:tableView belowSubview:self.replyView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 49, 0));
        }];
    }
    return _tableView;
}

- (UITableView *)tableHeaderView
{
    if (!_tableHeaderView) {
        UITableView *tableHeaderView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0) style:UITableViewStylePlain];
        _tableHeaderView = tableHeaderView;
        [tableHeaderView registerClass:[DdVideoReplyCell class] forCellReuseIdentifier:kvideoReplyCellID];
        [tableHeaderView registerClass:[DdVideoReplySubCell class] forCellReuseIdentifier:kvideoReplySubCellID];
        [tableHeaderView registerClass:[DdVideoReplySectionFooter class] forHeaderFooterViewReuseIdentifier:kvideoReplySectionFooterID];
        tableHeaderView.backgroundColor = [UIColor clearColor];
        tableHeaderView.dataSource = self;
        tableHeaderView.delegate = self;
        tableHeaderView.scrollEnabled = NO;
        tableHeaderView.showsVerticalScrollIndicator = NO;
        tableHeaderView.layoutMargins = UIEdgeInsetsZero;
        tableHeaderView.separatorInset = UIEdgeInsetsZero;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableHeaderView.width, 44.0)];
        footerView.backgroundColor = self.view.backgroundColor;
        UIButton *checkMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        checkMoreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [checkMoreBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
        [checkMoreBtn setTitle:@"更多热门评论>>" forState:UIControlStateNormal];
#pragma mark Action - 更多热门评论
        [[checkMoreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
            
        }];
        [footerView addSubview:checkMoreBtn];
        [checkMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(footerView);
        }];
        UIView *line1 = [[UIView alloc] init];
        line1.userInteractionEnabled = NO;
        line1.backgroundColor = kBorderColor;
        [footerView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerView.mas_left);
            make.right.equalTo(checkMoreBtn.mas_left).offset(-4.0);
            make.centerY.equalTo(checkMoreBtn.mas_centerY);
            make.height.mas_equalTo(0.5);
        }];
        UIView *line2 = [[UIView alloc] init];
        line2.userInteractionEnabled = NO;
        line2.backgroundColor = kBorderColor;
        [footerView addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(checkMoreBtn.mas_right).offset(4.0);
            make.right.equalTo(footerView.mas_right);
            make.centerY.equalTo(checkMoreBtn.mas_centerY);
            make.height.mas_equalTo(0.5);
        }];
        tableHeaderView.tableFooterView = footerView;
    }
    return _tableHeaderView;
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableHeaderView) {
        return self.hots.count;
    }else if (tableView == _tableView) {
        return self.replies.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DdReplyListViewModel *viewModel = nil;
    if (tableView == _tableHeaderView) {
        viewModel = self.hots[section];
    }else if (tableView == _tableView) {
        viewModel = self.replies[section];
    }
    return viewModel != nil ? viewModel.replies.count + 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DdReplyListViewModel *viewModel = nil;
    BOOL isHot = NO;
    if (tableView == _tableHeaderView) {
        viewModel = self.hots[indexPath.section];
        isHot = YES;
    }else if (tableView == _tableView) {
        viewModel = self.replies[indexPath.section];
        isHot = NO;
    }
    
    UITableViewCell *cell = nil;
    @weakify(self);
    if (indexPath.row == 0) {
        DdVideoReplyCell *replyCell = [tableView dequeueReusableCellWithIdentifier:kvideoReplyCellID];
        if (!replyCell.moreSubject) {
            replyCell.moreSubject = [RACSubject subject];
            [replyCell.moreSubject subscribeNext:^(DdVideoReplyCell *x) {
                @strongify(self);
                NSIndexPath *indexPath = [tableView indexPathForCell:x];
                DdReplyListViewModel *vm = nil;
                if (tableView == self.tableHeaderView) {
                    vm = self.hots[indexPath.section];
                }else if (tableView == self.tableView) {
                    vm = self.replies[indexPath.section];
                }
                [self handleMore:vm.model];
            }];
        }
        if (!replyCell.likeSubject) {
            replyCell.likeSubject = [RACSubject subject];
            [replyCell.likeSubject subscribeNext:^(DdVideoReplyCell *x) {
                @strongify(self);
                NSIndexPath *indexPath = [tableView indexPathForCell:x];
                DdReplyListViewModel *vm = nil;
                if (tableView == self.tableHeaderView) {
                    vm = self.hots[indexPath.section];
                }else if (tableView == self.tableView) {
                    vm = self.replies[indexPath.section];
                }
                x.likeBtn.selected = !x.likeBtn.isSelected;
                vm.model.isliked = x.likeBtn.isSelected;
                [self handleLike:vm.model];
            }];
        }
        cell = replyCell;
    }else {
        viewModel = viewModel.replies[indexPath.row - 1];
        DdVideoReplySubCell *subCell = [tableView dequeueReusableCellWithIdentifier:kvideoReplySubCellID];
        if (!subCell.moreSubject) {
            subCell.moreSubject = [RACSubject subject];
            [subCell.moreSubject subscribeNext:^(DdVideoReplySubCell *x) {
                @strongify(self);
                NSIndexPath *indexPath = [tableView indexPathForCell:x];
                DdReplyListViewModel *vm = nil;
                if (tableView == self.tableHeaderView) {
                    vm = self.hots[indexPath.section].replies[indexPath.row - 1];
                }else if (tableView == self.tableView) {
                    vm = self.replies[indexPath.section].replies[indexPath.row - 1];
                }
                [self handleMore:vm.model];
            }];
        }
        cell = subCell;
    }
    [self.viewModel configureCell:cell atIndexPath:indexPath isHot:isHot];
    return cell;
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DdReplyListViewModel *viewModel = nil;
    BOOL isHot = NO;
    if (tableView == _tableHeaderView) {
        viewModel = self.hots[indexPath.section];
        isHot = YES;
    }else if (tableView == _tableView) {
        viewModel = self.replies[indexPath.section];
        isHot = NO;
    }
    if (indexPath.row != 0) {
        viewModel = viewModel.replies[indexPath.row - 1];
    }
    return [self.viewModel heightForCellOnTableView:tableView atIndexPath:indexPath isHot:isHot];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView == _tableHeaderView && section == self.hots.count - 1) {
        return nil;
    }
    
    DdVideoReplySectionFooter *sectionFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kvideoReplySectionFooterID];
    return sectionFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _tableHeaderView && section == self.hots.count - 1) {
        return 0;
    }
    
    return CGFloatFromPixel(1);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DdReplyListViewModel *viewModel = nil;
    if (tableView == self.tableHeaderView) {
        viewModel = self.hots[indexPath.section];
    }else if (tableView == self.tableView) {
        viewModel = self.replies[indexPath.section];
    }
    
}

#pragma mark - HandleAction
#pragma mark 更多
- (void)handleMore:(DdReplyModel *)model
{
    
}

#pragma mark 点赞
- (void)handleLike:(DdReplyModel *)model
{
    
}

#pragma mark - Utility
#pragma mark 计算布局
- (void)layout
{
    CGFloat tableHeaderViewHeight = 0.0;
    for (NSInteger i = 0; i < self.hots.count; i++) {
        DdReplyListViewModel *viewModel = self.hots[i];
        tableHeaderViewHeight += [self.viewModel heightForCellOnTableView:self.tableHeaderView atIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] isHot:YES];
        for (NSInteger j = 0; j < viewModel.replies.count; j++) {
            tableHeaderViewHeight += [self.viewModel heightForCellOnTableView:self.tableHeaderView atIndexPath:[NSIndexPath indexPathForRow:j + 1 inSection:i] isHot:YES];
        }
    }
    tableHeaderViewHeight += self.tableHeaderView.tableFooterView.height;
    self.tableHeaderView.height = tableHeaderViewHeight;
    [self.tableHeaderView reloadData];
    self.tableView.tableHeaderView = self.tableHeaderView;
    [self.tableView reloadData];
}

#pragma mark 刷新数据
- (void)refreshData:(RACSignal *)repliesSignal
{
    [repliesSignal subscribeNext:^(id x) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.hots = self.viewModel.hots;
        self.replies = self.viewModel.replies;
        self.page = self.viewModel.page;
        
        [self layout];
        
    } error:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    self.overlayView.hidden = NO;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.overlayView removeFromSuperview];
    self.overlayView = nil;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    textField.text = nil;
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - YYTextKeyboardObserver

- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
    CGFloat offset = toFrame.origin.y - self.view.height;
    [self.replyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(offset);
    }];
    if (transition.animationDuration != 0) {
        [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.replyView layoutIfNeeded];
        } completion:NULL];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
