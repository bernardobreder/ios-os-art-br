//
//  GalleryAddViewController.h
//  iOs
//
//  Created by Bernardo Breder on 15/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UIGenericViewController.h"
#import "GalleryManagerCategoryListViewController.h"

@interface GalleryManagerCategoryAddViewController : UIGenericViewController <UITextFieldDelegate>

@property (nonatomic, strong) GalleryCategory* category;
@property (nonatomic, strong) GalleryManagerCategoryListViewController* managerViewController;

@end
