//
//  GalleryBuyTable.m
//  iOs
//
//  Created by Bernardo Breder on 15/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "GalleryBuyTable.h"

@implementation GalleryBuyTable

- (GalleryBuy*)get:(NSInteger)Id
{
	NSString* sql = @"select id, picture_id from buy where id = ?";
    sqlite3_stmt* stmt;
    if (sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0) != SQLITE_OK) {
        return 0;
    }
    sqlite3_bind_int(stmt, 1, Id);
    GalleryBuy* data = 0;
    if (sqlite3_step(stmt) == SQLITE_ROW) {
        data = [[GalleryBuy alloc] init];
        data.Id = sqlite3_column_int(stmt, 0);
        data.pictureId = sqlite3_column_int(stmt, 1);
    }
    sqlite3_finalize(stmt);
    return data;
}

- (NSMutableArray*)list
{ 
	NSString* sql = @"select id, picture_id from buy";
    sqlite3_stmt* stmt;
    if (sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0) != SQLITE_OK) {
        return 0;
    }
    NSMutableArray* array = [[NSMutableArray alloc] init];
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        data = [[GalleryBuy alloc] init];
        data.Id = sqlite3_column_int(stmt, 0);
        data.pictureId = sqlite3_column_int(stmt, 1);
        [array addObject:data];
    }
    sqlite3_finalize(stmt);
    return array;
}

- (NSInteger)create:(NSInteger)pictureId
{
	NSString* sql = @"insert into buy (id, picture_id) values (?, ?)";
    sqlite3_stmt* stmt;
    if (sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0) != SQLITE_OK) {
        return 0;
    }
    sqlite3_bind_int(stmt, 2, pictureId);
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        sqlite3_finalize(stmt);
        return 0;
    }
    sqlite3_int64 lastId = sqlite3_last_insert_rowid(self.db);
    sqlite3_finalize(stmt);
    return (NSInteger)lastId;	
}

- (void)remove:(NSInteger)Id
{
    NSString* sql = @"delete from buy where id = ?";
    sqlite3_stmt* stmt;
    if (sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0) != SQLITE_OK) {
        return;
    }
    sqlite3_bind_int(stmt, 1, Id);
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        sqlite3_finalize(stmt);
        return;
    }
    sqlite3_finalize(stmt);	
}

@end
