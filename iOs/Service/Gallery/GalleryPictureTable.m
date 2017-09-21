//
//  GalleryPictureTable.m
//  iOs
//
//  Created by Bernardo Breder on 15/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "GalleryPictureTable.h"
#import "UIImage+Extras.h"
#import "UIImage+Resize.h"

@implementation GalleryPictureTable

- (GalleryPicture*)get:(NSInteger)Id
{
    NSString* sql = @"select id, title, describer, value, width, height, small_image, large_image from picture where id = ?";
    sqlite3_stmt* stmt;
    if (sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0) != SQLITE_OK) {
        return 0;
    }
    sqlite3_bind_int(stmt, 1, (int)Id);
    GalleryPicture* data = 0;
    if (sqlite3_step(stmt) == SQLITE_ROW) {
        data = [[GalleryPicture alloc] init];
        data.Id = sqlite3_column_int(stmt, 0);
        data.title = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
        data.describer = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
        data.value = sqlite3_column_double(stmt, 3);
        data.width = sqlite3_column_double(stmt, 4);
        data.height = sqlite3_column_double(stmt, 5);
		NSData *smallImageData = [[NSData alloc] initWithBytes:sqlite3_column_blob(stmt, 6) length:sqlite3_column_bytes(stmt, 6)];
        //        NSData *largeImageData = [[NSData alloc] initWithBytes:sqlite3_column_blob(stmt, 7) length:sqlite3_column_bytes(stmt, 7)];
        if (smallImageData) {
			data.smallImage = [UIImage imageWithData:smallImageData];
		}
        //        if (largeImageData) {
        //			data.largeImage = [UIImage imageWithData:largeImageData];
        //		}
    }
    sqlite3_finalize(stmt);
    return data;
}

- (UIImage*)largeImage:(NSInteger)Id
{
    NSString* sql = @"select large_image from picture where id = ?";
    sqlite3_stmt* stmt;
    if (sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0) != SQLITE_OK) {
        return 0;
    }
    sqlite3_bind_int(stmt, 1, (int)Id);
    UIImage* data = 0;
    if (sqlite3_step(stmt) == SQLITE_ROW) {
        NSData *largeImageData = [[NSData alloc] initWithBytes:sqlite3_column_blob(stmt, 0) length:sqlite3_column_bytes(stmt, 0)];
        if (largeImageData) {
            data = [UIImage imageWithData:largeImageData];
        }
    }
    sqlite3_finalize(stmt);
    return data;
}

- (NSMutableArray*)list:(NSInteger)categoryId
{
    NSString* sql = @"select p.id, p.title, p.describer, p.value, p.width, p.height, p.small_image from picture p, category_picture cp where cp.category_id = ? and cp.picture_id = p.id order by cp.position";
    sqlite3_stmt* stmt;
    if (sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0) != SQLITE_OK) {
        return 0;
    }
    sqlite3_bind_int(stmt, 1, (int)categoryId);
    NSMutableArray* array = [[NSMutableArray alloc] init];
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        GalleryPicture* data = [[GalleryPicture alloc] init];
        data.Id = sqlite3_column_int(stmt, 0);
        data.title = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
        data.describer = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
        data.value = sqlite3_column_double(stmt, 3);
        data.width = sqlite3_column_double(stmt, 4);
        data.height = sqlite3_column_double(stmt, 5);
		NSData *smallImageData = [[NSData alloc] initWithBytes:sqlite3_column_blob(stmt, 6) length:sqlite3_column_bytes(stmt, 6)];
        if (smallImageData) {
			data.smallImage = [UIImage imageWithData:smallImageData];
		}
        [array addObject:data];
    }
    sqlite3_finalize(stmt);
    return array;
}

- (GalleryPicture*)first:(NSInteger)categoryId
{
    NSString* sql = @"select p.id, p.title, p.describer, p.value, p.width, p.height, p.small_image from picture p, category_picture cp where cp.category_id = ? and cp.picture_id = p.id order by cp.position limit 1";
    sqlite3_stmt* stmt;
    if (sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0) != SQLITE_OK) {
        return 0;
    }
    sqlite3_bind_int(stmt, 1, (int)categoryId);
    GalleryPicture* data = 0;
    if (sqlite3_step(stmt) == SQLITE_ROW) {
        data = [[GalleryPicture alloc] init];
        data.Id = sqlite3_column_int(stmt, 0);
        data.title = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
        data.describer = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
        data.value = sqlite3_column_double(stmt, 3);
        data.width = sqlite3_column_double(stmt, 4);
        data.height = sqlite3_column_double(stmt, 5);
		NSData *smallImageData = [[NSData alloc] initWithBytes:sqlite3_column_blob(stmt, 6) length:sqlite3_column_bytes(stmt, 6)];
        if (smallImageData) {
			data.smallImage = [UIImage imageWithData:smallImageData];
		}
    }
    sqlite3_finalize(stmt);
    return data;
}

