//
//  WBServiceConfigure.m
//  Weiboad
//
//  Created by penghui8 on 2018/5/3.
//  Copyright © 2018年 weibo. All rights reserved.
//

#import "WBServiceConfigure.h"
#import <YYModel/YYModel.h>
#import "WBServiceItem.h"

static NSString *const wbName = @"name";
static NSString *const wbHost = @"host";

/** 当前网络环境 */
NSString * const wbCurrentServiceEnviroment    = @"wbCurrentServiceEnviroment";
/** 所有网络环境集合 */
static NSString * const wbAllServiceEnviroment = @"wbAllServiceEnviroment";

static inline BOOL wb_isRunningTests(void) {
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *injectBundle = [environment objectForKey:@"XCInjectBundleInto"];
    return (injectBundle != nil);
}

@interface WBServiceConfigure ()

@property (nonatomic, strong, readwrite) NSMutableArray<WBServiceItem *> *allServiceEnviroment;

@end

@implementation WBServiceConfigure

+ (instancetype)getService {
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

/// 添加一个自定义服务器配置
- (void)addCustomService:(WBServiceItem *)item {
    if (![self hasServiceEnviroment:item]) {
        [self.allServiceEnviroment addObject:item];
        [self saveAllServiceEnviroment];
    }
}

- (void)deleteCustomService:(WBServiceItem *)item {
    if ([self hasServiceEnviroment:item]) {
        [self.allServiceEnviroment removeObject:item];
        [self saveAllServiceEnviroment];
    }
}

- (BOOL)hasServiceEnviroment:(WBServiceItem *)item {
    __block BOOL hasItem = NO;
    [self.allServiceEnviroment enumerateObjectsUsingBlock:^(WBServiceItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.host isEqualToString:item.host]) {
            hasItem = YES;
            *stop = YES;
        }
    }];
    return hasItem;
}

- (void)saveAllServiceEnviroment {
    NSArray *localArray = [self.allServiceEnviroment yy_modelToJSONObject];
    [[NSUserDefaults standardUserDefaults] setObject:localArray forKey:wbAllServiceEnviroment];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -- 修改服务器环境
- (WBServiceItem *)currentItem {
    NSDictionary *item = [[NSUserDefaults standardUserDefaults] objectForKey:wbCurrentServiceEnviroment];
    WBServiceItem *currentItem = [[WBServiceItem alloc] init];
    if (item) {
        currentItem.name = [item objectForKey:wbName];
        currentItem.host = [item objectForKey:wbHost];
    }
    else {
        if (wb_isRunningTests()) {
            currentItem = [WBServiceConfigure.getService.serviceItems lastObject];
        }
        else {
            #ifdef DEBUG
            currentItem = [WBServiceConfigure.getService.serviceItems objectAtIndex:1];
            #else
            currentItem = [WBServiceConfigure.getService.serviceItems objectAtIndex:0];
            #endif
        }
    }
    return currentItem;
}

- (void)setCurrentItem:(WBServiceItem *)currentItem {
    NSDictionary *item = @{wbName : currentItem.name?:@"--", wbHost : currentItem.host?:@""};
    [[NSUserDefaults standardUserDefaults] setObject:item forKey:wbCurrentServiceEnviroment];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)allServiceEnviroment {
    if (!_allServiceEnviroment) {
        NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:wbAllServiceEnviroment];
        if (array) {
            _allServiceEnviroment = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:WBServiceItem.class json:array]];
        }
        else {
            _allServiceEnviroment = [NSMutableArray arrayWithArray:WBServiceConfigure.getService.serviceItems];
        }
    }
    return _allServiceEnviroment;
}

@end
