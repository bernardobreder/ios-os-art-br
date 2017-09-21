//
//  GalleryDatabase.h
//  iOs
//
//  Created by Bernardo Breder on 15/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "DatabaseTable.h"
#import "GalleryCategoryTable.h"
#import "GalleryPictureTable.h"

@interface GalleryDatabase : DatabaseTable

@property (nonatomic, strong) GalleryCategoryTable* category;
@property (nonatomic, strong) GalleryPictureTable* picture;

- (id)init;

- (void)connect;

- (void)reset;

- (void)close;

- (void)begin;

- (bool)commit;

- (void)rollback;

@end
