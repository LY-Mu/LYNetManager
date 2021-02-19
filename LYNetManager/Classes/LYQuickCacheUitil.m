//
//  LYQuickCacheUitil.m
//  ChessPlatform
//
//  Created by Mu on 2019/3/26.
//  Copyright © 2019 Chess. All rights reserved.
//

#import "LYQuickCacheUitil.h"
#import "LYQuickCacheMacrocDefine.h"
#import "LYDispatchMacrocDefine.h"
#import <YYCache/YYCache.h>

static NSString * const kLYQuickCache = @"kLYQuickCache";

@implementation LYQuickCacheUitil

+ (BOOL)isNullObject:(id)anObject
{
    if (!anObject || [anObject isKindOfClass:[NSNull class]]) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)checkValue:(id)value key:(id)key
{
    if(LYCheckObjectNull(value)||LYCheckObjectNull(key)){
        return YES;
    }else{
        return NO;
    }
}

+ (NSUserDefaults *)standDefault
{
    return [NSUserDefaults standardUserDefaults];
}

+ (void)userDefaultCache:(id<NSCoding>)value key:(id)key
{
    if (LYCheckKeyValueHasNull(key, value)) {
        return;
    }
    [[LYQuickCacheUitil standDefault] setObject:value forKey:key];
    [[LYQuickCacheUitil standDefault] synchronize];
}

+ (void)userDefaultRemove:(id)key
{
    if (LYCheckObjectNull(key)) {
        return;
    }
    [[LYQuickCacheUitil standDefault]removeObjectForKey:key];
}

+ (id)userDefaultGetValue:(id)key
{
    if (LYCheckObjectNull(key)) {
        return nil;
    }
    return [[LYQuickCacheUitil standDefault]objectForKey:key];
}

+ (BOOL)userDefaultEmptyValue:(id)key
{
    return [LYQuickCacheUitil userDefaultGetValue:key] == nil;
}

+ (NSCache *)shareCache
{
    static NSCache *_LYNSCacheInstance = nil;
    static dispatch_once_t onceToken;
    
    LYDispatchOnce(onceToken, ^{
        
        if (!_LYNSCacheInstance) {
            _LYNSCacheInstance = [[NSCache alloc]init];
        }
        
    });
    
    return _LYNSCacheInstance;
}

+ (void)systemMemoryCacheSet:(id<NSCoding>)value key:(id)key
{
    if (LYCheckKeyValueHasNull(value, key)) {
        return;
    }
    [[LYQuickCacheUitil shareCache]setObject:value forKey:key];
}

+ (void)systemMemoryCacheRemove:(id)key
{
    if (LYCheckObjectNull(key)) {
        return;
    }
    [[LYQuickCacheUitil shareCache]removeObjectForKey:key];
}

+ (id)systemMemoryCacheGetValue:(id)key
{
    if (LYCheckObjectNull(key)) {
        return nil;
    }
    return [[LYQuickCacheUitil shareCache]objectForKey:key];
}

+ (BOOL)systemMemoryCacheEmptyValue:(id)key
{
    if (LYCheckObjectNull(key)) {
        return NO;
    }
    return [LYQuickCacheUitil systemMemoryCacheGetValue:key] == nil;
}

+ (NSFileManager *)fileManager
{
    return [NSFileManager defaultManager];
}

+ (BOOL)fileExist:(NSString*)path
{
    if (LYStringIsNull(path)) {
        return NO;
    }
    return [[LYQuickCacheUitil fileManager] fileExistsAtPath:path];
}

+ (BOOL)directoryExist:(NSString*)dirPath
{
    if (LYStringIsNull(dirPath)) {
        return NO;
    }
    BOOL isDir = YES;
    
    return [[LYQuickCacheUitil fileManager]fileExistsAtPath:dirPath isDirectory:&isDir];
}

