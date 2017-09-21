//
//  GalleryPicture.h
//  iOs
//
//  Created by Bernardo Breder on 15/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GalleryPicture : NSObject

@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, strong) NSString* title;

@property (nonatomic, strong) NSString* describer;

@property (nonatomic, assign) float value;

@property (nonatomic, assign) float width;

@property (nonatomic, assign) float height;

@property (nonatomic, strong) UIImage* largeImage;

@property (nonatomic, strong) UIImage* smallImage;

@property (nonatomic, assign) bool buying;

- (id)initWithId:(NSInteger)_Id andTitle:(NSString*)Title;

@end
