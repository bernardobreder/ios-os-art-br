//
//  PictureView.m
//  iOs
//
//  Created by Bernardo Breder on 05/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "PictureView.h"

@implementation PictureView

#define MARGIN_OFFSET 30.0
#define SHADOW_OFFSET 2.0
#define BORDER_SIZE 10.0
#define BORDER_INNER_SIZE 3

@synthesize image;
@synthesize heightInCm;

- (id)initWithImage:(UIImage*)Image
{
    self = [super init];
    self.image = Image;
    self.opaque = false;
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    {
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor);
        CGContextFillRect(context, rect);
    }
    {
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, CGSizeMake(0, 5), 10, [UIColor blackColor].CGColor);
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor);
        CGContextFillRect(context, [self rectWithOffset:rect withOffset:0]);
        CGContextRestoreGState(context);
    }
    {
        CGRect rect = [self rectBorder:rect];
        CGContextSetRGBStrokeColor(context, 0.7, 0.7, 0.7, 1.0);
        CGContextSetLineWidth(context, 1.0);
        CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x + BORDER_SIZE, rect.origin.y + BORDER_SIZE);
        CGContextMoveToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - BORDER_SIZE, rect.origin.y + BORDER_SIZE);
        CGContextMoveToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - BORDER_SIZE, rect.origin.y + rect.size.height - BORDER_SIZE);
        CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
        CGContextAddLineToPoint(context, rect.origin.x + BORDER_SIZE, rect.origin.y + rect.size.height - BORDER_SIZE);
        CGContextStrokePath(context);
    }
    {
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor);
        CGContextFillRect(context, [self rectInnerPicture:rect]);
        CGContextSetLineWidth(context, 2.0);
        CGContextSetRGBStrokeColor(context, 0.6, 0.6, 0.6, 1.0);
        CGContextStrokeRect(context, [self rectInnerPicture:rect]);
    }
    {
        [self.image drawInRect:[self rectPicture:rect]];
    }
}

- (CGRect) rectWithOffset:(CGRect)rect withOffset:(double)offset
{
    if (!rect.size.width || !rect.size.height) {
        return rect;
    }
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
    x += offset;
    y += offset;
    w -= 2 * offset;
    h -= 2 * offset;
    return CGRectMake(x + MARGIN_OFFSET, y + MARGIN_OFFSET, w - MARGIN_OFFSET * 2, h - MARGIN_OFFSET * 2);
}

- (CGRect) rectBorder:(CGRect)rect
{
    return [self rectWithOffset:rect withOffset:(SHADOW_OFFSET)];
}

- (CGRect) rectPicture:(CGRect)rect
{
    return [self rectWithOffset:rect withOffset:(SHADOW_OFFSET + BORDER_SIZE)];
}

- (CGRect) rectInnerPicture:(CGRect)rect
{
    CGRect frame = [self rectPicture:rect];
    int x = frame.origin.x - BORDER_INNER_SIZE;
    int y = frame.origin.y - BORDER_INNER_SIZE;
    int w = frame.size.width + 2 * BORDER_INNER_SIZE+1;
    int h = frame.size.height + 2 * BORDER_INNER_SIZE+1;
    return CGRectMake(x, y, w, h);
}

- (CGRect) rectInnerDarkPicture:(CGRect)rect
{
    CGRect frame = [self rectPicture:rect];
    int x = frame.origin.x - 0;
    int y = frame.origin.y - 0;
    int w = frame.size.width + 1;
    int h = frame.size.height + 1;
    return CGRectMake(x, y, w, h);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setNeedsDisplay];
}

@end
