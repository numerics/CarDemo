
/*
     File: MapViewController.h
 Abstract:	Secondary view controller after a user selects a car model, Honda...
			Displays a map od dealer location
 */

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CDDealerInfo.h"
#import "CDDealerData.h"
#import "SonarView.h"
#import "SonarOverlay.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic) CLLocationDegrees minLatitude;
@property (nonatomic) CLLocationDegrees maxLatitude;
@property (nonatomic) CLLocationDegrees minLongitude;
@property (nonatomic) CLLocationDegrees maxLongitude;


@property (nonatomic, strong) CDDealerInfo	*dealerInfo;
@property (nonatomic, strong) CDDealerData	*dealerData;

@property (nonatomic, strong) NSString		*cardealer;
@property (nonatomic, strong) CLLocation	*myLocation;

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@property (nonatomic, strong) SonarView			*sonarView;
@property (nonatomic, strong) SonarOverlay		*sonarOverlay;


- (MKCoordinateRegion) getRegionThatFitsLocations:(NSArray *)locations;

@end
