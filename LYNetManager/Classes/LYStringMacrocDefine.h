//
//  LYStringMacrocDefine.h
//  ChessPlatform
//
//  Created by Mu on 2019/3/31.
//  Copyright © 2019 Chess. All rights reserved.
//

/**
 *  文件描述
 *
 *  这个工具宏封装了大部分字符串常用的便捷方法
 */
#import "LYStringUitil.h"
/**
 *  字符串是否为空
 */
#define LYStringIsNull(string) [LYStringUitil stringIsNull:string]
#define LYStringIsNullZero(string) [LYStringUitil stringIsNullZero:string]

/**
 处理 字符串为 null 的情况
 如果为 null 则返回 @"" ,反之,则返回字符串本身
 */
#define LYStringIsDefault(string) [LYStringUitil stringIsDefault:string]

/**
 处理 字符串为 null 的情况
 如果为 null 则返回 newString ,反之,则返回字符串本身
 */
#define LYStringIsNOTNULL(string,newString) [LYStringUitil stringIsNull:string setDefault:newString]

/**
 处理 字符串为 null 的情况
 如果为 null 则返回 @"0" ,反之如果 等于 0 也返回 0
 */
#define LYStringIsDefaultZero(string) [LYStringUitil stringIsDefaultZero:string]
/**
 *  字符串是否全为空格
 */
#define LYStringIsAllWhiteSpace(string) [LYStringUitil stringIsAllWhiteSpace:string]
/**
 *  字符串转NSInteger
 */
#define LYStringToInt(string) [LYStringUitil stringToInt:string]
/**
 *  字符串转CGFloat
 */
#define LYStringToFloat(string) [LYStringUitil stringToFloat:string]
/**
 *  字符串转double
 */
#define LYStringToDouble(string) [LYStringUitil stringToDouble:string]
/**
 *  字符串转Bool
 */
#define LYStringToBool(string) [LYStringUitil stringToBool:string]
/**
 *  int转字符串
 */
#define LYStringFromInt(int) [LYStringUitil intToString:int]
/**
 *  float转字符串
 */
#define LYStringFromFloat(float) [LYStringUitil floatToString:float]
/**
 *  double转字符串
 */
#define LYStringFromDouble(double) [LYStringUitil doubleToString:double]
/**
 *  bool转字符串
 */
#define LYStringFromBool(bool) [LYStringUitil boolToString:bool]
/**
 *  字符串是否合法邮箱
 */
#define LYStringIsEmail(string) [LYStringUitil stringIsValidateEmailAddress:string]
/**
 *  字符串是否合法手机号码
 */
#define LYStringIsMobilePhone(string) [LYStringUitil stringISValidateMobilePhone:string]
/**
 *  字符串是否合法url
 */
#define LYStringIsUrl(string) [LYStringUitil stringIsValidateUrl:string]
/**
 *  字符串是否合法座机
 */
#define LYStringIsPhone(string) [LYStringUitil stringIsValidatePhone:string]
/**
 *  字符串是否合法邮政编码
 */
#define LYStringIsMailCode(string) [LYStringUitil stringIsValidateMailCode:string]
/**
 *  字符串是否合法身份证号
 */
#define LYStringIsPersonCardNumber(string) [LYStringUitil stringISValidatePersonCardNumber:string]
/**
 *  字符串是否合法车牌号
 */
#define LYStringIsCarNumber(string) [LYStringUitil stringISValidateCarNumber:string]
/**
 *  字符串是否只有中文字符
 */
#define LYStringChineseOnly(string) [LYStringUitil stringIsAllChineseWord:string]
/**
 *  字符串是否只有英文字符
 */
#define LYStringCharNumOnly(string) [LYStringUitil stringJustHasNumberAndCharacter:string]
/**
 *  字符串是否只包含字符，中文，数字
 */
#define LYStringCharNumChineseOnly(string) [LYStringUitil stringChineseNumberCharacterOnly:string]
/**
 *  字符串是否纯数字
 */
#define LYStringNumOnly(string) [LYStringUitil stringJustHasNumber:string]
/**
 字符串是否包含中文
 */
