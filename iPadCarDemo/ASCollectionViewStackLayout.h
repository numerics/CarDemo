//
//  UICollectionViewStackLayout.h
//  StackLayout
//
//  Created by Avraham Shukron on 26/09/13.
//  Copyright (c) 2012 Avraham Shukron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASCollectionViewStackLayout : UICollectionViewLayout

@property (assign, nonatomic) NSInteger minimumHorizontalStackSpacing;
@property (assign, nonatomic) NSInteger minimumVerticalStackSpacing;
@property (assign, nonatomic) NSInteger rotationAngelIncrement;

/*!
 For better user experience, the top item on a stack should not be rotated
 dramatically. So we compute a random mild rotation for the top item, and
 all the other items will be rotated according to this rotation combined
 with the @rotationAngelIncrement
 */
@property (assign, nonatomic) NSInteger maximumRotationOfTopItem;
@property (assign, nonatomic) CGSize maximumItemSize;
@property (assign, nonatomic) UIEdgeInsets contentInset;
@end
