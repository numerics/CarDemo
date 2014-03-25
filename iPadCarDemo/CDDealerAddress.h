//
//  CDDealerAddress.h
//  iPadCarDemo
//
//  Created by John Basile on 2/18/14.
//  Copyright (c) 2014 Numerics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDDealerAddress : NSObject

@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *county;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@end
