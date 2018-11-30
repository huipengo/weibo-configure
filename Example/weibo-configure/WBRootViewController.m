//
//  WBRootViewController.m
//  weibo-configure_Example
//
//  Created by penghui8 on 2018/11/29.
//  Copyright © 2018 penghui8. All rights reserved.
//

#import "WBRootViewController.h"
#import "WBServiceConfigureController.h"
#import "WBMotionManager.h"

@interface WBRootViewController ()

@end

@implementation WBRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)wb_serviceConfigureAction:(id)sender {
    wb_presentServiceViewController(self);
}


#pragma mark -- FLEX 摇一摇
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [WBMotionManager wb_motionEnded:motion
                          withEvent:event
               sourceViewController:self];
    [super motionEnded:motion withEvent:event];
}

@end
