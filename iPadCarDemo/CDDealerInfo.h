//
//  CDDealerInfo.h
//  iPadCarDemo
//
//  Created by John Basile on 2/18/14.
//  Copyright (c) 2014 Numerics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
#import "CDDealerAddress.h"
#import "CDDealerOperations.h"
#import "CDDealerContactInfo.h"


@class MKObjectView;
@class CDDealerAddress;
@class CDDealerOperations;
@class CDDealerContactInfo;

@interface CDDealerInfo : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic,strong) MKObjectView *myGrlViewObj;

@property (nonatomic, strong) NSString				*locationId;
@property (nonatomic, strong) CDDealerAddress		*address;
@property (nonatomic, strong) NSString				*name;
@property (nonatomic, strong) NSString				*type;
@property (nonatomic, strong) NSString				*make;
@property (nonatomic, strong) CDDealerOperations	*operations;
@property (nonatomic, strong) CDDealerContactInfo	*contactinfo;

@property (nonatomic, strong) NSNumber				*latitude;
@property (nonatomic, strong) NSNumber				*longitude;

@property (nonatomic, readwrite, copy) NSString		*subtitle;
@property (nonatomic, readwrite, copy) NSString		*title;


- (id)initWithCarType:(NSString *)carType;

- (void)updatesMapInfo;

+ (NSString *)classKeyName;

@end
