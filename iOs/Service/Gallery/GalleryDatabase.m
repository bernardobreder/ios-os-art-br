//
//  GalleryDatabase.m
//  iOs
//
//  Created by Bernardo Breder on 15/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "GalleryDatabase.h"
#import "sqlite3.h"

@implementation GalleryDatabase
{
    sqlite3* _db;
}

@synthesize category;
@synthesize picture;

- (NSString*)pathOfDatabase:(NSString*)name
{
    NSString* db = [NSString stringWithFormat:@"%@.sqlite3", name];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docDir = [paths objectAtIndex:0];
    NSString* path = [docDir stringByAppendingPathComponent:db];
    NSLog(@"Load database at: %@", path);
    return path;
}

- (id)init
{
    if (!(self = [super init])) return nil;
    [self connect];
    char* error;
//    [self reset];
    sqlite3_exec(_db, [@"begin transaction" UTF8String], 0, 0, &error);
    //
    sqlite3_exec(_db, [@"create table if not exists category (id integer not null primary key autoincrement, name text not null unique, title text not null, position integer not null)" UTF8String], 0, 0, &error);
    //
    sqlite3_exec(_db, [@"create table if not exists picture (id integer not null primary key autoincrement, title text not null, describer text not null default '', value number not null default 0, width number not null default 0, height number not null default 0, small_image blob, large_image blob, buying boolean not null default false)" UTF8String], 0, 0, &error);
    //
    sqlite3_exec(_db, [@"create table if not exists category_picture (id integer not null primary key autoincrement, category_id integer not null, picture_id integer not null, position integer not null, unique(category_id, picture_id))" UTF8String], 0, 0, &error);
	//
	sqlite3_exec(_db, [@"create table if not exists buy (id integer not null primary key autoincrement, picture_id integer not null unique)" UTF8String], 0, 0, &error);
	//
    sqlite3_exec(_db, [@"commit" UTF8String], 0, 0, &error);
    if (error) {
        return 0;
    }
    {
        category = [[GalleryCategoryTable alloc] init];
        category.db = _db;
    }
    {
        picture = [[GalleryPictureTable alloc] init];
        picture.db = _db;
    }
    return self;
}

- (void)connect
{
    if (!_db) {
        NSString* path = [self pathOfDatabase: @"gallery"];
        sqlite3_open([path UTF8String], &_db);
        category.db = _db;
        picture.db = _db;
    }
}

- (void)reset
{
    char* error;
    sqlite3_exec(_db, [@"begin transaction" UTF8String], 0, 0, &error);
    sqlite3_exec(_db, [@"drop table category" UTF8String], 0, 0, 0);
    sqlite3_exec(_db, [@"drop table picture" UTF8String], 0, 0, 0);
    sqlite3_exec(_db, [@"drop table category_picture" UTF8String], 0, 0, 0);
    sqlite3_exec(_db, [@"commit" UTF8String], 0, 0, &error);
}

- (void)close
{
    if (_db) {
        sqlite3_close(_db);
        _db = nil;
    }
}

- (void)begin
{
    sqlite3_exec(_db, [@"begin transaction" UTF8String], 0, 0, 0);
}

- (bool)commit
{
    char* error;
    sqlite3_exec(_db, [@"commit" UTF8String], 0, 0, &error);
    if (error) {
        sqlite3_free(error);
        return 0;
    } else {
        return 1;
    }
    
    return error;
}

- (void)rollback
{
    sqlite3_exec(_db, [@"rollback" UTF8String], 0, 0, 0);
}

@end
