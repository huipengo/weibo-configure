//
//  WBServiceConfigureCell.m
//  Weiboad
//
//  Created by penghui8 on 2018/5/3.
//  Copyright © 2018年 weibo. All rights reserved.
//

#import "WBServiceConfigureCell.h"

@interface WBServiceConfigureCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *hostLabel;

@property (nonatomic, strong) WBServiceItem *item;

@end

@implementation WBServiceConfigureCell

+ (instancetype)wb_cellNibForTableView:(UITableView * _Nonnull)tableView {
    static NSString *cellIdentifier = @"wb_cellNibIdentifier";
    WBServiceConfigureCell *cell = [self.class wb_cellNibForTableView:tableView identifier:cellIdentifier];
    return cell;
}

+ (instancetype)wb_cellNibForTableView:(UITableView * _Nonnull)tableView identifier:(NSString * _Nonnull)identifier {
    WBServiceConfigureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSString *nibName = NSStringFromClass(self.class);
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(WBServiceItem *)item currentService:(BOOL)currentService {
    self.item = item;
    
    if (currentService) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
        self.nameLabel.textColor = [self.class wb_blueColor];
        self.hostLabel.textColor = [self.class wb_blueColor];
    }
    else {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.nameLabel.textColor = [self.class wb_grayColor];
        self.hostLabel.textColor = [self.class wb_grayColor];
    }
}

- (void)setItem:(WBServiceItem *)item {
    _item = item;
    self.nameLabel.text = item.name;
    self.hostLabel.text = item.host;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self wb_setBackgroundColorDidSelected:selected];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self wb_setBackgroundColorDidSelected:highlighted];
}

- (void)wb_setBackgroundColorDidSelected:(BOOL)isSelected {
    UIColor *gBackGroundColor = isSelected ? self.wb_highlightedColor : [UIColor whiteColor];
    self.backgroundColor = gBackGroundColor;
}

- (UIColor *)wb_highlightedColor {
    return [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
}

+ (UIColor *)wb_blueColor {
    UIColor *color = [UIColor colorWithRed:0.0f/255.0f green:57.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    return color;
}

+ (UIColor *)wb_grayColor {
    UIColor *color = [UIColor colorWithRed:142.0f/255.0f green:144.0f/255.0f blue:145.0f/255.0f alpha:1.0f];
    return color;
}

@end
