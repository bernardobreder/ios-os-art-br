//
//  GalleryBuy.h
//  iOs
//
//  Created by Bernardo Breder on 15/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GalleryPicture : NSObject

@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, assign) NSInteger pictureId;
@property (nonatomic, strong) GalleryPicture* picture;

- (id)init;

@end
