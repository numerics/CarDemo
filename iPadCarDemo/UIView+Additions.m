//
//  UIView+Additions.m
//  WorkBench
//
//  Created by John Basile on 5/2/13.
//  Copyright (c) 2013 Numerics. All rights reserved.
//

#import "UIView+Additions.h"


//helper to set absolute values while retaining transforms current state
CGAffineTransform makeTransform(CGFloat xScale, CGFloat yScale,
                                CGFloat theta, CGFloat tx, CGFloat ty)
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    transform.a = xScale * cos(theta);
    transform.b = yScale * sin(theta);
    transform.c = xScale * -sin(theta);
    transform.d = yScale * cos(theta);
    transform.tx = tx;
    transform.ty = ty;
    
    return transform;
}


@implementation UIView (UIPositioning)


-(CGFloat)x
{
    return self.center.x - self.width / 2;
}

-(void)setX:(CGFloat)x
{
    CGPoint newCenter = self.center;
    newCenter.x = x + self.width / 2;
    self.center = newCenter;
}

-(CGFloat)y
{
    return self.center.y - self.height / 2;
}

-(void)setY:(CGFloat)y
{
    CGPoint newCenter = self.center;
    newCenter.y = y + self.height / 2;
    self.center = newCenter;
}


-(CGFloat)width
{
    return self.bounds.size.width * self.scaleX;
}

-(void)setWidth:(CGFloat)width
{
    CGFloat oldX = self.x;
    CGRect newBounds = self.bounds;
    newBounds.size.width = width;
    self.bounds = newBounds;
    self.x = oldX;
}

-(CGFloat)height
{
    return self.bounds.size.height * self.scaleY;
}

-(void)setHeight:(CGFloat)newHeight
{
    CGFloat oldY = self.y;
    CGRect newBounds = self.bounds;
    newBounds.size.height = newHeight;
    self.bounds = newBounds;
    self.y = oldY;
}

-(void)move:(CGPoint)amount
{
    self.x = amount.x;
    self.y = amount.y;
}


-(void)centerToView:(UIView *)view
{
    self.center = view.center;
}


@end


@implementation UIView(UILayout)


-(CGFloat)left
{
    return self.x;
}

-(void)setLeft:(CGFloat)left
{
    self.x = left;
}

-(CGFloat)top
{
    return self.y;
}

-(void)setTop:(CGFloat)top
{
    self.y = top;
}

-(CGFloat)right
{
    return self.x + self.width;
}

-(void)setRight:(CGFloat)right
{
    self.x = right - self.width;
}

-(CGFloat)bottom
{
    return self.y + self.height;
}

-(void)setBottom:(CGFloat)bottom
{
    self.y = bottom - self.height;
}

-(CGFloat)verticalCenter
{
    return ((self.height * 0.5) + self.y);
}

-(void)setVerticalCenter:(CGFloat)verticalCenter
{
    self.y = floorf(verticalCenter - (self.height * 0.5));
}

-(CGFloat)horizontalCenter
{
    return ((self.width * 0.5) + self.x);
}

-(void)setHorizontalCenter:(CGFloat)horizontalCenter
{
    self.x = floorf(horizontalCenter - (self.width * 0.5));
}

@end

@implementation UIView (UITransform)


// Rotation //////////////////////////////////////////////

-(CGFloat)rotation
{
    return rad2deg([self radRotation]);
}

-(void)setRotation:(CGFloat)rotation
{
    self.transform = makeTransform(self.scaleX, self.scaleY, deg2rad(rotation), self.tx, self.ty);
}

-(void)rotate:(CGFloat) amount
{
    self.transform = CGAffineTransformRotate(self.transform, deg2rad(amount));
}

-(CGFloat)radRotation
{
    CGAffineTransform t = self.transform;
    return atan2f(t.b, t.a);
}


// Translation //////////////////////////////////////////////

-(CGFloat)tx
{
    return self.transform.tx;
}

-(CGFloat)ty
{
    return self.transform.ty;
}


// Scaling ///////////////////////////////////////////////

-(CGFloat)scaleX
{
    CGAffineTransform t = self.transform;
    return sqrt(t.a * t.a + t.c * t.c);
}

-(void)setScaleX:(CGFloat) scaleX
{
    self.transform = makeTransform(scaleX, self.scaleY, [self radRotation], self.tx, self.ty);
}

-(CGFloat)scaleY
{
    CGAffineTransform t = self.transform;
    return sqrt(t.b * t.b + t.d * t.d);
}

-(void)setScaleY:(CGFloat) scaleY
{
    self.transform = self.transform = makeTransform(self.scaleX, scaleY, [self radRotation], self.tx, self.ty);
}

-(void)scale:(CGFloat)scale
{
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
}


@end



@implementation UIView (Gradients)


-(void)setBackgroundGradientWithColors:(NSArray *) colors inRect:(CGRect) rectFrame atLocations:(NSArray *) locationsArray
{
    NSAssert([colors count] == [locationsArray count], @"*Error* Number of Colors in Gradient should Match the Number of Locations!!");
    
    CGRect currentBounds = rectFrame;
    
    UIGraphicsBeginImageContextWithOptions(currentBounds.size, YES, 0);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    
    int arrayCount = [locationsArray count];
    
    CGFloat locations[10];
    
    for (int i = 0; i < arrayCount; ++i)
    {
        locations[i] = [[locationsArray objectAtIndex:i] floatValue];
    }
    
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    
    glossGradient = CGGradientCreateWithColors(rgbColorspace, (__bridge CFArrayRef)colors, locations);
    
    CGContextDrawLinearGradient(currentContext, glossGradient, CGPointMake(currentBounds.size.width/2, 0), CGPointMake(currentBounds.size.width/2, currentBounds.size.height), 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:newImage]];
    UIGraphicsEndImageContext();
}


@end



