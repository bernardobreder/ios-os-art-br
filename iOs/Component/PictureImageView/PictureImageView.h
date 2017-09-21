//
//  PictureImageView.h
//  iOs
//
//  Created by Bernardo Breder on 16/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureImageView : UIImageView

@property (nonatomic, strong) UIImage* image;

- (id)initWithName:(NSString*)name;

- (CGRect) rectPicture:(CGRect)rect;

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

@end
