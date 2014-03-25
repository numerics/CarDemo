//
//  UIDevice+Additions.m
//  Workbench
//
//  Created by John Basile on 10/8/12
//  Copyright (c) 2011 Numerics. All rights reserved.
//

#import "UIDevice+Additions.h"

CGFloat kiPhone568HeightPadding = 88;
CGFloat kiPhone568HeightRetinaPadding = 176;

@implementation UIDevice (Additions)

+ (UIDeviceType)deviceType
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        return UIDeviceType_iPad;
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    if ( size.height == 480 )
        return UIDeviceType_iPhone480;
    
    if ( size.height == 568 )
        return UIDeviceType_iPhone568;
    
    return UIDeviceType_Invalid;
}

+ (CGFloat)contentWidth
{
    CGFloat Width = ([[UIFactory sharedInstance] iPad]) ? 768.0 : 320;
    return Width;
}

+ (CGFloat)contentHeight
{
    CGFloat Height = ([UIDevice deviceType] == UIDeviceType_iPad ) ? 1024 : ([UIDevice deviceType] == UIDeviceType_iPhone568 ) ? 568 : 480;
    return Height;
}

+ (NSString*)deviceCompatibleFilename:(NSString*)filename
{
    if ([UIDevice deviceType] == UIDeviceType_iPhone568) {
        // Insert the string "568" right before the extension.  For example, "foo.png" becomes "foo568.png" and
        // "bar.jpeg" becomes "bar568.jpeg".
        NSArray* filenameComponents = [filename componentsSeparatedByString:@"."];
        NSString* filenameExtension = [filenameComponents objectAtIndex:[filenameComponents count] - 1];
        NSString* oldPostfix = [NSString stringWithFormat:@".%@", filenameExtension];
        NSString* newPostfix = [NSString stringWithFormat:@"568.%@", filenameExtension];
        filename = [filename stringByReplacingOccurrencesOfString:oldPostfix withString:newPostfix];
    }
    
    return filename;
}

@end
