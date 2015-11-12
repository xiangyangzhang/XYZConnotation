//
//  BaseModel.m
//  Connotation
//
//  Created by xyz on 15/9/23.
//  Copyright (c) 2015年 xyz. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
//kvc 的时候 如果没有找到key 对应的对象属性名 ，会调用下面的方法，如果不实现 程序 会 crash
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}
@end
