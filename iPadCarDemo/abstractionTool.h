//
//  abstractionTool.h
//  ChinUp
//
//  Created by John Basile on 7/17/12.
//  Copyright (c) 2012 Numerics, All rights reserved.
//

#import <Foundation/Foundation.h>

@interface abstractionTool : NSObject

+ (void)createCommonPlistforApp:(NSString *)fileName prefix:(NSString *)prefix;
+ (void)createCommonPlistforController:(NSString *)nibName fileName:(NSString *)fileName prefix:(NSString *)prefix;
@end
