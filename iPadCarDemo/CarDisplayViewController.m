//
//  CarDisplayViewController.m
//  iPadCarDemo
//
//  Created by John Basile on 2/17/14.
//  Copyright (c) 2014 Numerics. All rights reserved.
//

#import "CarDisplayViewController.h"
#import "UIImage+ImageEffects.h"
#import "CarModelCell.h"
#import "ASCollectionViewStackLayout.h"
#import "UIUtil.h"

#define kCellIdentifier @"CELL_ID"

@interface CarDisplayViewController ()

@property (nonatomic, strong) UICollectionView				*collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout     *defaultLayout;
@property (nonatomic) int currentIndex;
@property (nonatomic) int currentMode;				// 0 = Model, 1 = Make, 2 = Car

@end


@implementation CarDisplayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor colorWithPatternImage: [[UIFactory sharedInstance] viewBackgroundForOrientation:self.interfaceOrientation]]];
    [self setNavigationBackground:self.interfaceOrientation];
	self.navigationItem.RightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Dealers", @"Dealers") style:UIBarButtonItemStylePlain target:self action:@selector(revealDealers:)];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(changeCurrentMode:)]; /// NEED TO HIDE IT
	
	self.carModelArray = [[CarAppDelegate sqlite] executeQuery:@"SELECT * FROM BRANDS"];
	
    self.defaultLayout = [[UICollectionViewFlowLayout alloc] init];
	self.defaultLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
	self.currentMode = 0;	// first time thru in CarModel Mode
	CGRect frame = self.view.bounds;
    self.collectionView = [[UICollectionView alloc] initWithFrame: frame collectionViewLayout: self.defaultLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.scrollEnabled = YES;
	self.collectionView.alwaysBounceHorizontal = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
	self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.collectionView registerClass:[CarModelCell class] forCellWithReuseIdentifier:kCellIdentifier];

    [self.view addSubview: self.collectionView];
	
//	UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
//    recognizer.delegate = self;
//    [self.collectionView addGestureRecognizer:recognizer];
	
//	self.carModelArray = [[CarAppDelegate sqlite] executeQueryCol:@"Main Image" withSql:@"SELECT * FROM AUTOS WHERE ModelPrimary = 1"];
//	
//	NSArray *cBrand = [[CarAppDelegate sqlite] executeQuery:@"SELECT * FROM AUTOS WHERE brand = ?", [self.carModelArray objectAtIndex:5]];
//	NSArray *cBrandID = [[CarAppDelegate sqlite] executeQueryCol:@"rowid" withSql:@"SELECT rowid, * FROM AUTOS WHERE brand = ?", [self.carModelArray objectAtIndex:5]];
	
//	NSDictionary *brand = [self.carModelArray objectAtIndex:5];
//	NSArray *cBrandID = [[CarAppDelegate sqlite] executeQuery:@"SELECT ID, Brand, *FROM AUTOS WHERE brand = ? AND ModelPrimary = 1",[brand objectForKey:@"Brand"] ];
//	
//	NSLog(@"Cars for the Model = %@",[self.carModelArray objectAtIndex:5]);
//	NSLog(@"Car: = %@",cBrandID);
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    NSString *tClass = NSStringFromClass([touch.view class]);
//    BOOL btnS = ![tClass isEqualToString:@"CarModelCell"];
//    if( !btnS )
//        return NO;
//    else
//        return YES;
//}
//
//- (void) singleTap:(UITapGestureRecognizer *)recognizer
//{
//
//}

- (void)revealDealers:(id)sender
{
	self.mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController_iPad" bundle:nil];
	self.mapViewController.cardealer = self.selectedBrand;
	
	[self.navigationController pushViewController:self.mapViewController animated:YES];
}

- (void)changeCurrentMode:(id)sender
{
	if( self.currentMode == 1 )
	{
		self.currentMode = 0;
		[self.collectionView reloadData];
		[self.collectionView setCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init] animated:YES];
		self.carMakeData = nil;
	}
	else if( self.currentMode == 2 )
	{
		self.currentMode = 1;
		[self.collectionView reloadData];
		[self.collectionView setCollectionViewLayout:[[ASCollectionViewStackLayout alloc] init] animated:YES];
		[self.navigationItem.leftBarButtonItem setTitle:NSLocalizedString(@"Models", @"Models")];
		
	}
}


