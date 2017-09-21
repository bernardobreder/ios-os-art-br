//
//  GalleryPictureTable.h
//  iOs
//
//  Created by Bernardo Breder on 15/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "DatabaseTable.h"
#import "GalleryPicture.h"

@interface GalleryPictureTable : DatabaseTable

- (GalleryPicture*)get:(NSInteger)Id;

- (UIImage*)largeImage:(NSInteger)Id;

- (NSMutableArray*)list:(NSInteger)categoryId;

- (GalleryPicture*)first:(NSInteger)categoryId;

- (NSInteger)create:(NSString*)title describer:(NSString*)describer value:(double)value width:(double)width height:(double)height image:(UIImage*)image;

- (void)remove:(NSInteger)Id;

- (bool)update:(NSInteger)Id title:(NSString*)title describer:(NSString*)describer value:(double)value width:(double)width height:(double)height image:(UIImage*)image;

- (bool)order:(NSInteger)categoryId pictureSourceId:(NSInteger)Id pictureTargetId:(NSInteger)otherId;

//- (bool)updateImage:(NSInteger)Id image:(UIImage*)image;

@end
