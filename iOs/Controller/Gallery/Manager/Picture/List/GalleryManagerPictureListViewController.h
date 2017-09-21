//
//  GalleryManagerPictureListViewController.h
//  iOs
//
//  Created by Bernardo Breder on 18/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGenericViewController.h"
#import "GalleryPicture.h"
#import "GalleryManagerCategoryListViewController.h"

@interface GalleryManagerPictureListViewController : UIGenericViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) GalleryCategory* category;
@property (nonatomic, strong) GalleryManagerCategoryListViewController* categoryManagerViewController;
@property (nonatomic, strong) NSMutableArray* array;

- (void)addPicture:(GalleryPicture*)picture;

- (void)updatePicture:(GalleryPicture*)picture;


@end
