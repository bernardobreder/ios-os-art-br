//
//  GalleryBuyTable.h
//  iOs
//
//  Created by Bernardo Breder on 15/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "DatabaseTable.h"
#import "GalleryPicture.h"
#import "GalleryBuy.h"

@interface GalleryBuyTable : DatabaseTable

- (GalleryBuy*)get:(NSInteger)Id;

- (NSMutableArray*)list;

- (NSInteger)create:(NSInteger)pictureId;

- (void)remove:(NSInteger)Id;

@end
