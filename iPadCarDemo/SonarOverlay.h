//
//  SonarOverlay.h
//  iPadCarDemo
//
//  Created by John Basile on 2/20/14.
//  Copyright (c) 2014 Numerics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SonarOverlay : NSObject<MKOverlay>
{
	MKMapRect	initialBounds;
}



// Defined in MKOverLay
// @property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
// @property (nonatomic, readonly) MKMapRect boundingMapRect;


- (instancetype)initWithSonarRef:(CLLocationCoordinate2D )midCoordinate rect:(MKMapRect)overlayBoundingMapRect;

@end
