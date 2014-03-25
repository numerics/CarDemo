//
//  CarModelCell.m
//  iPadCarDemo
//
//  Created by John Basile on 2/20/14.
//  Copyright (c) 2014 Numerics. All rights reserved.
//

#import "CarModelCell.h"

@implementation CarModelCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        self.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
        
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 1.0f;
        self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
        self.layer.shadowOpacity = 0.5f;
        // make sure we rasterize nicely for retina
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.layer.shouldRasterize = YES;
		
		self.carImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 195, 100)];
        //self.carImage = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 2.5, 2.5) ];
        self.carImage.contentMode = UIViewContentModeScaleAspectFit;//UIViewContentModeScaleAspectFill;
        self.carImage.clipsToBounds = YES;
		[self.contentView addSubview:self.carImage];
		
		self.brandName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
		[self.contentView addSubview:self.brandName];
		
	
    }
    return self;
}


- (void) layoutSubviews
{
    [super layoutSubviews];

	self.carImage.top = self.contentView.top + 2.5;
	self.carImage.left = self.contentView.left + 2.5;
	self.brandName.left = self.contentView.left + 10;
	self.brandName.top = self.contentView.bottom - 25;
    
}
@end
