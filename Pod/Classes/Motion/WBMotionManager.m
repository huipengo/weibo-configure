//
//  WBMotionManager.m
//  Weiboad
//
//  Created by penghui8 on 2018/4/28.
//  Copyright © 2018年 Only·io All rights reserved.
//

#import "WBMotionManager.h"
#import <FLEXManager.h>
#import <WBFPSLabel.h>
#import <WBServiceConfigureController.h>

@implementation WBMotionManager

+ (void)wb_motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event sourceViewController:(UIViewController *)sourceViewController {
    [self.class wb_motionEnded:motion withEvent:event actionCompletion:^{
        wb_presentServiceViewController(sourceViewController);
    }];
}

+ (void)wb_motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event actionCompletion:(void(^)(void))completion {
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        if ([FLEXManager sharedManager].isHidden) {
            [[FLEXManager sharedManager] showExplorer];
            [FLEXManager sharedManager].customActionCompletion = ^{
                !completion?:completion();
            };
            UIWindow *explorerWindow = [FLEXManager sharedManager].explorerWindow;
            CGRect frame = CGRectMake(15.0f, [UIScreen mainScreen].bounds.size.height - 49.0f - 20.0f, 0.0f, 0.0f);
            [WBFPSLabel wb_showFPSInView:explorerWindow frame:frame];
        }
    }
}

@end
