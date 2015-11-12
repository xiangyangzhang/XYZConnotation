//
//  VideoModel.h
//  Connotation
//
//  Created by xyz on 15-5-26.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "BaseModel.h"
//视频model
@interface VideoModel : BaseModel
@property (nonatomic, copy) NSString *wid;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *wbody;
@property (nonatomic, copy) NSString *comments;
@property (nonatomic, copy) NSString *likes;

@property (nonatomic, copy) NSString *vpic_small;
@property (nonatomic, copy) NSString *vpic_middle;
@property (nonatomic, copy) NSString *vplay_url;
@property (nonatomic, copy) NSString *vsource_url;


@end
