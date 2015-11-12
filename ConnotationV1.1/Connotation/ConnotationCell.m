//
//  ConnotationCell.m
//  Connotation
//
//  Created by xyz on 15/9/23.
//  Copyright (c) 2015年 xyz. All rights reserved.
//

#import "ConnotationCell.h"
#define kPadding 10
@implementation ConnotationCell

//xib初始化加载的时候 会调用 如果我们代码中要初始化在这里进行
- (void)awakeFromNib {
    // Initialization code
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image = [UIImage imageNamed: @"cell_background.png"];
    //设置cell 的背景图
    self.backgroundView = imageView;
    self.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中效果
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)showDataWithModel:(ConnotationModel *)model {
    
    //保存model
    self.model = model;
    
    
    //把一个 @"1442991600"转化为时间日期字符串
    self.dateLabel.text = [LZXHelper dateStringFromNumberTimer:model.update_time];
    self.wbodyLabel.text = model.wbody;
    //根据字符串内容 多少 计算出label 的实际高
    CGFloat h = [LZXHelper textHeightFromTextString:model.wbody width:kScreenSize.width-kPadding*2 fontSize:14];
    //修改 高
    CGRect wbodyLabelFrame = self.wbodyLabel.frame;
    wbodyLabelFrame.size.height = h;
    self.wbodyLabel.frame = wbodyLabelFrame;
    
    
    //不为空表示 有图片
    //修改图片的y 和 高
    CGRect imageFrame = self.contentImageView.frame;
    //CGRectGetMaxY ---》就是 label的y + label的高
    imageFrame.origin.y = CGRectGetMaxY(self.wbodyLabel.frame)+kPadding;
    if (model.wpic_middle.length) {
        //推算出 图片在界面上显示的 高
        //w/h = w（image）/h(image)
        //h = w*h(image)/w(image)
        CGFloat w = kScreenSize.width-2*kPadding;
        imageFrame.size.height = w*model.wpic_m_height.doubleValue/model.wpic_m_width.doubleValue;
        //异步加载图片
        UIImage *image = [UIImage imageNamed: @"card_bg.png"];
        //周围区域外 不拉伸 区域内部拉伸
        //
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.wpic_middle] placeholderImage:image];
        
        
    }else {
        imageFrame.size.height = 0;//没有图片 h 0
    }
    self.contentImageView.frame = imageFrame;
   
    
    CGRect likeButtonFrame = self.likesButton.frame;
    CGRect commentsButtonFrame = self.commentButton.frame;
    
    likeButtonFrame.origin.y = CGRectGetMaxY(self.contentImageView.frame)+kPadding;
    commentsButtonFrame.origin.y = CGRectGetMaxY(self.contentImageView.frame)+kPadding;
    self.likesButton.frame = likeButtonFrame;
    self.commentButton.frame = commentsButtonFrame;
    
    [self.likesButton setTitle:[NSString stringWithFormat:@"赞:%ld",model.likes.integerValue] forState:UIControlStateNormal];
    //判断是否被点过
    NSString *str = [self.category stringByAppendingString:self.model.wid];
    BOOL isLike = [[[NSUserDefaults standardUserDefaults] objectForKey:str]boolValue];
    [self.likesButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
    if (isLike) {
        self.likesButton.selected = YES;
    }else {
        self.likesButton.selected = NO;
    }

    
    
}

- (IBAction)likesClick:(UIButton *)sender {
    //判断是否被点过
    NSString *str = [self.category stringByAppendingString:self.model.wid];
    
    BOOL isLike = [[[NSUserDefaults standardUserDefaults] objectForKey:str]boolValue];
    if (isLike) {
        //被点过直接返回
        return;
    }
    
    //一旦点赞 要发 post 请求 提交给服务器
    /*
     // 点赞接口，post请求
     // fid为对应的wid，category同上
     #define kZanUrl @"http://223.6.252.214/weibofun/add_count.php?apiver=10500&vip=1&platform=iphone&appver=1.6&udid=6762BA9C-789C-417A-8DEA-B8D731EFDC0B"
     //请求体拼接参数是下面的形式参数
     // type=like&category=weibo_girls&fid=30310
     */
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //post
    //提交的参数
    NSDictionary *dict = @{
                           @"type":@"like",
                           @"category":self.category,
                           @"fid":self.model.wid};
    
    [manager POST:kZanUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //服务器响应的数据
        NSDictionary *newDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dict:%@",newDict);
        if ([newDict[@"retcode"] integerValue] == 0) {
            NSLog(@"点赞成功");
            //本地保存 记录这个 数据 被点过赞
            //分类 和id 拼接 成一个唯一的字符串
            NSString *key = [self.category stringByAppendingString:self.model.wid];
            //本地存储
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //选中
            sender.selected = YES;
            //选中状态 标题 点赞数据+1
            [sender setTitle:[NSString stringWithFormat:@"赞:%ld",self.model.likes.integerValue+1] forState:UIControlStateSelected];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"post失败");
    }];
    

}

- (IBAction)commentsClick:(id)sender {
}
@end
/*
 {
 "wid": "73187",
 "update_time": "1442991600",
 "wbody": "大家帮我看看这钱是不是假的？",
 "comments": "6",
 "likes": "49.92",
 "wpic_s_width": "67",
 "wpic_s_height": "119",
 "wpic_m_width": "440",
 "wpic_m_height": "782",
 "is_gif": "0",
 "wpic_small": "http://ww4.sinaimg.cn/thumbnail/a7cb85c1jw1ewbk30ro2sj20go0tnmy5.jpg",
 "wpic_middle": "http://ww4.sinaimg.cn/bmiddle/a7cb85c1jw1ewbk30ro2sj20go0tnmy5.jpg",
 "wpic_large": "http://ww4.sinaimg.cn/large/a7cb85c1jw1ewbk30ro2sj20go0tnmy5.jpg"
 },
 */

