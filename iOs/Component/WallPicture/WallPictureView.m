//
//  WallPictureView.m
//  iOs
//
//  Created by Bernardo Breder on 05/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "WallPictureView.h"

@implementation WallPictureView

@synthesize image;

- (id)init
{
    self = [super init];
    self.image = [UIImage imageNamed:@"wallpaper.jpg"];
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    { // Desenha a parede
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor);
        CGContextFillRect(context, CGRectMake(0, rect.size.height * 0.1, rect.size.width, rect.size.height * 0.8));
    }
    { // Desenha o teto
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height * 0.1));
    }
    { // Desenha o chão
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor);
        CGContextFillRect(context, CGRectMake(0, rect.size.height * 0.9, rect.size.width, rect.size.height * 0.1));
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setNeedsDisplay];
}

@end
