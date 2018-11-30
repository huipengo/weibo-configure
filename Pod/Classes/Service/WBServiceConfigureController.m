//
//  WBServiceConfigureController.m
//  Weiboad
//
//  Created by penghui8 on 2018/5/3.
//  Copyright © 2018年 weibo. All rights reserved.
//

#import "WBServiceConfigureController.h"
#import "WBServiceConfigureCell.h"
#import "WBServiceConfigure.h"
#import "WBServiceConfigureHelper.h"

static CGFloat const kHeader_Height = 10.0f;
static CGFloat const kCell_Height   = 50.0f;

@interface WBServiceConfigureController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<WBServiceItem *> *dataSource;

@property (nonatomic, strong) NSIndexPath *previousIndex;

@end

void wb_presentServiceViewController(UIViewController *sourceViewController) {
    WBServiceConfigureController *viewController = [[WBServiceConfigureController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [sourceViewController presentViewController:nav animated:YES completion:^{ }];
}

CG_EXTERN void wb_pushServiceViewController(UIViewController *sourceViewController) {
    WBServiceConfigureController *viewController = [[WBServiceConfigureController alloc] init];
    viewController.wb_push = YES;
    [sourceViewController.navigationController pushViewController:viewController animated:YES];
}

@implementation WBServiceConfigureController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewConfigure];
}

- (void)viewConfigure {
    self.title = @"环境配置";
    self.view.backgroundColor      = self.wb_grayColor;
    self.tableView.backgroundColor = self.wb_grayColor;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorColor  = self.wb_lineColor;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = kCell_Height;
    
    [self wb_closeBarButtonItem];
}

- (void)wb_closeBarButtonItem {
    NSString *imagePath = [[NSBundle bundleForClass:self.class] pathForResource:@"Service.bundle/wb_close_black@2x"
                                                                         ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    UIBarButtonItem *_closeBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(closeAction:)];
    self.navigationItem.leftBarButtonItem = _closeBarButtonItem;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)closeAction:(id)sender {
    if (self.cw_present) {
        !self.configureCompletion ?: self.configureCompletion(self.cw_present);
    }
    else if (self.wb_push) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{ }];
    }
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WBServiceConfigureCell *cell = [WBServiceConfigureCell wb_cellNibForTableView:tableView];
    WBServiceItem *item = [self.dataSource objectAtIndex:indexPath.row];
    BOOL currentService = NO;
    if ([[WBServiceConfigure getService].currentItem.host isEqualToString:item.host] &&
        [[WBServiceConfigure getService].currentItem.name isEqualToString:item.name]) {
        currentService = YES;
    }
    [cell setItem:item currentService:currentService];
    if (currentService) {
        self.previousIndex = indexPath;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeader_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, kHeader_Height)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, CGFLOAT_MIN)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WBServiceItem *item = [self.dataSource objectAtIndex:indexPath.row];
    if ([item.name isEqualToString:@"自定义"]) {
        [WBServiceConfigureHelper wb_showServiceConfigureViewController:self completion:^(NSString *name, NSString *host) {
            WBServiceItem *customItem = [[WBServiceItem alloc] init];
            customItem.name = name;
            customItem.host = host;
            if ([[WBServiceConfigure getService] hasServiceEnviroment:customItem]) {
                wb_showText(self.view, @"不要重复添加相同的域名");
            }
            else {
                [WBServiceConfigure getService].currentItem = customItem;
                [[WBServiceConfigure getService] addCustomService:customItem];
                [self.dataSource insertObject:customItem atIndex:indexPath.row];
                [self.tableView reloadData];
            }
        }];
    }
    else {
        [WBServiceConfigure getService].currentItem = item;
        [self.tableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == self.dataSource.count - 1) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.previousIndex == indexPath) {
            [WBServiceConfigure getService].currentItem = [[WBServiceConfigure getService].allServiceEnviroment firstObject];
        }
        [[WBServiceConfigure getService] deleteCustomService:[self.dataSource objectAtIndex:indexPath.row]];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        [tableView setEditing:NO];
    }
}

- (NSMutableArray<WBServiceItem *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:[WBServiceConfigure getService].allServiceEnviroment];
        
        WBServiceItem *item = [[WBServiceItem alloc] init];
        item.name = @"自定义";
        item.host = @"https://example.com";
        [_dataSource addObject:item];
    }
    return _dataSource;
}

- (UIColor *)wb_grayColor {
    UIColor *wb_grayColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
    return wb_grayColor;
}

- (UIColor *)wb_lineColor {
    UIColor *wb_lineColor = [UIColor colorWithRed:220.0f/255.0f green:226.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
    return wb_lineColor;
}

@end
