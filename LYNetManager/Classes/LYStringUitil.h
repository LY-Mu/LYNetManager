//
//  LYStringUitil.h
//  ChessPlatform
//
//  Created by Mu on 2019/3/31.
//  Copyright © 2019 Chess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface LYStringUitil : NSObject

+ (BOOL)stringIsNull:(NSString *)string;
/// 数字字符串 是否是 0
+ (BOOL)stringIsNullZero:(NSString *)string;
/***判断字符串是否是整数***/
+ (BOOL)stringIsPureInt:(NSString*)string;

+ (NSString *)stringIsDefault:(NSString *)string;
/***如果为空默认为0***/
+ (NSString *)stringIsDefaultZero:(NSString *)string;
/// 判断是否为空值, 为空 返回 自定义的值
+ (NSString *)stringIsNull:(NSString *)string setDefault:(NSString *)newString;

+ (BOOL)stringIsAllWhiteSpace:(NSString *)string;

+ (BOOL)stringToBool:(NSString*)sourceString;

+ (NSInteger)stringToInt:(NSString*)sourceString;

+ (CGFloat)stringToFloat:(NSString*)sourceString;

+ (double)stringToDouble:(NSString*)sourceString;

+ (NSString *)boolToString:(BOOL)boolValue;

+ (NSString *)intToString:(NSInteger)intValue;

+ (NSString *)floatToString:(CGFloat)floatValue;

+ (NSString *)doubleToString:(double)doubleValue;

+ (BOOL)stringIsValidateEmailAddress:(NSString *)string;

+ (BOOL)stringISValidateMobilePhone:(NSString *)string;

+ (BOOL)stringIsValidatePhone:(NSString *)string;

+ (BOOL)stringIsValidateMailCode:(NSString *)string;

+ (BOOL)stringIsAllChineseWord:(NSString *)string;

+ (BOOL)stringISValidateCarNumber:(NSString *)string;

+ (BOOL)stringIsValidateUrl:(NSString *)string;

+ (BOOL)stringISValidatePersonCardNumber:(NSString *)string;

+ (BOOL)stringJustHasNumberAndCharacter:(NSString *)string;

+ (BOOL)stringJustHasNumber:(NSString *)string;

+ (BOOL)stringHasChineseChar:(NSString *)string;

+ (BOOL)stringIsOnlyNumberAndEnCode:(NSString *)string;

+ (BOOL)stringChineseNumberCharacterOnly:(NSString *)string;

+ (BOOL)stringIsValidateQQ:(NSString *)string;

+ (BOOL)stringIsValidateWeChat:(NSString *)string;

+ (NSString*)stringFromFile:(NSString*)path;

+ (NSString*)currentTimeStampString;

+ (NSString *)unarchieveFromPath:(NSString *)filePath;

+ (NSString *)MD5:(NSString *)string;

+ (NSString *)stringByTrimingLeadingWhiteSpace:(NSString *)string;

+ (NSString *)stringByTrimingTailingWhiteSpace:(NSString *)string;

+ (NSString *)stringByTrimingWhiteSpace:(NSString *)string;

+ (NSString *)stringByTrimingWhiteSpaceAndBreak:(NSString *)string;

+ (NSString *)urlEncode:(id)object;

+ (NSString *)urlDecode:(id)object;

+ (NSString *)encodeStringFromDict:(NSDictionary *)dict;

+ (NSRange)stringRange:(NSString *)string;

+ (NSString *)jsonStringFromNSDictionary:(NSDictionary *)dict;

+ (NSDictionary *)dictionaryFromJSONString:(NSString *)str;

+ (NSString *)jsonStringFromNSArray:(NSArray *)array;

+ (NSArray *)arrayFromJSONString:(NSString *)str;

////Unicode转UTF-8 中文表情 ✌️
+ (NSString *)replaceUnicode:(NSString*)aUnicodeString;

//是否包含emoji
+ (BOOL)stringIsContainEmoji:(NSString *)string;

+ (NSString *)stringNumToChinese:(NSString *)string;

+ (NSString *)translationArabicNum:(NSInteger)arabicNum type:(NSString *)second;
/**
 比较两个版本号的大小
 
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2;

//获取制定路径文件的md5值，不能为文件夹，文件路径不能为空
+ (NSString*)getFileMD5WithPath:(NSString*)path;

/// 字典是否为 nil
+ (BOOL)dictIsNULL:(id)dict;
@end
