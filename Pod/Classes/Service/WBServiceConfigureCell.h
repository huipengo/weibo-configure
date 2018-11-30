//
//  WBServiceConfigureCell.h
//  Weiboad
//
//  Created by penghui8 on 2018/5/3.
//  Copyright © 2018年 weibo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBServiceItem.h"

@interface WBServiceConfigureCell : UITableViewCell

+ (instancetype)wb_cellNibForTableView:(UITableView * _Nonnull)tableView;

- (void)setItem:(WBServiceItem *)item currentService:(BOOL)currentService;

@end
