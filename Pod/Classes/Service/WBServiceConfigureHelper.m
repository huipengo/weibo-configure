//
//  WBServiceConfigureHelper.m
//  Weiboad
//
//  Created by penghui8 on 2018/5/3.
//  Copyright © 2018年 weibo. All rights reserved.
//

#import "WBServiceConfigureHelper.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation WBServiceConfigureHelper

+ (void)wb_showServiceConfigureViewController:(UIViewController *)viewController completion:(void(^)(NSString *name, NSString *host))completion {
    NSString *title   = @"环境配置";
    NSString *message = @"域名不要以 / 结尾";
    NSString *example = @"https://example.com";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         __block NSString *name = nil;
                                                         __block NSString *host = nil;
                                                         [alertController.textFields enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                             if (idx == 0) {
                                                                 name = obj.text;
                                                             }
                                                             else {
                                                                 host = obj.text;
                                                             }
                                                         }];
                                                         if ([host hasSuffix:@"/"]) {
                                                             wb_showText(viewController.view, message);
                                                         }
                                                         else if ([host isEqualToString:example]) {
                                                             wb_showText(viewController.view, @"域名不可用");
                                                         }
                                                         else {
                                                             !completion?:completion(name, host);
                                                         }
                                                     }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                         }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"自定义名称";
        textField.text = @"自定义名称";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = example;
        textField.text = example;
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

void wb_showText(UIView *view, NSString *message) {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
    hud.bezelView.color = [UIColor colorWithWhite:0.0f alpha:0.8f];
    hud.label.font = [UIFont boldSystemFontOfSize:14.0f];
    hud.detailsLabel.text = nil;
    hud.removeFromSuperViewOnHide = YES;
    hud.margin = 15.0f;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    [hud hideAnimated:YES afterDelay:3.5f];
}

@end
