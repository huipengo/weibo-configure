//
//  WBServiceConfigure.h
//  Weiboad
//
//  Created by penghui8 on 2018/5/3.
//  Copyright © 2018年 weibo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WBServiceItem;

/** 当前网络环境 */
FOUNDATION_EXPORT NSString *const wbCurrentServiceEnviroment;

@interface WBServiceConfigure : NSObject

@property (nonatomic, strong) WBServiceItem *currentItem;

@property (nonatomic, strong, readonly) NSMutableArray<WBServiceItem *> *allServiceEnviroment;

@property (nonatomic, strong) NSArray<__kindof WBServiceItem *> *serviceItems;

+ (instancetype)getService;

- (BOOL)hasServiceEnviroment:(WBServiceItem *)item;

/// 添加一个自定义服务器配置
- (void)addCustomService:(WBServiceItem *)item;

/// 删除一个自定义服务器配置
- (void)deleteCustomService:(WBServiceItem *)item;

@end
