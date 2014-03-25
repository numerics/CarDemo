//
//  CarDisplayViewController.h
//  iPadCarDemo
//
//  Created by John Basile on 2/17/14.
//  Copyright (c) 2014 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@interface CarDisplayViewController : UIViewController<UIGestureRecognizerDelegate,UICollectionViewDataSource, UICollectionViewDelegate>
{
	
}
@property (nonatomic, strong) MapViewController *mapViewController;

@property (nonatomic, strong) UIView			*leftMenuView;
@property (nonatomic, strong) UIView			*rightSlideView;
@property (nonatomic, strong) UIImageView		*backgroundImageV;

@property (nonatomic, strong) NSArray			*carData;
@property (nonatomic, strong) NSArray			*carMakeData;
@property (nonatomic, strong) NSArray			*carModelArray;

@property (nonatomic, strong) NSString			*selectedBrand;

@end
