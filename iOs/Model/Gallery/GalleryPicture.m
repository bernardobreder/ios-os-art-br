//
//  GalleryPicture.m
//  iOs
//
//  Created by Bernardo Breder on 15/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "GalleryPicture.h"

@implementation GalleryPicture

@synthesize Id;
@synthesize title;
@synthesize describer;
@synthesize value;
@synthesize width;
@synthesize height;
@synthesize smallImage;
@synthesize largeImage;

- (id)initWithId:(NSInteger)_Id andTitle:(NSString*)Title
{
    if (!(self = [super init])) return nil;
    self.Id = _Id;
    self.title = Title;
    return self;
}

@end
