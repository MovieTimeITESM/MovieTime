//
//  DBManager.m
//  MovieTime
//
//  Created by Patricio Beltrán on 12/1/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "DBManager.h"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@interface DBManager()
@property (nonatomic, strong) NSString *databasePath;
@end

@implementation DBManager

+ (DBManager*)getSharedInstance {
    if (!sharedInstance) {
        sharedInstance = [[self alloc] init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

- (BOOL)createDB {
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    self.databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent: @"movieTime.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath:self.databasePath] == NO) {
        const char *dbpath = [self.databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt = "create table if not exists lists (listId integer primary key, name text, avatar text, likes integer, owner text, likedByUser boolean)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

- (BOOL)saveList:(PBList *)list {
    const char *dbpath = [self.databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into lists (listId, name, avatar, likes, owner, likedByUser) values (\"%@\",\"%@\", \"%@\", \"%@\",\"%@\",\"%d\")", list.listId, list.name, list.avatar, list.likes, list.owner, list.likedByUser];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        sqlite3_reset(statement);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            return YES;
        }
        else {
            return NO;
        }
    }
    return NO;
}

- (PBList *)findListId:(NSNumber *)listId {
    const char *dbpath = [self.databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select name, avatar, likes, owner, likedByUser from lists where listId=\"%@\"", listId];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:name];
                NSString *department = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:department];
                NSString *year = [[NSString alloc]initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                [resultArray addObject:year];
                sqlite3_reset(statement);
                
                return [[PBList alloc] initWithId:@0 name:@"" avatar:@"" likes:@0 owner:@"" likedByUser:YES];
            }
            else {
                NSLog(@"Not found");
                sqlite3_reset(statement);
                return nil;
            }
        }
    }
    return nil;
}

- (NSArray *)findAllLists {
    const char *dbpath = [self.databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL =  @"select * from lists";
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while(sqlite3_step(statement) == SQLITE_ROW) {
                NSNumber *listId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                NSString *name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *avatar = [[NSString alloc]initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSNumber *likes = [NSNumber numberWithInt:sqlite3_column_int(statement, 3)];
                NSString *owner = [[NSString alloc]initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                BOOL likedByUser = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] isEqualToString:@"1"];
                PBList *list = [[PBList alloc] initWithId:listId name:name avatar:avatar likes:likes owner:owner likedByUser:likedByUser];
                list.type = PBListTypePrivate;
                [resultArray addObject:list];
            }
            sqlite3_reset(statement);
            return resultArray;
        }
        else {
            NSLog(@"Not found");
            sqlite3_reset(statement);
            return nil;
        }
    }
    return nil;
}

@end
