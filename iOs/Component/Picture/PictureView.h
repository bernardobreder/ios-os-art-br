//
//  PictureView.h
//  iOs
//
//  Created by Bernardo Breder on 05/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureView : UIView

@property (nonatomic, strong) UIImage* image;
@property (nonatomic, assign) double heightInCm;

- (id)initWithImage:(UIImage*)image;

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

@end
