//
//  GalleryCategoryListViewController.h
//  iOs
//
//  Created by Bernardo Breder on 05/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

@import UIKit;
@import MediaPlayer;
#import "UIGenericViewController.h"
#import "WallPictureView.h"
#import "PictureScrollView.h"
#import "UIHorizontalFillScrollView.h"
#import "WallView.h"
#import "WallScrollView.h"
#import "GalleryDatabase.h"
#import "UILazyPageView.h"

@interface GalleryViewController : UIGenericViewController <UIAlertViewDelegate, UIScrollViewDelegate, UILazyPageViewDataSource, UICollectionViewDataSource>

@property (nonatomic, strong) UIWindow* secondWindow;
@property (nonatomic, strong) PictureView* imageSecondWindow;
@property (nonatomic, strong) GalleryDatabase* database;

@property (nonatomic, strong) NSArray *categorys;
@property (nonatomic, strong) GalleryCategory* category;
@property (nonatomic, strong) NSArray *pictures;

@property (nonatomic, strong) UICollectionView* categoryView;

@end
