//
//  GalleryManagerViewController.h
//  iOs
//
//  Created by Bernardo Breder on 15/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryViewController.h"
#import "UIGenericViewController.h"

@interface GalleryManagerCategoryListViewController : UIGenericViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) GalleryViewController* mainViewController;
@property (nonatomic, strong) NSMutableArray* array;
@property (nonatomic, strong) NSMutableArray* firsts;

- (void)addCategory:(GalleryCategory*)category;

- (void)updateCategory:(GalleryCategory*)category;

@end
