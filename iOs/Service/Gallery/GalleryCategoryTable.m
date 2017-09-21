//
//  GalleryCategoryTable.m
//  iOs
//
//  Created by Bernardo Breder on 15/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "GalleryCategoryTable.h"
#import "sqlite3.h"

@implementation GalleryCategoryTable

- (GalleryCategory*)get:(int)Id
{
    NSString* sql = @"select name, title from category where id = ?";
    sqlite3_stmt* stmt;
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0);
    if (result != SQLITE_OK) {
        return 0;
    }
    sqlite3_bind_int(stmt, 1, Id);
    GalleryCategory* data = 0;
    if (sqlite3_step(stmt) == SQLITE_ROW) {
        data = [[GalleryCategory alloc] init];
        data.name = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 0) encoding:NSUTF8StringEncoding];
        data.title = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
    }
    if (result != SQLITE_OK) {
        sqlite3_finalize(stmt);
        return 0;
    }
    sqlite3_finalize(stmt);
    return data;
}
//
- (NSMutableArray*)list
{
    NSString* sql = @"select id, name, title from category order by position";
    sqlite3_stmt* stmt;
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0);
    if (result != SQLITE_OK) {
        return 0;
    }
    NSMutableArray* array = [[NSMutableArray alloc] init];
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        GalleryCategory* data = [[GalleryCategory alloc] init];
        data.Id = sqlite3_column_int(stmt, 0);
        data.name = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
        data.title = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
        [array addObject:data];
    }
    if (result != SQLITE_OK) {
        sqlite3_finalize(stmt);
        return 0;
    }
    sqlite3_finalize(stmt);
    return array;
}

- (int)create:(NSString*)name title:(NSString*)title
{
    NSString* sql = @"insert into category (id, name, title, position) values (?, ?, ?, ifnull((select max(id)+1 from category),1))";
    sqlite3_stmt* stmt;
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0);
    if (result != SQLITE_OK) {
        return 0;
    }
    sqlite3_bind_text(stmt, 2, [name UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 3, [title UTF8String], -1, nil);
    result = sqlite3_step(stmt);
    if (result != SQLITE_DONE) {
        sqlite3_finalize(stmt);
        return 0;
    }
    sqlite3_int64 lastId = sqlite3_last_insert_rowid(self.db);
    sqlite3_finalize(stmt);
    return (int)lastId;
}

- (void)remove:(NSInteger)Id
{
    NSString* sql = @"delete from category where id = ?";
    sqlite3_stmt* stmt;
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0);
    if (result != SQLITE_OK) {
        return;
    }
    sqlite3_bind_int(stmt, 1, (int)Id);
    result = sqlite3_step(stmt);
    if (result != SQLITE_DONE) {
        sqlite3_finalize(stmt);
        return;
    }
    sqlite3_finalize(stmt);
}

- (bool)update:(NSInteger)Id name:(NSString*)name title:(NSString*)title
{
    NSString* sql = @"update category set name = ?, title = ? where id = ?";
    sqlite3_stmt* stmt;
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0);
    if (result != SQLITE_OK) {
        return false;
    }
    sqlite3_bind_text(stmt, 1, [name UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 2, [title UTF8String], -1, nil);
    sqlite3_bind_int(stmt, 3, (int)Id);
    result = sqlite3_step(stmt);
    if (result != SQLITE_DONE) {
        sqlite3_finalize(stmt);
        return false;
    }
    sqlite3_finalize(stmt);
    return true;
}

- (bool)addChild:(NSInteger)Id picture:(NSInteger)pictureId
{
    NSString* sql = @"insert or replace into category_picture (id, category_id, picture_id, position) values (?, ?, ?, ifnull((select max(id)+1 from category_picture),1))";
    sqlite3_stmt* stmt;
    if (sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0) != SQLITE_OK) {
        return false;
    }
    sqlite3_bind_int(stmt, 2, (int)Id);
    sqlite3_bind_int(stmt, 3, (int)pictureId);
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        sqlite3_finalize(stmt);
        return false;
    }
    sqlite3_finalize(stmt);
    return true;
}

- (bool)order:(NSInteger)Id withId:(NSInteger)otherId
{
    int sourceOrder = -1, targetOrder = -1;
    sqlite3_stmt* stmt;
    {
        NSString* sql = @"select id, position from category where id = ? or id = ?";
        int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0);
        if (result != SQLITE_OK) {
            return false;
        }
        sqlite3_bind_int(stmt, 1, (int)Id);
        sqlite3_bind_int(stmt, 2, (int)otherId);
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
            NSString* sql = @"update category set position = position + 1 where position > ?";
            int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0);
            if (result != SQLITE_OK) {
                return false;
            }
            sqlite3_bind_int(stmt, 1, targetOrder);
            result = sqlite3_step(stmt);
            if (result != SQLITE_DONE) {
                sqlite3_finalize(stmt);
                return false;
            }
            sqlite3_finalize(stmt);
        }
        {
            NSString* sql = @"update category set position = ? where id = ?";
            int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0);
            if (result != SQLITE_OK) {
                return false;
            }
            sqlite3_bind_int(stmt, 1, targetOrder + 1);
            sqlite3_bind_int(stmt, 2, (int)Id);
            result = sqlite3_step(stmt);
            if (result != SQLITE_DONE) {
                sqlite3_finalize(stmt);
                return false;
            }
            sqlite3_finalize(stmt);
        }
    } else {
        {
            NSString* sql = @"update category set position = position + 1 where position >= ?";
            int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0);
            if (result != SQLITE_OK) {
                return false;
            }
            sqlite3_bind_int(stmt, 1, targetOrder);
            result = sqlite3_step(stmt);
            if (result != SQLITE_DONE) {
                sqlite3_finalize(stmt);
                return false;
            }
            sqlite3_finalize(stmt);
        }
        {
            NSString* sql = @"update category set position = ? where id = ?";
            int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &stmt, 0);
            if (result != SQLITE_OK) {
                return false;
            }
            sqlite3_bind_int(stmt, 1, targetOrder);
            sqlite3_bind_int(stmt, 2, (int)Id);
            result = sqlite3_step(stmt);
            if (result != SQLITE_DONE) {
                sqlite3_finalize(stmt);
                return false;
            }
            sqlite3_finalize(stmt);
        }
    }
    return true;
}

@end
