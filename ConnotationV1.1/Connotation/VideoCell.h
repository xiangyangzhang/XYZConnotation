//
//  VideoCell.h
//  Connotation
//
//  Created by xyz on 15-5-26.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@interface VideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *wbodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
- (void)showDataWithModel:(VideoModel *)model;
@end




