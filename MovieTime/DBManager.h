//
//  DBManager.h
//  MovieTime
//
//  Created by Patricio Beltrán on 12/1/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "PBList.h"

@interface DBManager : NSObject

+ (DBManager *)getSharedInstance;

- (BOOL)saveList:(PBList *)list;

- (PBList *)findListId:(NSNumber *)listId;

- (NSArray *)findAllLists;

@end
