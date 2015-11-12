//
//  ConnotationCell.h
//  Connotation
//
//  Created by xyz on 15/9/23.
//  Copyright (c) 2015年 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnotationModel.h"

@interface ConnotationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *wbodyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIButton *likesButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
- (IBAction)likesClick:(id)sender;
- (IBAction)commentsClick:(id)sender;
//保存model
@property (nonatomic,strong) ConnotationModel *model;

//分类
@property (nonatomic,copy) NSString *category;

//填充cell
- (void)showDataWithModel:(ConnotationModel *)model;


@end











