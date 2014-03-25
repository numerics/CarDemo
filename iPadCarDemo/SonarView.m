//
//  SonarView.m
//  iPadCarDemo
//
//  Created by John Basile on 2/19/14.
//  Copyright (c) 2014 Numerics. All rights reserved.
//

#import "SonarView.h"


@implementation SonarView

@synthesize dMarker,range;

#define MaxDrawHgt	380.0


- (id)initWithOverlay:(id <MKOverlay>)overlay
{
    if (self = [super initWithOverlay:overlay])
    {
    }
    return self;
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)ctx
{
    
    MKMapRect theMapRect = self.overlay.boundingMapRect;
    CGRect rect = [self rectForMapRect:theMapRect];
    
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextTranslateCTM(ctx, 0.0, -rect.size.height);
    CGContextClearRect(ctx, rect);
	CGContextSetRGBStrokeColor(ctx, 255, 255, 255, 0.7);
	
	CGFloat y2,y1;
	CGFloat d2[11];//,rValues[10];
	CGFloat ang,h;
	
	ang = 0.0;
	
	
	d2[0] = BaseDrawPos;
	y2 = BaseDrawPos;
	y1 = y2 - MaxDrawHgt;
	h = y2 - y1;
	
	// Sonar Type
	CGContextSetRGBFillColor(ctx, 1.0, 0.5, 0.0, 0.5);
	CGContextFillEllipseInRect(ctx, CGRectMake(RadarCnterX-RadarRadius, RadarCnterY-RadarRadius, RadarDiamtr, RadarDiamtr));
	
	CGContextAddArc (ctx, RadarCnterX, RadarCnterY, 0.20*RadarRadius,	0, 2*M_PI, 0); CGContextStrokePath(ctx);
	CGContextAddArc (ctx, RadarCnterX, RadarCnterY, 0.40*RadarRadius,	0, 2*M_PI, 0); CGContextStrokePath(ctx);
	CGContextAddArc (ctx, RadarCnterX, RadarCnterY, 0.60*RadarRadius,	0, 2*M_PI, 0); CGContextStrokePath(ctx);
	CGContextAddArc (ctx, RadarCnterX, RadarCnterY, 0.80*RadarRadius,	0, 2*M_PI, 0); CGContextStrokePath(ctx);
	CGContextAddArc (ctx, RadarCnterX, RadarCnterY, 1.00*RadarRadius,	0, 2*M_PI, 0); CGContextStrokePath(ctx);
	
	CGRect foundFrame = CGRectMake(5,(BaseDrawPos)-MaxDrawHgt-25,102,16);
	CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
	CGContextFillRect(ctx, foundFrame);
	CGContextStrokePath(ctx);
	
	//	CGFloat rangeM = self.range*1609.344;
	
	d2[1] =  RadarCnterY - 0.20*RadarRadius;
	d2[2] =  RadarCnterY - 0.40*RadarRadius;
	d2[3] =  RadarCnterY - 0.60*RadarRadius;
	d2[4] =  RadarCnterY - 0.80*RadarRadius;
	d2[5] =  RadarCnterY - 1.00*RadarRadius;
	CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
	
//	CGFloat x, y, z, dr = self.range/5.0;
	
//	for (int i = 1; i <=5; i++)
//	{
//		y = d2[i]+4;
//		x = RadarCnterX - 16.0;
//		z = dr * i;
//		CGRect theFrame = CGRectMake(x,y,25,16);
//		dMarker = [NSString stringWithFormat:@"%1.1f", z];
//		[dMarker drawInRect:theFrame withFont:[UIFont fontWithName:@"Verdana" size:9] lineBreakMode:UILineBreakModeClip];
//	}
}




@end
