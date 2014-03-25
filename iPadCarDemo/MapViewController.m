
/*
     File: MapViewController.m
 Abstract: The main view controller for our app. Displays a map.
 */

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UIUtil.h"

typedef void (^PerformAfterAcquiringLocationSuccess)(CLLocationCoordinate2D);
typedef void (^PerformAfterAcquiringLocationError)(NSError *);

@implementation MapViewController
{
    PerformAfterAcquiringLocationSuccess _afterLocationSuccess;
    PerformAfterAcquiringLocationError _afterLocationError;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
	{
        self.dealerInfo = [[CDDealerInfo alloc] init];
		
		self.minLatitude = 90;
		self.maxLatitude = -90;
		self.minLongitude = 180;
		self.maxLongitude = -180;
    }
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver: self                                                 // set notification to update the month label
                                             selector: @selector(dataLoaded:)
                                                 name: @"PingMe"
                                               object: nil];
    
 	self.title = NSLocalizedString(@"Los Angeles Map", @"Los Angeles Map");
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cars", @"Cars") style:UIBarButtonItemStylePlain target:self action:@selector(revealCars:)];

//	if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
//	{
//		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
//		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
//		
//		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reveal", @"Reveal") style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
//	}
    
	CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(34.048631, -118.440053);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.906448, 0.878906);
    self.mapView.region = MKCoordinateRegionMake(centerCoordinate, span);
	
	self.myLocation = [[CLLocation alloc] initWithLatitude:34.048631 longitude:-118.440053];	// create a location

	//self.dealerData = [[CDDealerData alloc] initWithCarType:@"audi" at:myLocation];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if( !self.cardealer )
		self.cardealer = @"audi";
	   self.dealerData = [[CDDealerData alloc] initWithCarType:self.cardealer at:self.myLocation];
	
}

- (void)addSonarOverlay:(CLLocationCoordinate2D )midCoordinate rect:(MKMapRect)overlayBoundingMapRect
{
    self.sonarOverlay = [[SonarOverlay alloc] initWithSonarRef:midCoordinate rect:overlayBoundingMapRect];
	
	[self.mapView setVisibleMapRect:[self.sonarOverlay boundingMapRect]];
	
    [self.mapView addOverlay:self.sonarOverlay];
}

- (void)dataLoaded:(NSNotification *)notification
{
	[self.mapView addAnnotations:self.dealerData.dealers];
	self.mapView.region = [self getRegionThatFitsLocations:self.dealerData.dealers];
	
//	MKMapRect mRect = [self overlayBoundingMapRect:self.mapView.region];
	
//	[self addSonarOverlay:self.mapView.region.center rect:mRect];			/// TODO
}

- (void)revealCars:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}



- (MKMapRect)overlayBoundingMapRect:(MKCoordinateRegion)coordinateRegion
{
	CLLocationCoordinate2D topLeftCoordinate =
	CLLocationCoordinate2DMake(coordinateRegion.center.latitude
							   + (coordinateRegion.span.latitudeDelta/2.0),
							   coordinateRegion.center.longitude
							   - (coordinateRegion.span.longitudeDelta/2.0));
	
	MKMapPoint topLeftMapPoint = MKMapPointForCoordinate(topLeftCoordinate);
	
	CLLocationCoordinate2D bottomRightCoordinate =
	CLLocationCoordinate2DMake(coordinateRegion.center.latitude
							   - (coordinateRegion.span.latitudeDelta/2.0),
							   coordinateRegion.center.longitude
							   + (coordinateRegion.span.longitudeDelta/2.0));
	
	MKMapPoint bottomRightMapPoint = MKMapPointForCoordinate(bottomRightCoordinate);
	
	MKMapRect mapRect = MKMapRectMake(topLeftMapPoint.x,
									  topLeftMapPoint.y,
									  fabs(bottomRightMapPoint.x-topLeftMapPoint.x),
									  fabs(bottomRightMapPoint.y-topLeftMapPoint.y));
	
    return mapRect;
}

// create a region that fill fit all the locations in it
- (MKCoordinateRegion) getRegionThatFitsLocations:(NSArray *)locations
{
    for (CDDealerInfo *dealer in locations)
	{
        CLLocationCoordinate2D location = dealer.coordinate;
		if (location.latitude < self.minLatitude)
		{
            self.minLatitude = location.latitude;
        }
        if (location.latitude > self.maxLatitude)
		{
            self.maxLatitude = location.latitude;
        }
        if (location.longitude < self.minLongitude)
		{
            self.minLongitude = location.longitude;
        }
        if (location.longitude > self.maxLongitude)
		{
            self.maxLongitude = location.longitude;
        }
    }
	
    MKCoordinateSpan span;
    CLLocationCoordinate2D center;
    if ([locations count] > 1)
	{
        // for more than one location, the span is the diff between
        // min and max latitude and longitude
		CGFloat spacing = 0.01;
        span =  MKCoordinateSpanMake((self.maxLatitude - self.minLatitude) + 2*spacing, (self.maxLongitude - self.minLongitude) + spacing);
        // and the center is the min + the span (width) / 2
        center.latitude = self.minLatitude + span.latitudeDelta / 2;
		center.latitude = center.latitude - spacing;
        center.longitude = self.minLongitude + span.longitudeDelta / 2;
    }
	else
	{
        // for a single location make a fixed size span (pretty close in zoom)
        span =  MKCoordinateSpanMake(0.01, 0.01);
        // and the center equal to the coords of the single point
        // which will be the coords of the min (or max) coords
        center.latitude = self.minLatitude;
        center.longitude = self.minLongitude;
    }

    return MKCoordinateRegionMake(center, span);
}

- (void)performAfterAcquiringLocation:(PerformAfterAcquiringLocationSuccess)success error:(PerformAfterAcquiringLocationError)error
{
    if (self.mapView.userLocation != nil)
	{
        if (success)
            success(self.mapView.userLocation.coordinate);
        return;
    }
    
    _afterLocationSuccess = [success copy];
    _afterLocationError = [error copy];
}

#pragma mark -
#pragma mark DirectionsViewControllerDelegate
/*
- (void)directionsViewControllerDidCancel:(DirectionsViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

*/
#pragma mark -
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[CDDealerInfo class]])
        return nil;
    
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Dealer"];
        if (!annotationView)
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Dealer"];
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"station.png"];
        return annotationView;
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:SonarOverlay.class])
	{
        self.sonarView = [[SonarView alloc] initWithOverlay:overlay];
        return self.sonarView;
	}
	else
		return nil;
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // If we are waiting on a user location, call the block
    PerformAfterAcquiringLocationSuccess callback = _afterLocationSuccess;
    _afterLocationError = nil;
    _afterLocationSuccess = nil;
    
    if (callback)
        callback(userLocation.coordinate);
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    // If we are waiting on a user location, inform the block of the error
    PerformAfterAcquiringLocationError callback = _afterLocationError;
    _afterLocationError = nil;
    _afterLocationSuccess = nil;
    
    if (callback)
        callback(error);
}


@end
