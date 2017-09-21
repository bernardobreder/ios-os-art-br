//
//  GalleryCategory.m
//  iOs
//
//  Created by Bernardo Breder on 15/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "GalleryCategory.h"

@implementation GalleryCategory

@synthesize Id;
@synthesize name;
@synthesize title;
@synthesize pictures;

- (id)initWithId:(int)_Id andName:(NSString*)Name andTitle:(NSString*)Title
{
    if (!(self = [super init])) return nil;
    self.Id = _Id;
    self.name = Name;
    self.title = Title;
    return self;
}

@end
