//
//  MainViewController.h
//  iOSMovie
//
//  Created by Bernardo Breder on 22/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIWindow* secondWindow;

@end
