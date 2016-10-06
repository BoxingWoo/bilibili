//
//  DdVideoInfoViewController.m
//  Dilidili
//
//  Created by iMac on 16/9/13.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdVideoInfoViewController.h"

@interface DdVideoInfoViewController ()

/** 视频视图模型 */
@property (nonatomic, strong) DdVideoViewModel *videoViewModel;

@end

@implementation DdVideoInfoViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBgColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utility
#pragma mark 请求数据
- (RACSignal *)requestData
{
    RACSignal *infoSignal = [[DdVideoViewModel requestVideoInfoByAid:self.aid from:self.from] execute:nil];
    [infoSignal subscribeNext:^(DdVideoModel *model) {
        
        self.videoViewModel = [[DdVideoViewModel alloc] initWithModel:model];
        
    } error:^(NSError *error) {
        
        
    }];
    return infoSignal;
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
