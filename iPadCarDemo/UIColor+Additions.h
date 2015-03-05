//
//  UIColor+Additions.h
//  WorkBench
//
//  Created by John Basile on 5/2/13.
//  Copyright (c) 2013 Numerics. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum
{
    kFillColor = 0,
    kBorderColor,
    kStartColor,
    kEndColor,
} ColorAppearance;
 

@interface UIColor (EliteKit)

// Hex conversion methods and component methods provided by Erica Sadun - http://arstechnica.com/apple/2009/02/iphone-development-accessing-uicolor-components/
- (CGColorSpaceModel) colorSpaceModel;
- (NSString *) colorSpaceString;
- (BOOL) canProvideRGBComponents;
- (CGFloat) red;
- (CGFloat) green;
- (CGFloat) blue;
- (CGFloat) alpha;
- (NSString *) stringFromColor;
- (NSString *) hexStringFromColor;
+ (UIColor *) colorWithString: (NSString *) stringToConvert;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert withAlpha:(CGFloat)alpha;

@end