+ (BOOL)createDirectory:(NSString*)dirPath
{
    if (LYCheckObjectNull(dirPath)) {
        return NO;
    }
    if (LYFileDirectoryIsExist(dirPath)) {
        return YES;
    }
    return [[LYQuickCacheUitil fileManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (BOOL)createFile:(NSString*)dirPath withFileName:(NSString *)fileName
{
    if ([self createDirectory:dirPath]) {
        NSString *filePath = [dirPath stringByAppendingPathComponent:fileName];
        return [[LYQuickCacheUitil fileManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    return NO;
}

+ (BOOL)writeFileData:(NSData*)data toPath:(NSString *)path
{
    if (LYCheckKeyValueHasNull(data, path)) {
        return NO;
    }
    
    return [data writeToFile:path atomically:YES];
}

+ (NSData *)readFromFile:(NSString *)path
{
    if (LYCheckObjectNull(path)) {
        return nil;
    }
    
    return [NSData dataWithContentsOfFile:path];
}

+ (BOOL)deleteFileAtPath:(NSString *)filePath
{
    if (LYStringIsNull(filePath)) {
        return NO;
    }
    return [LYFileManager removeItemAtPath:filePath error:nil];
}

+ (BOOL)deleteDirectoryAtPath:(NSString *)dirPath
{
    if (LYStringIsNull(dirPath)) {
        return NO;
    }
    return [LYFileManager removeItemAtPath:dirPath error:nil];
}

+ (BOOL)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath isRemoveOld:(BOOL)isRemove
{
    if (LYStringIsNull(fromPath) || LYStringIsNull(toPath)) {
        return NO;
    }
    if (!LYFileIsExist(fromPath)) {
        return NO;
    }
    
    BOOL copyResult = [LYFileManager copyItemAtPath:fromPath toPath:toPath error:nil];
    if (copyResult) {
        
        if (isRemove) {
            return [LYFileManager removeItemAtPath:fromPath error:nil];
        }
        return YES;
        
    }else{
        return NO;
    }
}

+ (BOOL)archieveObject:(id<NSCoding>)anObject toFilePath:(NSString *)toPath
{
    if (LYCheckObjectNull(anObject) || LYStringIsNull(toPath)) {
        return NO;
    }
    NSData *archieveData = [NSKeyedArchiver archivedDataWithRootObject:anObject];
    if (archieveData) {
        
        return LYFileWrite(archieveData, toPath);
        
    }else{
        return NO;
    }
}

+ (id)unarchieveFromPath:(NSString *)filePath
{
    if (LYStringIsNull(filePath)) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

+ (NSString *)documentDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)documentDirectoryPath:(NSString *)file
{
    if (LYStringIsNull(file)) {
        return nil;
    }
    return [[LYQuickCacheUitil documentDirectory]stringByAppendingPathComponent:file];
}

+ (NSString *)cacheDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)cacheDirectoryPath:(NSString *)file
{
    if (LYStringIsNull(file)) {
        return nil;
    }
    return [[LYQuickCacheUitil cacheDirectory]stringByAppendingPathComponent:file];
}

+ (BOOL)cacheDirectorySave:(id<NSCoding>)anObject withFileName:(NSString *)file
{
    if (LYCheckObjectNull(anObject) || LYStringIsNull(file)) {
        return NO;
    }
    
    return LYArchieveObject(anObject, [LYQuickCacheUitil cacheDirectoryPath:file]);
}

+ (BOOL)cacheDirectoryDelete:(NSString *)file
{
    if (LYStringIsNull(file)) {
        return NO;
    }
    return LYFileDeleteFile([LYQuickCacheUitil cacheDirectoryPath:file]);
}

+ (NSURL *)creatFileToDocument:(NSString *)fileName
{
    NSURL *fileURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    return [fileURL URLByAppendingPathComponent:fileName];
}


+ (BOOL)documentDirectorySave:(id<NSCoding>)anObject withFileName:(NSString *)file
{
    if (LYCheckObjectNull(anObject) || LYStringIsNull(file)) {
        return NO;
    }
    
    return LYArchieveObject(anObject, [LYQuickCacheUitil documentDirectoryPath:file]);
}

+ (BOOL)documentDirectoryDelete:(NSString *)file
{
    if (LYStringIsNull(file)) {
        return NO;
    }
    return LYFileDeleteFile([LYQuickCacheUitil documentDirectoryPath:file]);
}

+ (BOOL)YYCahe_setObject:(id)object forKey:(NSString *)key
{
    YYCache *yyCache=[YYCache cacheWithName:kLYQuickCache];
    /// 根据key写入缓存value
    [yyCache setObject:object forKey:key];
    
    return YES;
}

+ (id)YYCahe_objectForKey:(NSString *)key
{
    YYCache *yyCache=[YYCache cacheWithName:kLYQuickCache];
    
    id value = [yyCache objectForKey:key];
    
    return value;
}

+ (void)YYCahe_removeObjectForKey:(NSString *)key
{
    YYCache *yyCache=[YYCache cacheWithName:kLYQuickCache];
    [yyCache removeObjectForKey:key];
}


@end
