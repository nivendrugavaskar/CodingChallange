//
//  dbsql.m
//  DbConnect
//
//  Created by Subhadeep Chakraborty on 27/08/15.
//  Copyright (c) 2015 limtexit. All rights reserved.
//

#import "dbsql.h"
#import <sqlite3.h>
static dbsql *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;
@implementation dbsql
+(dbsql*)getSharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}
-(BOOL)createDB
{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];//store the 1st position of the array,where the path of this directories exist...
    // Build the path to the database file...........
    dbPath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent:@"customer.db"]];//appending "student.db" file in the path ie in database directories....
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: dbPath ] == NO)
    {
        const char *dbpath = [dbPath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt ="create table if not exists LOGIN (name text, email text primary key, password text, phone text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else
        {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

-(BOOL)saveData:(NSString*)name Email:(NSString*)email Password:(NSString*)password Phone_no:(NSString*)phone;

{
    // Nslog(@"error....");
    NSLog(@"error......");
    const char *dbpath = [dbPath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO LOGIN VALUES (\"%@\", \"%@\", \"%@\", \"%@\")",
    name, email, password, phone];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Login Successful...");
            return YES;
        }
        else
        {
            NSLog(@"Login Attempt Failed...");
            //return NO;
        }
        sqlite3_reset(statement);
        // sqlite3_finalize(statement);
        //sqlite3_close(database);
    }
   
    return NO;
}

-(NSMutableArray*)findByUserName:(NSString*)userName andPassword:(NSString*)password
{
    
    const char *dbpath = [dbPath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from LOGIN where email=\"%@\" and password=\"%@\"",userName,password];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *name = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:name];
                NSString *phone = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 3)];
                [resultArray addObject:phone];

                
                return resultArray;
            }
            else
            {
                NSLog(@"Not found");
               
            }
            sqlite3_reset(statement);
        }
    }
    return nil;
}
@end
