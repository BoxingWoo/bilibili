//
//  LiveCenterViewModel.m
//  Dilidili
//
//  Created by iMac on 2017/1/12.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import "LiveCenterViewModel.h"

@implementation LiveCenterViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _dataArr = @[@{@"title":@"记忆之扉", @"data":@[@{@"icon":@"live_my_room", @"title":@"我的直播间"}, @{@"icon":@"live_attion_ico", @"title":@"关注主播"}, @{@"icon":@"live_history_ico", @"title":@"观看记录"}]}, @{@"title":@"副本掉落", @"data":@[@{@"icon":@"live_mineMedal", @"title":@"我的勋章"}, @{@"icon":@"live_honor", @"title":@"我的头衔"}, @{@"icon":@"live_capsule_ico", @"title":@"扭蛋机"}, @{@"icon":@"live_awardInfo_ico", @"title":@"获奖记录"}]}, @{@"title":@"氪金商店", @"data":@[@{@"icon":@"live_vip_ico", @"title":@"购买老爷"}, @{@"icon":@"live_goldseeds_ico", @"title":@"金瓜子购买"}, @{@"icon":@"live_silverseeds_ico", @"title":@"银瓜子兑换"}]}];
    }
    return self;
}

#pragma mark 配置单元格
- (void)configureCell:(LiveCenterCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.dataArr[indexPath.section];
    NSArray *contents = dict[@"data"];
    for (NSInteger i = 0; i < cell.buttons.count; i++) {
        BSCentralButton *button = cell.buttons[i];
        NSDictionary *dict = nil;
        if (i < contents.count) {
            dict = contents[i];
        }
        [button setImage:[UIImage imageNamed:dict[@"icon"]] forState:UIControlStateNormal];
        [button setTitle:dict[@"title"] forState:UIControlStateNormal];
    }
}

#pragma mark 配置推荐列表头部视图
- (void)configureSectionHeader:(LiveCenterSectionHeader *)sectionHeader atIndex:(NSInteger)section
{
    NSDictionary *dict = self.dataArr[section];
    sectionHeader.titleLabel.text = dict[@"title"];
}

@end
