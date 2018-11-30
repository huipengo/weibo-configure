//
//  WBServiceConfigureController.h
//  Weiboad
//
//  Created by penghui8 on 2018/5/3.
//  Copyright © 2018年 weibo. All rights reserved.
//

#import <UIKit/UIKit.h>

CG_EXTERN void wb_presentServiceViewController(UIViewController *sourceViewController);
CG_EXTERN void wb_pushServiceViewController(UIViewController *sourceViewController);

typedef void(^WBServiceConfigureCompletion)(BOOL cw_present);

@interface WBServiceConfigureController : UIViewController

@property (nonatomic, assign) BOOL cw_present;

@property (nonatomic, assign) BOOL wb_push;

@property (nonatomic, copy) WBServiceConfigureCompletion configureCompletion;

@end
