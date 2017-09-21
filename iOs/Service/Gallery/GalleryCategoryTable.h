//
//  GalleryCategoryTable.h
//  iOs
//
//  Created by Bernardo Breder on 15/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "DatabaseTable.h"
#import "GalleryCategory.h"
#import "GalleryPicture.h"

@interface GalleryCategoryTable : DatabaseTable

- (GalleryCategory*)get:(int)Id;

- (NSMutableArray*)list;

- (int)create:(NSString*)name title:(NSString*)title;

- (void)remove:(NSInteger)Id;

- (bool)order:(NSInteger)Id withId:(NSInteger)otherId;

- (bool)update:(NSInteger)Id name:(NSString*)name title:(NSString*)title;

- (bool)addChild:(NSInteger)Id picture:(NSInteger)pictureId;

@end
