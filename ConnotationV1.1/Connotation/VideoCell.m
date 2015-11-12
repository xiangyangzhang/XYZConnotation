//
//  VideoCell.m
//  Connotation
//
//  Created by xyz on 15-5-26.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "VideoCell.h"
#import "UIImageView+WebCache.h"

@implementation VideoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showDataWithModel:(VideoModel *)model {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.vpic_small] placeholderImage:[UIImage imageNamed: @"card_bg"]];
    self.wbodyLabel.text = model.wbody;
    self.dateLabel.text = [LZXHelper dateStringFromNumberTimer:model.update_time];
    self.likeLabel.text = [NSString stringWithFormat:@"赞:%ld",model.likes.integerValue];
    
}

@end
