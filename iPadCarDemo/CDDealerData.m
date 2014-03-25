//
//  CDDealerData.m
//  iPadCarDemo
//
//  Created by John Basile on 2/18/14.
//  Copyright (c) 2014 Numerics. All rights reserved.
//

#import "CDDealerData.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "UIUtil.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kDealerURL   [NSURL URLWithString: @"http://api.edmunds.com/v1/api/dealer?zipcode=90404&makeName=audi&model=a4&radius=20&fmt=json&api_key=hjeu73zzq3438zmuuqq6sy4r"]
NSString *frontPart =   @"http://api.edmunds.com/v1/api/dealer?zipcode=90404&makeName=";
NSString *backPart =   @"&model=a4&radius=20&fmt=json&api_key=hjeu73zzq3438zmuuqq6sy4r";



@interface NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress;
-(NSData*)toJSON;
@end

@implementation NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress
{
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: urlAddress] ];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:&error];
    if (error != nil) return nil;
    return result;
}

-(NSData*)toJSON
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:NSUTF8StringEncoding error:&error];
    if (error != nil) return nil;
    return result;
}
@end

@interface CDDealerData()

- (void)loadJsonDataToModel:(NSArray*)items;

@end

@implementation CDDealerData

- (id)initWithCarType:(NSString *)carType at:(CLLocation *)centerLocation
{
	self = [super init];
    if (self)
	{
		self.type = carType;
		NSString *url = [NSString stringWithFormat:@"%@%@%@",frontPart,[carType lowercaseString],backPart];
		
		self.centerLocation = centerLocation;

		NSURLSession *session = [NSURLSession sharedSession];
		NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
		{
			// handle response
			NSLog(@"response == %@",response);
			[self processResponseUsingData:data];
		}];
		
		[task setTaskDescription:@"Dealer Download"];
		// DON"T FORGET!!!
		[task resume];
		
		
//		NSURL *nurl = [NSURL URLWithString:url];
//		dispatch_async(kBgQueue, ^{
//			NSData* data = [NSData dataWithContentsOfURL: nurl /*audi dealers*/];
//			[self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
//		});
	}
	
	return self;
}

- (void)loadJsonDataToModel:(NSArray*)items
{
	NSUInteger cnt = [items count];
	if( cnt == 0) return;
	self.dealers = [NSMutableArray array];
	CLLocationCoordinate2D centerCoordinate = self.centerLocation.coordinate;
	MKMapPoint centerPoint = MKMapPointForCoordinate(centerCoordinate);
	
	for (int j = 0; j < cnt; j++)
	{
		NSDictionary* item = [items objectAtIndex:j];
		CDDealerInfo *dInfo = [[CDDealerInfo alloc] initWithCarType:self.type];
		[[UIFactory sharedInstance] addValuesToObjfromJsonDict:dInfo jsonDict:item excludeTypes:@"MKObjectView,CLLocationCoordinate2D"];
		[dInfo updatesMapInfo];
		
		
		CLLocationCoordinate2D dealerCoordinate = CLLocationCoordinate2DMake([dInfo.latitude doubleValue], [dInfo.longitude doubleValue]);
		
		MKMapPoint dealerPoint = MKMapPointForCoordinate(dealerCoordinate);
		
		CLLocationDistance distanceToStop = MKMetersBetweenMapPoints(centerPoint, dealerPoint);
		CGFloat dis = distanceToStop / 1609.344;
		dInfo.subtitle = [NSString stringWithFormat:@" Distance to %@, %.1f miles",dInfo.subtitle, dis];
		[self.dealers addObject:dInfo];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PingMe" object:self];
	
}

- (void)processResponseUsingData:(NSData*)data
{
    NSError *parseJsonError = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseJsonError];
    
    if (!parseJsonError)
	{
		NSArray* items = [jsonDict objectForKey:[CDDealerInfo classKeyName]];
		NSLog(@"Dealer Info: %@", items);
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadJsonDataToModel:items];
        });
    }
}



- (void)fetchedData:(NSData *)responseData
{
    //parse out the json data
    NSError* error;
	if( !responseData )		// Faile to Find Data
	{
		[UIUtil alertMessage:@"Failed to find Dealer Data... Can always try audi"];
		return;
	}
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:NSUTF8StringEncoding error:&error];
	if( error)
	{
		NSLog(@"error is %@", [error localizedDescription]);
		return;
	}

    NSArray* items = [json objectForKey:[CDDealerInfo classKeyName]];
    
    NSLog(@"Dealer Info: %@", items);
    
	NSUInteger cnt = [items count];
	if( cnt == 0) return;
	self.dealers = [NSMutableArray array];
	CLLocationCoordinate2D centerCoordinate = self.centerLocation.coordinate;
	MKMapPoint centerPoint = MKMapPointForCoordinate(centerCoordinate);
	
	for (int j = 0; j < cnt; j++)
	{
		NSDictionary* item = [items objectAtIndex:j];
		CDDealerInfo *dInfo = [[CDDealerInfo alloc] initWithCarType:self.type];
		[[UIFactory sharedInstance] addValuesToObjfromJsonDict:dInfo jsonDict:item excludeTypes:@"MKObjectView,CLLocationCoordinate2D"];
		[dInfo updatesMapInfo];
		
		
		CLLocationCoordinate2D dealerCoordinate = CLLocationCoordinate2DMake([dInfo.latitude doubleValue], [dInfo.longitude doubleValue]);
		
		MKMapPoint dealerPoint = MKMapPointForCoordinate(dealerCoordinate);

		CLLocationDistance distanceToStop = MKMetersBetweenMapPoints(centerPoint, dealerPoint);
		CGFloat dis = distanceToStop / 1609.344;
		dInfo.subtitle = [NSString stringWithFormat:@" Distance to %@, %.1f miles",dInfo.subtitle, dis];
		
//		if (distanceToStop < (1609.344 * evDelegate.miles))
//		{
//			garInfo* gi = [[garInfo alloc] init];
//			gi.heading = heading;
//			gi.route_id = route_id;
//			gi.seconds = seconds;
//			gi.glatitude  = [NSString stringWithFormat:@"%lf",dealerCoordinate];
//			gi.glongitude = [NSString stringWithFormat:@"%lf",dealerCoordinate];
//			gi.predictable = predictable;
//			CGFloat dis = distanceToStop / 1609.344;
//			gi.distance  = [NSString stringWithFormat:@"%lf",dis];
//			[evDelegate.busInfoArray addObject:gi];
//		}
		[self.dealers addObject:dInfo];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PingMe" object:self];
}

@end