#pragma mark - UICollectionView Data Source Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	NSInteger count = 1;		/// TBD Could change later...
	if( self.currentMode == 0)			// CarModel Mode, Flow Layout
	{
		count = 1;
	}
	else if (self.currentMode == 1)		// CarMake Mode, Stack Layout
	{
		return [self.carMakeData count];
	}
	else if (self.currentMode == 2)		// Car Mode, Flow Layout
	{
		count = [self.carMakeData count];
	}
	return count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	NSInteger count = 1;

	if( self.currentMode == 0)			// CarModel Mode, Flow Layout
	{
		count = [self.carModelArray count];
	}
	else if (self.currentMode == 1)		// CarMake Mode, Stack Layout
	{
		count = 4;
	}
	else if (self.currentMode == 2)		// Car Mode, Flow Layout
	{
		count = 4;
	}
	return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CarModelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
	if( self.currentMode == 0)			// CarModel Mode, Flow Layout
	{
		NSDictionary *brand = [self.carModelArray objectAtIndex:indexPath.item];
		NSString *imageName = [brand objectForKey:@"Main Image"];			/// NEED TO FIX, Brands Table uses Main Image vs MainImage in Autos Table...
		
		cell.carImage.image = [UIImage imageNamed:imageName];
		cell.brandName.text = [brand objectForKey:@"Brand"];
	}
	else if (self.currentMode == 1)		// CarMake Mode, Stack Layout
	{
		NSString *imageName;
		NSDictionary *carMake = [self.carMakeData objectAtIndex:indexPath.section];
		if( indexPath.item == 0 )
		{
			imageName = [carMake objectForKey:@"MainImage"];
		}
		else /// if (indexPath.item > 0 )
		{
			imageName = [carMake objectForKey:[NSString stringWithFormat:@"Image%ld",(long)indexPath.item]];
		}
		UIImage *car = [UIImage imageNamed:imageName];
		if( car == nil)
		{
			NSLog(@"No Image for: %@", imageName);
		}
		cell.carImage.image = car;
		cell.brandName.text = [carMake objectForKey:@"Type"];
	}
	else if (self.currentMode == 2)		// Car Mode, Flow Layout
	{
		NSString *imageName;
		NSDictionary *carMake = [self.carMakeData objectAtIndex:indexPath.section];
		if( indexPath.item == 0 )
		{
			imageName = [carMake objectForKey:@"MainImage"];
		}
		else /// if (indexPath.item > 0 )
		{
			imageName = [carMake objectForKey:[NSString stringWithFormat:@"Image%ld",(long)indexPath.item]];
		}
		UIImage *car = [UIImage imageNamed:imageName];
		if( car == nil)
		{
			NSLog(@"No Image for: %@", imageName);
		}
		cell.carImage.image = car;
		cell.brandName.text = [carMake objectForKey:@"Type"];
	}
	
    return cell;
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(200, 120);
}

-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
#pragma mark - UICollectionView Delegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	
	if (([self.collectionView.collectionViewLayout isKindOfClass:[ASCollectionViewStackLayout class]]))
	{
		self.currentMode = 2;																							// going to Car Mode
//		NSDictionary *makes = [self.carMakeData objectAtIndex:indexPath.section];
//		
//		[self.collectionView reloadData];
		[self.collectionView setCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init] animated:YES];
		[self.navigationItem.leftBarButtonItem setTitle:NSLocalizedString(@"Make", @"Make")];
	}
	else
	{
		if( self.currentMode == 0 )
		{
			self.currentMode = 1;																				// going to Car Make
			NSDictionary *brand = [self.carModelArray objectAtIndex:indexPath.item];
			NSString * brandName = [brand objectForKey:@"Brand"];
			self.selectedBrand = [brand objectForKey:@"Brand"];
			
			self.carMakeData = [[CarAppDelegate sqlite] executeQuery:@"SELECT ID, Brand, *FROM AUTOS WHERE brand = ? AND ModelPrimary = 1",brandName];
			
			
			/// TODO Should check for errors, etc...
			[self.collectionView reloadData];
			[self.collectionView setCollectionViewLayout:[[ASCollectionViewStackLayout alloc] init] animated:YES];
			[self.navigationItem.leftBarButtonItem setTitle:NSLocalizedString(@"Models", @"Models")];
			
		}
		else	// The only way to be here... is currentMode = 2, now want to see individual card of a Make
		{
			[UIUtil alertMessage:@"Car Data Coming Soon"];
//			[self.collectionView reloadData];
//			[self.collectionView setCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init] animated:YES];
			
			//[self.navigationItem.leftBarButtonItem setTitle:NSLocalizedString(@"Make", @"Make")];

		}
	}
}

#pragma mark - Rotation Methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	
    // Fade the collectionView out
    [self.collectionView setAlpha:0.0f];
    
    // Suppress the layout errors by invalidating the layout
    [self.collectionView.collectionViewLayout invalidateLayout];
	
    // Calculate the index of the item that the collectionView is currently displaying
    CGPoint currentOffset = [self.collectionView contentOffset];
    self.currentIndex = currentOffset.x / self.collectionView.frame.size.width;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	
    // Force realignment of cell being displayed
    CGSize currentSize = self.collectionView.bounds.size;
    float offset = self.currentIndex * currentSize.width;
    [self.collectionView setContentOffset:CGPointMake(offset, 0)];
    
    // Fade the collectionView back in
    [UIView animateWithDuration:0.125f animations:^{
        [self.collectionView setAlpha:1.0f];
    }];
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self.view setBackgroundColor:[UIColor colorWithPatternImage: [[UIFactory sharedInstance] viewBackgroundForOrientation:toInterfaceOrientation]]];

    [self setNavigationBackground:toInterfaceOrientation];
	
}

- (void)setNavigationBackground:(UIInterfaceOrientation)orientation
{
    UIImage *backgroundImage = UIInterfaceOrientationIsPortrait(orientation) ? [[UIFactory sharedInstance] navigationBackgroundForBarMetrics:UIBarMetricsDefault] : [[UIFactory sharedInstance] navigationBackgroundForBarMetrics:UIBarMetricsLandscapePhone];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsLandscapePhone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
