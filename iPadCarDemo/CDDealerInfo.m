//
//  CDDealerInfo.m
//  iPadCarDemo
//
//  Created by John Basile on 2/18/14.
//  Copyright (c) 2014 Numerics. All rights reserved.
//

#import "CDDealerInfo.h"



@implementation CDDealerInfo

+ (NSString *)classKeyName;
{
	return @"dealerHolder";
}

- (id)initWithCarType:(NSString *)carType
{
	self = [super init];
    if (self)
	{
		self.subtitle = carType;
		self.title = @"Dealer";								// prevents overwrite by FetchData
		self.address = [[CDDealerAddress alloc] init];
		self.operations = [[CDDealerOperations alloc] init];
		self.contactinfo = [[CDDealerContactInfo alloc] init];
		
	}
	return self;
}

- (void)updatesMapInfo
{
	self.latitude = self.address.latitude;// [NSNumber numberWithDouble:[self.address.latitude doubleValue]];
	self.longitude = self.address.longitude;// [NSNumber numberWithDouble:[self.address.longitude doubleValue]];
	self.coordinate = CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
	
	self.title = self.name;
}


@end
