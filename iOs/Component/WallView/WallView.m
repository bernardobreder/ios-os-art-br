//
//  WallView.m
//  iOs
//
//  Created by Bernardo Breder on 09/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "WallView.h"

@implementation WallView

- (id)init
{
    self = [super init];
    return self;
}

- (void)drawRect:(CGRect)rect
{
    int border = MIN(rect.size.width*0.05, rect.size.height*0.05);
    CGContextRef context = UIGraphicsGetCurrentContext();
    {
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    }
    {
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor);
        CGContextFillRect(context, CGRectMake(border, border, rect.size.width-2*border, rect.size.height-2*border));
    }
    {
        {
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 5, [UIColor blackColor].CGColor);
            CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0].CGColor);
            CGContextFillRect(context, CGRectMake(border, border, 1, rect.size.height-2*border));
            CGContextFillRect(context, CGRectMake(rect.size.width-border, border, 1, rect.size.height-2*border));
            CGContextFillRect(context, CGRectMake(border, border, rect.size.width-2*border, 1));
            CGContextFillRect(context, CGRectMake(border, rect.size.height-border, rect.size.width-2*border, 1));
            CGContextRestoreGState(context);
        }
    }
}

@end
