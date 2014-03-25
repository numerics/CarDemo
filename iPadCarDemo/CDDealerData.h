//
//  CDDealerData.h
//  iPadCarDemo
//
//  Created by John Basile on 2/18/14.
//  Copyright (c) 2014 Numerics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDDealerInfo.h"

@interface CDDealerData : NSObject

@property (nonatomic, strong) NSMutableArray		*dealers;

@property (nonatomic, strong) NSString				*type;
@property (strong, nonatomic) CLLocation			*centerLocation;


- (id)initWithCarType:(NSString *)carType at:(CLLocation *)centerLocation;

@end