- (NSInteger)create:(NSString*)title describer:(NSString*)describer value:(double)value width:(double)width height:(double)height image:(UIImage*)image
{
    NSString* sql = @"insert into picture (id, title, describer, value, width, height, small_image, large_image) values (?, ?, ?, ?, ?, ?, ?, ?)";
    sqlite3_stmt* stmt;
    if (sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0) != SQLITE_OK) {
        return 0;
    }
    sqlite3_bind_text(stmt, 2, [title UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 3, [describer UTF8String], -1, nil);
    sqlite3_bind_double(stmt, 4, value);
    sqlite3_bind_double(stmt, 5, width);
    sqlite3_bind_double(stmt, 6, height);
    if (image) {
        UIImage *smallImage = [image scaledProporcionalToSize:CGSizeMake(100, 100)];
        UIImage *largeImage = [image scaledProporcionalToSize:CGSizeMake(2000, 2000)];
        NSData *jpgSmallImageData = UIImageJPEGRepresentation(smallImage, 0.75);
        NSData *jpgLargeImageData = UIImageJPEGRepresentation(largeImage, 0.75);
        sqlite3_bind_blob(stmt, 7, [jpgSmallImageData bytes], (int)[jpgSmallImageData length], NULL);
        sqlite3_bind_blob(stmt, 8, [jpgLargeImageData bytes], (int)[jpgLargeImageData length], NULL);
    } else {
        sqlite3_bind_null(stmt, 7);
        sqlite3_bind_null(stmt, 8);
    }
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        sqlite3_finalize(stmt);
        return 0;
    }
    sqlite3_int64 lastId = sqlite3_last_insert_rowid(self.db);
    sqlite3_finalize(stmt);
    return (int)lastId;
}

- (void)remove:(NSInteger)Id
{
    NSString* sql = @"delete from picture where id = ?";
    sqlite3_stmt* stmt;
    if (sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0) != SQLITE_OK) {
        return;
    }
    sqlite3_bind_int(stmt, 1, (int)Id);
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        sqlite3_finalize(stmt);
        return;
    }
    sqlite3_finalize(stmt);
}

- (bool)update:(NSInteger)Id title:(NSString*)title describer:(NSString*)describer value:(double)value width:(double)width height:(double)height image:(UIImage*)image
{
    NSString* sql = @"update picture set title = ?, describer = ?, value = ?, width = ?, height = ?, small_image = ?, large_image = ? where id = ?";
    sqlite3_stmt* stmt;
    if (sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0) != SQLITE_OK) {
        return false;
    }
    sqlite3_bind_text(stmt, 1, [title UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 2, [describer UTF8String], -1, nil);
    sqlite3_bind_double(stmt, 3, value);
    sqlite3_bind_double(stmt, 4, width);
    sqlite3_bind_double(stmt, 5, height);
    if (image) {
        UIImage *smallImage = [image scaledProporcionalToSize:CGSizeMake(100, 100)];
        UIImage *largeImage = [image scaledProporcionalToSize:CGSizeMake(2000, 2000)];
        NSData *jpgSmallImageData = UIImageJPEGRepresentation(smallImage, 0.75);
        NSData *jpgLargeImageData = UIImageJPEGRepresentation(largeImage, 0.75);
        sqlite3_bind_blob(stmt, 6, [jpgSmallImageData bytes], (int)[jpgSmallImageData length], NULL);
        sqlite3_bind_blob(stmt, 7, [jpgLargeImageData bytes], (int)[jpgLargeImageData length], NULL);
    } else {
        sqlite3_bind_null(stmt, 6);
        sqlite3_bind_null(stmt, 7);
    }
    sqlite3_bind_int(stmt, 8, (int)Id);
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        sqlite3_finalize(stmt);
        return false;
    }
    sqlite3_finalize(stmt);
    return true;
}

