//
//  LYQuickCacheMacrocDefine.h
//  ChessPlatform
//
//  Created by Mu on 2019/3/26.
//  Copyright © 2019 Chess. All rights reserved.
//

/**
 *  文件描述
 *
 *  这个工具类宏定义封装了对
 *  NSUserDefault,NSCache,NSFileManager
 *  NSKeyedArchieve,NSDocumentDirectory,NSCacheDirectory的便捷操作
 */
#import "LYQuickCacheUitil.h"

/* 写宏定义的时候，前面变量参数的名字，多参数的时候不能方法名和后面调用方法的参数名字一样 */

/**
 *  检查一个valueObj,keyObj对象是否有一个是空的
 */
#define LYCheckKeyValueHasNull(keyObj,valueObj) [LYQuickCacheUitil checkValue:valueObj key:keyObj]
/**
 *  检查一个对象是否为空
 */
#define LYCheckObjectNull(object) [LYQuickCacheUitil isNullObject:object]
/**
 *  NSUserDefault 保存键值对 keyObj,valueObj
 */
#define LYUDFCache(keyObj,valueObj) [LYQuickCacheUitil userDefaultCache:valueObj key:keyObj]
/**
 *  NSUserDefault 删除键keyObj对应的值
 */
#define LYUDFRemove(keyObj) [LYQuickCacheUitil userDefaultRemove:keyObj]
/**
 *  NSUserDefault 获取键keyObj对应的值
 */
#define LYUDFGetValue(keyObj) [LYQuickCacheUitil userDefaultGetValue:keyObj]
/**
 *  NSUserDefault 判断键keyObject对应的值是否为空
 */
#define LYUDFEmptyValue(keyObj) [LYQuickCacheUitil userDefaultEmptyValue:keyObj]
/**
 *  NSCache 存储键值对 keyObj,valueObj
 */
#define LYNSCacheSet(keyObj,valueObj) [LYQuickCacheUitil systemMemoryCacheSet:valueObj key:keyObj]
/**
 *  NSCache 删除键keyObj对应的值
 */
#define LYNSCacheRemove(keyObj) [LYQuickCacheUitil systemMemoryCacheRemove:keyObj]
/**
 *  NSCache 获取键keyObj对应的值
 */
#define LYNSCacheGetValue(keyObj) [LYQuickCacheUitil systemMemoryCacheGetValue:keyObj]
/**
 *  NSCache 判断键keyObject对应的值是否为空
 */
#define LYNSCacheEmptyValue(keyObj) [LYQuickCacheUitil systemMemoryCacheEmptyValue:keyObj]
/**
 *  获取系统默认文件管理
 */
#define LYFileManager [LYQuickCacheUitil fileManager]
/**
 *  指定路径pathObj是否存在文件
 */
#define LYFileIsExist(pathObj) [LYQuickCacheUitil fileExist:pathObj]
/**
 *  指定路径pathObj是否存在目录
 */
#define LYFileDirectoryIsExist(pathObj) [LYQuickCacheUitil directoryExist:pathObj]
/**
 *  读取某个路径的二进制数据，返回 NSData
 */
#define LYFileRead(pathObj) [LYQuickCacheUitil readFromFile:pathObj]
/**
 *  将二进制数据写入文件 dataObj:NSData pathObj:NSString
 */
#define LYFileWrite(dataObj,pathObj) [LYQuickCacheUitil writeFileData:dataObj toPath:pathObj]
/**
 *  在指定路径创建目录，返回BOOL结果
 */
#define LYFileDirectoryCreate(pathObj) [LYQuickCacheUitil createDirectory:pathObj]
/**
 在 指定目录创建指定文件
 */
#define LYFileCreateFile(dirPath, fileName) [LYQuickCacheUitil createFile:dirPath withFileName:fileName]
/**
 在 NSDocumentDirectory 创建指定文件
 */
#define LYFileDirectoryToDocument(fileName) [LYQuickCacheUitil creatFileToDocument:fileName]
/**
 *  删除指定路径文件
 */
#define LYFileDeleteFile(path) [LYQuickCacheUitil deleteFileAtPath:path]
/**
 *  删除指定目录
 */
#define LYFileDeleteDirectory(path) [LYQuickCacheUitil deleteDirectoryAtPath:path]
/**
 *  从fromFilePath复制文件到toFilePath,shouldRemove标示是否删除复制源文件
 */
#define LYFileCopyFileIsRemove(fromFilePath,toFilePath,shouldRemove) [LYQuickCacheUitil copyFileFromPath:fromFilePath toPath:toFilePath isRemoveOld:shouldRemove]
/**
 *  将某个对象归档到指定路径
 */
#define LYArchieveObject(object,filePath) [LYQuickCacheUitil archieveObject:object toFilePath:filePath]
/**
 *  从指定路径读取被归档过的对象
 */
#define LYUnArchieveObject(fromFilePath) [LYQuickCacheUitil unarchieveFromPath:fromFilePath]
/**
 *  获取NSDocumentDirectory目录
 */
#define LYAppDocumentDirectory [LYQuickCacheUitil documentDirectory]
/**
 *  获取NSCacheDirectory目录
 */
#define LYAppCacheDirectory [LYQuickCacheUitil cacheDirectory]
/**
 *  返回文件名为fileName在NSDocumentDirectory中的路径
 */
#define LYAppDoucmentPath(fileName) [LYQuickCacheUitil documentDirectoryPath:fileName]
/**
 *  返回文件名为fileName在NSCacheDirectory中的路径
 */
#define LYAppCachePath(fileName) [LYQuickCacheUitil cacheDirectoryPath:fileName]
/**
 *  将object对象用fileName名字保存到NSDocumentDirectory目录下
 */
#define LYAppDocumentSave(object,fileName) [LYQuickCacheUitil documentDirectorySave:object withFileName:fileName]
/**
 *  将object对象用fileName名字保存到NSCacheDirectory目录下
 */
#define LYAppCacheSave(object,fileName) [LYQuickCacheUitil cacheDirectorySave:object withFileName:fileName]
/**
 *  删除NSDocumentDirectory目录下名为fileName的文件
 */
#define LYAppDocumentDelete(fileName)  [LYQuickCacheUitil documentDirectoryDelete:fileName]
/**
 *  删除NSCacheDirectory目录下名为fileName的文件
 */
#define LYAppCacheDelete(fileName) [LYQuickCacheUitil cacheDirectoryDelete:fileName]
/**
 *  YYCahe 保存键值对 keyObj,valueObj
 */
#define LYYYCache(keyObj,valueObj) [LYQuickCacheUitil YYCahe_setObject:valueObj forKey:keyObj]
/**
 *  YYCahe 删除键keyObj对应的值
 */
#define LYYYCahceRemove(keyObj) [LYQuickCacheUitil YYCahe_removeObjectForKey:keyObj]
/**
 *  YYCahe 获取键keyObj对应的值
 */
#define LYYYCaheGetValue(keyObj) [LYQuickCacheUitil YYCahe_objectForKey:keyObj]
