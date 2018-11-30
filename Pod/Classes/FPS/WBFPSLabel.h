//
//  WBFPSLabel.h
//  Weiboad
//
//  Created by penghui8 on 2018/4/27.
//  Copyright © 2018年 Only·io All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Show Screen FPS...
 
 The maximum fps in OSX/iOS Simulator is 60.00.
 The maximum fps on iPhone is 59.97.
 The maxmium fps on iPad is 60.0.
 */
@interface WBFPSLabel : UILabel

+ (void)wb_showFPSInView:(UIView *)view frame:(CGRect)frame;

@end