//- (bool)updateImage:(NSInteger)Id image:(UIImage*)image
//{
//	NSString* sql = @"update picture set small_image = ?, large_image = ? where id = ?";
//    sqlite3_stmt* stmt;
//    if (sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0) != SQLITE_OK) {
//        return false;
//    }
//	UIImage *smallImage = [image imageByBestFitForSize:CGSizeMake(100, 100)];
//	UIImage *largeImage = [image imageByBestFitForSize:CGSizeMake(2000, 2000)];
//	NSData *jpgSmallImageData = UIImageJPEGRepresentation(smallImage, 0.75);
//	NSData *jpgLargeImageData = UIImageJPEGRepresentation(largeImage, 0.75);
//    sqlite3_bind_blob(stmt, 1, [jpgSmallImageData bytes], (int)[jpgSmallImageData length], NULL);
//	sqlite3_bind_blob(stmt, 2, [jpgLargeImageData bytes], (int)[jpgLargeImageData length], NULL);
//    sqlite3_bind_int(stmt, 3, (int)Id);
//    if (sqlite3_step(stmt) != SQLITE_DONE) {
//        sqlite3_finalize(stmt);
//        return false;
//    }
//	sqlite3_finalize(stmt);
//    return true;
//}

- (bool)order:(NSInteger)categoryId pictureSourceId:(NSInteger)Id pictureTargetId:(NSInteger)otherId
{
    int sourceOrder = -1, targetOrder = -1;
    sqlite3_stmt* stmt;
    {
        NSString* sql = @"select picture_id, position from category_picture where category_id = ? and (picture_id = ? or picture_id = ?)";
        if (sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0) != SQLITE_OK) {
            return false;
        }
        sqlite3_bind_int(stmt, 1, (int)categoryId);
        sqlite3_bind_int(stmt, 2, (int)Id);
        sqlite3_bind_int(stmt, 3, (int)otherId);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            if (sqlite3_column_int(stmt, 0) == Id){
                sourceOrder = sqlite3_column_int(stmt, 1);
            } else {
                targetOrder = sqlite3_column_int(stmt, 1);
            }
        }
        sqlite3_finalize(stmt);
    }
    if (sourceOrder < 0 || targetOrder < 0) {
        return false;
    }
    if (sourceOrder < targetOrder) {
        {
            NSString* sql = @"update category_picture set position = position + 1 where category_id = ? and position > ?";
            if (sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0) != SQLITE_OK) {
                return false;
            }
            sqlite3_bind_int(stmt, 1, (int)categoryId);
            sqlite3_bind_int(stmt, 2, (int)targetOrder);
            if (sqlite3_step(stmt) != SQLITE_DONE) {
                sqlite3_finalize(stmt);
                return false;
            }
            sqlite3_finalize(stmt);
        }
        {
            NSString* sql = @"update category_picture set position = ? where category_id = ? and picture_id = ?";
            if (sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0) != SQLITE_OK) {
                return false;
            }
            sqlite3_bind_int(stmt, 1, targetOrder + 1);
            sqlite3_bind_int(stmt, 2, (int)categoryId);
            sqlite3_bind_int(stmt, 3, (int)Id);
            if (sqlite3_step(stmt) != SQLITE_DONE) {
                sqlite3_finalize(stmt);
                return false;
            }
            sqlite3_finalize(stmt);
        }
    } else {
        {
            NSString* sql = @"update category_picture set position = position + 1 where category_id = ? and position >= ?";
            if (sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0) != SQLITE_OK) {
                return false;
            }
            sqlite3_bind_int(stmt, 1, (int)categoryId);
            sqlite3_bind_int(stmt, 2, (int)targetOrder);
            if (sqlite3_step(stmt) != SQLITE_DONE) {
                sqlite3_finalize(stmt);
                return false;
            }
            sqlite3_finalize(stmt);
        }
        {
            NSString* sql = @"update category_picture set position = ? where category_id = ? and picture_id = ?";
            if (sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0) != SQLITE_OK) {
                return false;
            }
            sqlite3_bind_int(stmt, 1, targetOrder);
            sqlite3_bind_int(stmt, 2, (int)categoryId);
            sqlite3_bind_int(stmt, 3, (int)Id);
            if (sqlite3_step(stmt) != SQLITE_DONE) {
                sqlite3_finalize(stmt);
                return false;
            }
            sqlite3_finalize(stmt);
        }
    }
    return true;
}

@end
