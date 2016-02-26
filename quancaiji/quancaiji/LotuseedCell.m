//
//  LotuseedCell.m
//  quancaiji
//
//  Created by 杨 on 16/2/25.
//  Copyright © 2016年 杨. All rights reserved.
//

#import "LotuseedCell.h"

@implementation LotuseedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *iconView = [[UIImageView alloc]init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        self.iconView.frame = CGRectMake(5, 12, 20, 20);
        self.iconView.backgroundColor = [UIColor yellowColor];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        self.nameLabel.frame = CGRectMake(35, 0, 100, 22);
        self.nameLabel.text = @"name";
        
        UILabel *introLabel = [[UILabel alloc]init];
        introLabel.numberOfLines = 0;
        [self.contentView addSubview:introLabel];
        self.introLabel = introLabel;
        self.introLabel.text = @"intro";
        self.introLabel.frame = CGRectMake(35, 22, 100, 22);
        self.introLabel.text = @"intro";
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"status";
    LotuseedCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[LotuseedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}



@end
