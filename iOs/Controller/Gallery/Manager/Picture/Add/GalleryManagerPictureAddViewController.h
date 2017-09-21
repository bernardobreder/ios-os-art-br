//
//  GalleryManagerPictureAddViewController.h
//  iOs
//
//  Created by Bernardo Breder on 18/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryCategory.h"
#import "UIGenericViewController.h"
#import "GalleryManagerPictureListViewController.h"

@interface GalleryManagerPictureAddViewController : UIGenericViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,  UITextFieldDelegate>

@property (nonatomic, strong) GalleryCategory* category;
@property (nonatomic, strong) GalleryPicture* picture;
@property (nonatomic, strong) GalleryManagerPictureListViewController* pictureManagerViewController;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIImage *image;

@end
