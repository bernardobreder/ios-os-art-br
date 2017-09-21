//
//  GalleryCategory.h
//  iOs
//
//  Created by Bernardo Breder on 15/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GalleryCategory : NSObject

@property (nonatomic, assign) int Id;

@property (nonatomic, strong) NSString* name;

@property (nonatomic, strong) NSString* title;

@property (nonatomic, strong) NSMutableArray* pictures;

- (id)initWithId:(int)Id andName:(NSString*)name andTitle:(NSString*)title;

@end
