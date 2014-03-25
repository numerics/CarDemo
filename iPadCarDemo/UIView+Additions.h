//
//  UIView+Additions.h
//  WorkBench
//
//  Created by John Basile on 5/2/13.
//  Copyright (c) 2013 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>


#define deg2rad(degree) degree * M_PI / 180.0f
#define rad2deg(rad) rad * 180.0f / M_PI

@interface UIView (UIPositioning)

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

-(void)move:(CGPoint)amount;

-(void)centerToView:(UIView *)view;

@end


@interface UIView(UILayout)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat verticalCenter;
@property (nonatomic) CGFloat horizontalCenter;

@end


@interface UIView(UITransform)

@property (nonatomic) CGFloat rotation;
@property (nonatomic) CGFloat scaleX;
@property (nonatomic) CGFloat scaleY;

-(void)rotate:(CGFloat)amount;
-(void)scale:(CGFloat) amount;

@end


@interface UIView (Gradients)

-(void)setBackgroundGradientWithColors:(NSArray *) colors inRect:(CGRect) rectFrame atLocations:(NSArray *) locationsArray;

@end