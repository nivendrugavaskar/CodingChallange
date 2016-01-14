//
//  dbsql.h
//  DbConnect
//
//  Created by Subhadeep Chakraborty on 27/08/15.
//  Copyright (c) 2015 limtexit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface dbsql : NSObject
{
    NSString *dbPath;
}
+(dbsql*)getSharedInstance;
-(BOOL)createDB;
-(BOOL)saveData:(NSString*)name Email:(NSString*)email Password:(NSString*)password Phone_no:(NSString*)phone;
-(NSMutableArray*)findByUserName:(NSString*)userName andPassword:(NSString*)password;
@end
