//
//  AppDelegate.h
//  iOs
//
//  Created by Bernardo Breder on 05/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryViewController.h"
#import "GalleryDatabase.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) GalleryDatabase* database;
@property (nonatomic, strong) UIWindow* window;
@property (nonatomic, strong) UIWindow* secondWindow;
@property (nonatomic, strong) GalleryViewController* mainViewController;

@end
