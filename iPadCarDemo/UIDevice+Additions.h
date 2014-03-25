//
//  UIDevice+Additions.h
//  Workbench
//
//  Created by John Basile on 10/8/12
//  Copyright (c) 2011 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum UIDeviceType
{
    UIDeviceType_Invalid,
    UIDeviceType_iPhone480,
    UIDeviceType_iPhone568,
    UIDeviceType_iPad
} UIDeviceType;

@interface UIDevice (Additions)

+ (UIDeviceType)deviceType;
+ (CGFloat)contentWidth;
+ (CGFloat)contentHeight;
+ (NSString*)deviceCompatibleFilename:(NSString*)filename;

@end

extern CGFloat kiPhone568HeightPadding;
extern CGFloat kiPhone568HeightRetinaPadding;