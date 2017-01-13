//
//  DdVideoInfoViewController.m
//  Dilidili
//
//  Created by iMac on 16/9/13.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdVideoInfoViewController.h"
#import "DdVideoInfoViewModel.h"

@interface DdVideoInfoViewController ()

/** 视频信息视图模型 */
@property (nonatomic, strong) DdVideoInfoViewModel *viewModel;

@end

@implementation DdVideoInfoViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBgColor;
    
    [self bindViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

- (void)bindViewModel
{
    [super bindViewModel];
    [RACObserve(self.viewModel, infoSignal) subscribeNext:^(RACSignal *infoSignal) {
        if (infoSignal != nil) {
            [infoSignal subscribeNext:^(id  _Nullable x) {
                
            }];
        }
    }];
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
