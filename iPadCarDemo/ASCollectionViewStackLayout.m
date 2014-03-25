//
//  UICollectionViewStackLayout.m
//  StackLayout
//
//  Created by Avraham Shukron on 26/09/13.
//  Copyright (c) 2012 Avraham Shukron. All rights reserved.
//


#define DEGREES_TO_RADIANS(degrees) (degrees * (M_PI / 180.0))
#define RADIANS_TO_DEGREES(rad) (rad * (180.0 / M_PI))

#import "ASCollectionViewStackLayout.h"

@interface ASCollectionViewStackLayout ()
/*!
 A stack of rotated items will occupy more size than just the item size,
 because of the rotation. (Pythagoras' theorem)
 cˆ2 = (aˆ2 + bˆ2)
 */
@property (assign, nonatomic) CGFloat stackDiameter;
@property (assign, readonly) NSInteger numberOfStacksInLine;
@property (assign, nonatomic) CGFloat actualHorizontalSpaceBetweenStacks;

/*!
 @description 
 This property specifies how many items will be visible at most.
 It is used for optimization. Since all the items are stacked, all the bottom 
 items are not visible and there is no reason to load them into memory.
 */
@property (assign, nonatomic) NSUInteger numberOfItemsToShow;
@property (strong) NSArray *topItemRotationForEachSection;
@end

@implementation ASCollectionViewStackLayout

#pragma mark - Initializations

- (void)setupDefaultValues
{
    self.maximumRotationOfTopItem = 15;
    self.rotationAngelIncrement = 15;
    self.minimumHorizontalStackSpacing = 50;
    self.minimumVerticalStackSpacing = 50;
    self.maximumItemSize = CGSizeMake(200, 200);
    self.contentInset = UIEdgeInsetsMake(20, 20, 20, 20);
    // Optimization.
    self.numberOfItemsToShow = 360 / 15;
}

-(instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setupDefaultValues];
    }
    return self;
}

-(instancetype) init
{
    if (self = [super init])
    {
        [self setupDefaultValues];
    }
    return self;
}

#pragma mark - Getters

-(CGSize)collectionViewContentSize
{
	NSUInteger linesNeeded = ceilf((CGFloat)[self.collectionView numberOfSections] /
                                    (CGFloat)self.numberOfStacksInLine);
    CGFloat height = self.contentInset.top + self.contentInset.bottom + linesNeeded * (self.stackDiameter + self.minimumVerticalStackSpacing) - self.minimumVerticalStackSpacing;
    return CGSizeMake(self.collectionView.frame.size.width, height);
}

-(NSInteger) numberOfStacksInLine
{
    CGFloat fullWidth = self.collectionView.frame.size.width;
    CGFloat availableSpace = fullWidth -_contentInset.left - _contentInset.right;

    return floorf((availableSpace + self.minimumHorizontalStackSpacing) /
                  (_stackDiameter + _minimumHorizontalStackSpacing));
}

#pragma mark - UICollectionViewLayout

- (void)prepareLayout
{
	[super prepareLayout];

    CGFloat hypotenuse = sqrtf(powf(self.maximumItemSize.width, 2) +
                               powf(self.maximumItemSize.height, 2));
    self.stackDiameter = hypotenuse;

    self.actualHorizontalSpaceBetweenStacks = ((self.collectionView.frame.size.width -
                                           self.contentInset.left - self.contentInset.right) /
                                           self.numberOfStacksInLine);

    NSUInteger numberOfSections = [self.collectionView numberOfSections];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:numberOfSections];
    for (int i = 0; i < numberOfSections; i++)
    {
        // The top item rotation angle is in [-15, 15]
        NSNumber *angle = @((arc4random() % (self.maximumRotationOfTopItem * 2)) - self.maximumRotationOfTopItem);
        [array addObject:angle];
    }
    self.topItemRotationForEachSection = array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    CGRect frame = [self frameForStackAtSection:indexPath.section];
    attributes.center = CGPointMake(frame.origin.x + frame.size.width / 2,
                                    frame.origin.y + frame.size.height / 2);
    attributes.size = self.maximumItemSize;

    // Stack the items
    NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:indexPath.section];
    attributes.zIndex = numberOfItemsInSection - indexPath.item;

    // Rotate
    NSNumber *topItemAngle = self.topItemRotationForEachSection[indexPath.section];
    CGFloat angle = (indexPath.item * self.rotationAngelIncrement) + [topItemAngle integerValue];
    angle = DEGREES_TO_RADIANS(angle);
    attributes.transform3D = CATransform3DMakeRotation(angle, 0, 0, 1);

	return attributes;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
	NSMutableArray *attributes = [NSMutableArray array];

	for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++)
    {
        if ([self isStackAtSection:section visibleInBounds:rect])
        {
            NSInteger numberOfItems = MIN(self.numberOfItemsToShow, [self.collectionView numberOfItemsInSection:section]);
            for (int item = 0; item < numberOfItems; item++)
            {
                NSIndexPath *ip = [NSIndexPath indexPathForItem:item inSection:section];
                UICollectionViewLayoutAttributes *a = [self layoutAttributesForItemAtIndexPath:ip];
                [attributes addObject:a];
            }
        }
    }
    return attributes;
}

#pragma mark - Utilities
-(CGRect) frameForStackAtSection : (NSInteger) section
{
    CGRect frame = CGRectZero;
    frame.size = CGSizeMake(self.stackDiameter, self.stackDiameter);

    NSInteger line = floorf(section / self.numberOfStacksInLine);
    NSInteger column = section % self.numberOfStacksInLine;

    CGFloat x = self.contentInset.left + (column * self.actualHorizontalSpaceBetweenStacks);
    CGFloat y = self.contentInset.top + line*(self.minimumVerticalStackSpacing + self.stackDiameter);
    frame.origin = CGPointMake(x,y);
    return frame;
}

-(BOOL) isStackAtSection:(NSInteger)section visibleInBounds : (CGRect) bounds
{
    return CGRectIntersectsRect(bounds, [self frameForStackAtSection:section]);
}
@end
