//
//  SonarView.h
//  iPadCarDemo
//
//  Created by John Basile on 2/19/14.
//  Copyright (c) 2014 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface SonarView : MKOverlayRenderer
{
	NSString					*dMarker;
	CGFloat						range;	
	
}
@property (nonatomic, strong) NSString *dMarker;
@property CGFloat range;


@end
