//
//  PictureImageView.m
//  iOs
//
//  Created by Bernardo Breder on 16/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "PictureImageView.h"

@implementation PictureImageView

#define MARGIN_OFFSET 30.0
#define SHADOW_OFFSET 2.0
#define BORDER_SIZE 10.0
#define BORDER_INNER_SIZE 3

@synthesize image;

- (id)initWithName:(NSString*)name
{
    self = [super init];
    self.image = [UIImage imageNamed:name];
    self.opaque = false;
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self.image drawInRect:[self rectPicture:rect]];
}

- (CGRect) rectPicture:(CGRect)rect
{
    double width = self.frame.size.width;
    double height = self.frame.size.height;
    double imgWidth = self.image.size.width;
    double imgHeight = self.image.size.height;
    double x = 0;
    double y = 0;
    double w = imgWidth * height / imgHeight;
    double h = height;
    if (w > width) {
        w = width;
        h = imgHeight * width / imgWidth;
    }
    if (w == width) {
        x = 0;
        y = (height - h) / 2;
    } else {
        x = (width - w) / 2;
        y = 0;
    }
    return CGRectMake(x, y, w, h);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setNeedsDisplay];
}

@end
