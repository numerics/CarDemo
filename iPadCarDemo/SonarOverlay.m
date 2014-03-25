//
//  SonarOverlay.m
//  iPadCarDemo
//
//  Created by John Basile on 2/20/14.
//  Copyright (c) 2014 Numerics. All rights reserved.
//

#import "SonarOverlay.h"

@implementation SonarOverlay
@synthesize coordinate;
@synthesize boundingMapRect;


- (instancetype)initWithSonarRef:(CLLocationCoordinate2D )midCoordinate rect:(MKMapRect)overlayBoundingMapRect
{
    self = [super init];
    if (self)
	{
        boundingMapRect = overlayBoundingMapRect;
        coordinate = midCoordinate;
		initialBounds = overlayBoundingMapRect;
    }
    
    return self;
}

- (MKMapRect)boundingMapRect
{
    // Compute the boundingMapRect
    
//    MKMapPoint upperLeft = MKMapPointForCoordinate(coordinate);
    
//    CLLocationCoordinate2D lowerRightCoord =
//	CLLocationCoordinate2DMake(coordinate.latitude - (gridSize * gridHeight),
//							   origin.longitude + (gridSize * gridWidth));
//	
//    MKMapPoint lowerRight = MKMapPointForCoordinate(lowerRightCoord);
//    
//    double width = lowerRight.x - upperLeft.x;
//    double height = lowerRight.y - upperLeft.y;
	
    MKMapRect bounds = initialBounds; // MKMapRectMake(upperLeft.x, upperLeft.y, width, height);
    return bounds;
}
@end
