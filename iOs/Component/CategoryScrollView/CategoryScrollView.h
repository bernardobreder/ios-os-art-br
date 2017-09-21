//
//  CategoryScrollView.h
//  iOs
//
//  Created by Bernardo Breder on 21/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UILazyPageView.h"
#import "CategoryPictureView.h"

@interface CategoryScrollView : UICollectionView

@property (nonatomic, strong) NSArray* array;

- (CategoryPictureView*)currentPictureView;

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

@end