#define LYStringHasChineseChar(string) [LYStringUitil stringHasChineseChar:string]
/**
 字符串是否只包含数字 字母
 */
#define LYStringNumOnlyAndEn(string) [LYStringUitil stringIsOnlyNumberAndEnCode:string]
/**
 *  从文件中读取出字符串
 */
#define LYStringFromFile(path) [LYStringUitil stringFromFile:path]
/**
 *  从归档路径读取出字符串
 */
#define LYStringUnArchieve(path) [LYStringUitil unarchieveFromPath:path]
/**
 *  获取一个当前时间戳字符串
 */
#define LYStringCurrentTimeStamp [LYStringUitil currentTimeStampString]
/**
 *  将字符串转为MD5字符串
 */
#define LYStringToMD5(string) [LYStringUitil MD5:string]
/**
 *  返回去除字符串首的空格的字符串
 */
#define LYStringClearLeadingWhiteSpace(string) [LYStringUitil stringByTrimingLeadingWhiteSpace:string]
/**
 *  返回去除字符串结尾的空格的字符串
 */
#define LYStringClearTailingWhiteSpace(string) [LYStringUitil stringByTrimingTailingWhiteSpace:string]
/**
 *  返回去除字符串中所有的空格的字符串
 */
#define LYStringClearAllWhiteSpace(string) [LYStringUitil stringByTrimingWhiteSpace:string]
/**
 去除掉首尾的空白字符和换行字符
 */
#define LYStringClearAllWhiteSpaceAndBreak(string) [LYStringUitil stringByTrimingWhiteSpaceAndBreak:string]
/**
 *  Url编码对象,通常是字符串,返回编码后的字符串
 */
#define LYStringEncodeString(string) [LYStringUitil urlEncode:string]
/**
 *  Url解码
 */
#define LYStringDecodeString(string) [LYStringUitil urlDecode:string]
/**
 *  Url编码一个字典,键值对用@链接,返回编码后的字符串
 */
#define LYStringEncodeDict(aDict) [LYStringUitil encodeStringFromDict:aDict]
/**
 *  返回字符串范围
 */
#define LYStringRange(string) [LYStringUitil stringRange:string]
/**
 *  根据字典返回json字符串 失败就是nil
 */
#define LYJSONStringFromNSDict(dict) [LYStringUitil jsonStringFromNSDictionary:dict]
/**
 *  根据json字符串返回字典 失败就是nil
 */
#define LYDictionaryFromJSONString(string) [LYStringUitil dictionaryFromJSONString:string]
/**
 *  根据json字符串返回array 失败就是nil
 */
#define LYJSONStringFromNSArray(array) [LYStringUitil jsonStringFromNSArray:array]
/**
 *  根据array返回json字符串 失败就是nil
 */
#define LYArrayFromJSONString(string) [LYStringUitil arrayFromJSONString:string]
/**
 *  Unicode转UTF-8 中文表情 ✌️
 */
#define LYReplaceUnicodeString(string) [LYStringUitil replaceUnicode:string]
/**
 *  是否包含emoji标签
 *  @return YES 包含 NO 不包含
 */
#define LYStringIsContainEmoji(string) [LYStringUitil stringIsContainEmoji:string]

// 数字转中文 10000 -> 1万 支持 万 亿
#define LYStringChinese(string) [LYStringUitil stringNumToChinese:string]

/// 数字转中文 + (NSString *)translationArabicNum:(NSInteger)arabicNum type:(NSString *)second
#define LYNumberStringToChinese(string,number) [LYStringUitil translationArabicNum:string type:number]

// 版本号比较: v1版本字段大于v2版本字段，返回1  v2版本字段大于v1版本字段，返回-1 相等返回0
#define LYCompareVersion(v1,v2) [LYStringUitil compareVersion:v1 to:v2]

//获取制定路径文件的md5值，不能为文件夹，文件路径不能为空
#define LYGetMD5ToPath(filePath) [LYStringUitil getFileMD5WithPath:filePath]
/// 判断字典是否为空
#define LYDictIsNull(dict) [LYStringUitil dictIsNULL:dict]
