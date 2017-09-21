//
//  UIHorizontalFillScrollView.m
//  iOs
//
//  Created by Bernardo Breder on 06/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UIHorizontalFillScrollView.h"

@implementation UIHorizontalFillScrollView

@synthesize contentView;

- (id)init
{
    self = [super init];
    self.pagingEnabled = true;
    self.showsHorizontalScrollIndicator = true;
    self.showsVerticalScrollIndicator = false;
    self.alwaysBounceVertical = false;
    contentView = [[UIView alloc] init];
    [super addSubview:contentView];
    return self;
}

- (void)addNextSubview:(UIView *)view
{
    [contentView addSubview:view];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    if (contentView.subviews.count == 1) {
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    } else {
        UIView* prevView = contentView.subviews[contentView.subviews.count - 2];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:prevView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    }
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
}

- (void)willAnimateRotation:(CGRect)rect
{
    CGSize size = self.frame.size;
    int pageIndex = ceil(self.contentOffset.x / rect.size.height);
    self.contentSize = CGSizeMake(rect.size.width * contentView.subviews.count, size.height);
    [self scrollRectToVisible:CGRectMake(pageIndex * size.width, 0, size.width, size.height) animated:YES];
}

- (void)setNeedsDisplayChildren
{
    for (int n = 0; n < contentView.subviews.count ; n++) {
        UIView* view = contentView.subviews[n];
        [view setNeedsDisplay];
    }
}

- (void)viewDidAppear:(CGRect)rect
{
    self.contentSize = CGSizeMake(rect.size.width * contentView.subviews.count, self.frame.size.height);
}

@end
