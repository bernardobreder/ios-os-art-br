//
//  UIHorizontalFillScrollView.h
//  iOs
//
//  Created by Bernardo Breder on 06/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIHorizontalFillScrollView : UIScrollView

@property (nonatomic, strong) UIView* contentView;

- (void)addNextSubview:(UIView *)view;

- (void)willAnimateRotation:(CGRect)rect;

- (void)setNeedsDisplayChildren;

- (void)viewDidAppear:(CGRect)rect;

@end
