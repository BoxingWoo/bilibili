//
//  LiveCenterCell.h
//  Dilidili
//
//  Created by iMac on 2016/10/28.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveCenterCell : UITableViewCell

@property (nonatomic, copy) NSArray *contents;
@property (nonatomic, strong) RACSubject *actionSubject;

@end
