//
//  Define.h
//  Connotation
//
//  Created by xyz on 15/9/23.
//  Copyright (c) 2015年 xyz. All rights reserved.
//

#ifndef Connotation_Define_h
#define Connotation_Define_h
//存放一些 常用的工具类头文件
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "LZXHelper.h"
#import "NetInterface.h"
#import "JHRefresh.h"

//或者 存放一些 常用的宏定义
//获取屏幕大小
#define kScreenSize [UIScreen mainScreen].bounds.size


// 项目中常用
/*
 如果定义过 宏 DEBUG那么 DDLog 就表示 NSLog 否则 表示空代码
 
 DDLog(...) ... 表示变参宏    __VA_ARGS__表示接收变参宏里面的内容
 
 */
/*
 DEBUG 不用我们自己定义 这个宏在 程序的debug模式下会定义  在release模式下不会定义
 */

#ifdef DEBUG
#define DDLog(...) NSLog(__VA_ARGS__)
#else
#define DDLog(...)
#endif

#endif





