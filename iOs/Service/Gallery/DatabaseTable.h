//
//  DatabaseTable.h
//  iOs
//
//  Created by Bernardo Breder on 15/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DatabaseTable : NSObject

@property (nonatomic, assign) sqlite3* db;

@end
