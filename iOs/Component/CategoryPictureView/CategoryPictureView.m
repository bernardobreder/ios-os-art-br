//
//  CategoryPictureView.m
//  iOs
//
//  Created by Bernardo Breder on 06/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "CategoryPictureView.h"
#import "UIColor+LightAndDark.h"

@implementation CategoryPictureView

@synthesize image;

#define BORDER_SIZE 10
#define PICTURE_SIZE 50

- (id)init
{
    if (!(self = [super init])) return nil;
    self.opaque = false;
    return self;
}

- (id)initWithImage:(UIImage*)Image
{
    if (!(self = [super init])) return nil;
    self.frame = CGRectMake(0, 0, 2 * BORDER_SIZE + PICTURE_SIZE, 2 * BORDER_SIZE + PICTURE_SIZE);
    self.image = Image;
    self.opaque = false;
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawBack:rect];
    [self drawFront:rect];
}

- (void)drawFront:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor);
    CGContextFillRect(context, CGRectMake(10, 10, rect.size.width-20, rect.size.height-20));
    [self.image drawInRect:CGRectMake(15, 15, rect.size.width-30, rect.size.height-30)];
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0].CGColor);
    CGContextAddRect(context, CGRectMake(10, 10, rect.size.width-20, rect.size.height-20));
    CGContextAddRect(context, CGRectMake(15, 15, rect.size.width-30, rect.size.height-30));
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)drawBack:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8].CGColor);
    [self drawBack:rect rotated:10];
    [self drawBack:rect rotated:-10];
}

- (void)drawBack:(CGRect)rect rotated:(int)angle
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0.5f*self.frame.size.width, 0.5f*self.frame.size.height);
    CGContextRotateCTM(context, angle*M_PI/180);
    CGContextTranslateCTM(context, -0.5f*self.frame.size.width, -0.5f*self.frame.size.height);
    CGContextFillRect(context, CGRectMake(10, 10, rect.size.width-20, rect.size.height-20));
    CGContextSetStrokeColorWithColor(context, ([UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0]).CGColor);
    CGContextAddRect(context, CGRectMake(10, 10, rect.size.width-20, rect.size.height-20));
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end
