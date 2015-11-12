//
//  BaseModel.h
//  Connotation
//
//  Created by xyz on 15/9/23.
//  Copyright (c) 2015年 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
