//
//  LYQuickCacheUitil.h
//  ChessPlatform
//
//  Created by Mu on 2019/3/26.
//  Copyright © 2019 Chess. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYQuickCacheUitil : NSObject

+ (BOOL)isNullObject:(id)anObject;

+ (BOOL)checkValue:(id)value key:(id)key;

+ (void)userDefaultCache:(id<NSCoding>)value key:(id)key;

+ (void)userDefaultRemove:(id)key;

+ (id)userDefaultGetValue:(id)key;

+ (BOOL)userDefaultEmptyValue:(id)key;

+ (void)systemMemoryCacheSet:(id<NSCoding>)value key:(id)key;

+ (void)systemMemoryCacheRemove:(id)key;

+ (id)systemMemoryCacheGetValue:(id)key;

+ (BOOL)writeFileData:(NSData*)data toPath:(NSString *)path;

+ (BOOL)systemMemoryCacheEmptyValue:(id)key;

+ (NSFileManager *)fileManager;

+ (BOOL)fileExist:(NSString*)path;

+ (BOOL)directoryExist:(NSString*)dirPath;

+ (BOOL)createDirectory:(NSString*)dirPath;

+ (BOOL)createFile:(NSString*)dirPath withFileName:(NSString *)fileName;

+ (NSURL *)creatFileToDocument:(NSString *)fileName;

+ (NSData *)readFromFile:(NSString *)path;

+ (BOOL)deleteFileAtPath:(NSString *)filePath;

+ (BOOL)deleteDirectoryAtPath:(NSString *)dirPath;

+ (BOOL)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath isRemoveOld:(BOOL)isRemove;

+ (BOOL)archieveObject:(id<NSCoding>)anObject toFilePath:(NSString *)toPath;

+ (id)unarchieveFromPath:(NSString *)filePath;

+ (NSString *)documentDirectory;

+ (NSString *)cacheDirectory;

+ (NSString *)documentDirectoryPath:(NSString *)file;

+ (NSString *)cacheDirectoryPath:(NSString *)file;

+ (BOOL)cacheDirectorySave:(id<NSCoding>)anObject withFileName:(NSString *)file;

+ (BOOL)cacheDirectoryDelete:(NSString *)file;

+ (BOOL)documentDirectorySave:(id<NSCoding>)anObject withFileName:(NSString *)file;

+ (BOOL)documentDirectoryDelete:(NSString *)file;

+ (BOOL)YYCahe_setObject:(id)object forKey:(NSString *)key;
+ (id)YYCahe_objectForKey:(NSString *)key;
+ (void)YYCahe_removeObjectForKey:(NSString *)key;

@end

