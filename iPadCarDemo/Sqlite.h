//
//  TSSqlite.h
//  TestSqlite
//
//  Created by Matteo Bertozzi on 11/22/08.
//  Copyright 2008 Matteo Bertozzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Sqlite : NSObject
{
	NSInteger busyRetryTimeout;
	NSInteger selectionOption;
	NSString *filePath;
	sqlite3 *_db;
}
@property (nonatomic) NSInteger selectionOption;			// =1 => add Selection to Dictionary Results, for UITableViews
@property (readwrite) NSInteger busyRetryTimeout;
@property (readonly)  NSString *filePath;

+ (NSString *)createUuid;
+ (NSString *)version;

- (id)initWithFile:(NSString *)filePath;

- (BOOL)open:(NSString *)filePath;
- (void)close;

- (NSInteger)errorCode;
- (NSString *)errorMessage;

- (NSMutableArray *)executeQuery:(NSString *)sql, ...;
- (NSMutableArray *)executeQuery:(NSString *)sql arguments:(NSArray *)args;
- (NSMutableArray *)executeQueryCol:(NSString *)col  withSql:(NSString *)sql, ...;

- (BOOL)executeNonQuery:(NSString *)sql, ...;
- (BOOL)executeNonQuery:(NSString *)sql arguments:(NSArray *)args;

- (BOOL)commit;
- (BOOL)rollback;
- (BOOL)beginTransaction;
- (BOOL)beginDeferredTransaction;

@end

