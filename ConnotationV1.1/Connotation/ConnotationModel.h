//
//  ConnotationModel.h
//  Connotation
//
//  Created by xyz on 15/9/23.
//  Copyright (c) 2015年 xyz. All rights reserved.
//

#import "BaseModel.h"
//段子 趣图 美女的model
//存放数据
@interface ConnotationModel : BaseModel

@property (nonatomic, copy) NSString *comments;

@property (nonatomic, copy) NSString *wpic_small;

@property (nonatomic, copy) NSString *wpic_m_width;

@property (nonatomic, copy) NSString *likes;

@property (nonatomic, copy) NSString *is_gif;

@property (nonatomic, copy) NSString *wpic_middle;

@property (nonatomic, copy) NSString *wpic_s_height;

@property (nonatomic, copy) NSString *wbody;

@property (nonatomic, copy) NSString *wid;

@property (nonatomic, copy) NSString *wpic_s_width;

@property (nonatomic, copy) NSString *wpic_m_height;

@property (nonatomic, copy) NSString *wpic_large;

@property (nonatomic, copy) NSString *update_time;

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
 }
 */

