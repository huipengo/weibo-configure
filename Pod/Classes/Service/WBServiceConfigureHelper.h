//
//  WBServiceConfigureHelper.h
//  Weiboad
//
//  Created by penghui8 on 2018/5/3.
//  Copyright © 2018年 weibo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBServiceConfigureHelper : NSObject

+ (void)wb_showServiceConfigureViewController:(UIViewController *)viewController
                                   completion:(void(^)(NSString *name, NSString *host))completion;

void wb_showText(UIView *view, NSString *message);

@end
