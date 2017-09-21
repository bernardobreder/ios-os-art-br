//
//  PictureScrollView.h
//  iOs
//
//  Created by Bernardo Breder on 05/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureView.h"
#import "UILazyPageView.h"

@interface PictureScrollView : UILazyPageView

@property (nonatomic, strong) NSArray* array;

- (PictureView*)currentPictureView;

- (void)layoutSubviewsFromRect:(CGRect)fromRect toRect:(CGRect)toRect;

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

@end
