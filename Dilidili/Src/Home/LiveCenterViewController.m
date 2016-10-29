//
//  LiveCenterViewController.m
//  Dilidili
//
//  Created by iMac on 2016/10/28.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LiveCenterViewController.h"
#import "LiveCaptureViewController.h"
#import "LiveFilterCaptureViewController.h"
#import "LiveCenterCell.h"
#import "LiveCenterSectionHeader.h"

@interface LiveCenterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArr;

@end

@implementation LiveCenterViewController

static NSString *const kliveCenterCellID = @"LiveCenterCell";
static NSString *const kliveCenterSectionHeaderID = @"LiveCenterSectionHeader";

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBgColor;
    
    [self configureData];
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureNavigationItem];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

- (void)configureData
{
    _dataArr = @[@{@"title":@"记忆之扉", @"data":@[@{@"icon":@"live_my_room", @"title":@"我的直播间"}, @{@"icon":@"live_attion_ico", @"title":@"关注主播"}, @{@"icon":@"live_history_ico", @"title":@"观看记录"}]}, @{@"title":@"副本掉落", @"data":@[@{@"icon":@"live_mineMedal", @"title":@"我的勋章"}, @{@"icon":@"live_honor", @"title":@"我的头衔"}, @{@"icon":@"live_capsule_ico", @"title":@"扭蛋机"}, @{@"icon":@"live_awardInfo_ico", @"title":@"获奖记录"}]}, @{@"title":@"氪金商店", @"data":@[@{@"icon":@"live_vip_ico", @"title":@"购买老爷"}, @{@"icon":@"live_goldseeds_ico", @"title":@"金瓜子购买"}, @{@"icon":@"live_silverseeds_ico", @"title":@"银瓜子兑换"}]}];
}

- (void)createUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView = tableView;
    [self.view addSubview:tableView];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.rowHeight = 64.0;
    [tableView registerClass:[LiveCenterCell class] forCellReuseIdentifier:kliveCenterCellID];
    [tableView registerClass:[LiveCenterSectionHeader class] forHeaderFooterViewReuseIdentifier:kliveCenterSectionHeaderID];
    tableView.tableFooterView = [UIView new];
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 92.0)];
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, tableHeaderView.width, 76.0)];
    userView.backgroundColor = [UIColor whiteColor];
    [tableHeaderView addSubview:userView];
    UIImageView *faceImageView = [[UIImageView alloc] init];
    UIImage *faceImage = [UIImage imageNamed:@"avatar3.jpg"];
    faceImage = [faceImage imageByRoundCornerRadius:faceImage.size.width / 2];
    faceImageView.image = faceImage;
    [userView addSubview:faceImageView];
    [faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userView.mas_left).offset(12.0);
        make.centerY.equalTo(userView.mas_centerY);
        make.width.height.mas_equalTo(54.0);
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.textColor = kTextColor;
    nameLabel.text = @"- ( ゜- ゜)つロ 乾杯~ - bilibili";
    [userView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userView.mas_top).offset(12.0);
        make.left.equalTo(faceImageView.mas_right).offset(6.0);
    }];
    UILabel *levelLabel = [[UILabel alloc] init];
    levelLabel.backgroundColor = kThemeColor;
    levelLabel.font = [UIFont systemFontOfSize:11];
    levelLabel.textColor = [UIColor whiteColor];
    levelLabel.text = @"UL99";
    [userView addSubview:levelLabel];
    [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(4.0);
        make.baseline.equalTo(nameLabel.mas_baseline);
    }];
    UILabel *goldSeedLabel = [[UILabel alloc] init];
    goldSeedLabel.font = [UIFont systemFontOfSize:11];
    goldSeedLabel.textColor = [UIColor grayColor];
    goldSeedLabel.text = @"金瓜子：999";
    [userView addSubview:goldSeedLabel];
    [goldSeedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(nameLabel.mas_bottom).offset(8.0);
    }];
    UILabel *sliverSeedLabel = [[UILabel alloc] init];
    sliverSeedLabel.font = [UIFont systemFontOfSize:11];
    sliverSeedLabel.textColor = [UIColor grayColor];
    sliverSeedLabel.text = @"银瓜子：999";
    [userView addSubview:sliverSeedLabel];
    [sliverSeedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goldSeedLabel.mas_right).offset(8.0);
        make.centerY.equalTo(goldSeedLabel.mas_centerY);
    }];
    UIView *line1 = [[UIView alloc] init];
    line1.userInteractionEnabled = NO;
    line1.backgroundColor = kBorderColor;
    [userView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(userView);
        make.height.mas_equalTo(0.5);
    }];
    UIView *line2 = [[UIView alloc] init];
    line2.userInteractionEnabled = NO;
    line2.backgroundColor = kBorderColor;
    [userView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(userView);
        make.height.mas_equalTo(0.5);
    }];
    tableView.tableHeaderView = tableHeaderView;
}

- (void)configureNavigationItem
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"直播中心";
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"签到" style:UIBarButtonItemStylePlain target:self action:@selector(handleSignIn:)];
    [rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:kliveCenterCellID];
    NSDictionary *dict = self.dataArr[indexPath.section];
    cell.contents = dict[@"data"];
    if (!cell.actionSubject) {
        cell.actionSubject = [RACSubject subject];
#pragma mark Action - 功能选项
        @weakify(self);
        [cell.actionSubject subscribeNext:^(RACTuple *tuple) {
            @strongify(self);
            RACTupleUnpack(LiveCenterCell *x, NSNumber *y) = tuple;
            NSInteger section = [tableView indexPathForCell:x].section;
            NSInteger index = y.integerValue;
            if (section == 0) {
                if (index == 0) {  //我的直播间
//                    LiveCaptureViewController *cvc = [[LiveCaptureViewController alloc] init];
                    LiveFilterCaptureViewController *cvc = [[LiveFilterCaptureViewController alloc] init];
                    [self.navigationController pushViewController:cvc animated:YES];
                }
            }
        }];
    }
    return cell;
}

#pragma mark - TableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LiveCenterSectionHeader *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kliveCenterSectionHeaderID];
    NSDictionary *dict = self.dataArr[section];
    sectionHeader.titleLabel.text = dict[@"title"];
    return sectionHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8.0;
}

#pragma mark - HandleAction
#pragma mark 签到
- (void)handleSignIn:(UIBarButtonItem *)sender
{
    
}

#pragma mark - Others

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
