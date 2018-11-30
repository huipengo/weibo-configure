//
//  WBMotionManager.h
//  Weiboad
//
//  Created by penghui8 on 2018/4/28.
//  Copyright © 2018年 Only·io All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBMotionManager : NSObject

+ (void)wb_motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event sourceViewController:(UIViewController *)sourceViewController;

+ (void)wb_motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event actionCompletion:(void(^)(void))completion;

@end
