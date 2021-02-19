//
//  LYStringUitil.m
//  ChessPlatform
//
//  Created by Mu on 2019/3/31.
//  Copyright © 2019 Chess. All rights reserved.
//

#import "LYStringUitil.h"
#import "LYStringMacrocDefine.h"
#import "LYQuickCacheMacrocDefine.h"
#import <CommonCrypto/CommonDigest.h>

#define FileHashDefaultChunkSizeForReadingData 1024*8

@implementation LYStringUitil

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
+ (BOOL)stringIsNull:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if (string.length == 0 || [string isEqualToString:@""]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)stringIsNullZero:(NSString *)string
{
    if (LYStringIsNull(string))
    {
        return YES;
    }
    if ([string floatValue] == 0) {
        return YES;
    }
    return NO;
}


+ (BOOL)stringIsPureInt:(NSString*)string
{
    if (LYStringIsNull(string))
    {
        return NO;
    }
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (NSString *)stringIsDefault:(NSString *)string
{
    if (LYStringIsNull(string)) {
        return @"";
    }
    return string;
}

+ (NSString *)stringIsNull:(NSString *)string setDefault:(NSString *)newString
{
    if (LYStringIsNull(string)) {
        return newString;
    }
    return string;
}

+ (NSString *)stringIsDefaultZero:(NSString *)string
{
    if (LYStringIsNull(string)) {
        return @"0";
    }
    if ([string floatValue] == 0) {
        return @"0";
    }
    return string;
}

+ (BOOL)stringIsAllWhiteSpace:(NSString *)string
{
    if (LYStringIsNull(string)) {
        return YES;
    }else{
        
        NSString *trimString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (trimString.length > 0) {
            return NO;
        }else{
            return YES;
        }
    }
}

+ (BOOL)stringToBool:(NSString*)sourceString
{
    if (LYStringIsNull(sourceString)) {
        return NO;
    }else{
        return [sourceString boolValue];
    }
}

+ (NSInteger)stringToInt:(NSString*)sourceString
{
    if (LYStringIsNull(sourceString)) {
        return NSIntegerMax;
    }else{
        return [sourceString intValue];
    }
}

+ (CGFloat)stringToFloat:(NSString*)sourceString
{
    if (LYStringIsNull(sourceString)) {
        return CGFLOAT_MAX;
    }else{
        return [sourceString floatValue];
    }
}

+ (double)stringToDouble:(NSString*)sourceString
{
    if (LYStringIsNull(sourceString)) {
        return CGFLOAT_MAX;
    }else{
        return [sourceString doubleValue];
    }
}

+ (NSString *)boolToString:(BOOL)boolValue
{
    return [NSString stringWithFormat:@"%d",boolValue];
}

+ (NSString *)intToString:(NSInteger)intValue
{
    return [NSString stringWithFormat:@"%ld",(long)intValue];
}

+ (NSString *)floatToString:(CGFloat)floatValue
{
    return [NSString stringWithFormat:@"%f",floatValue];
}

+ (NSString *)doubleToString:(double)doubleValue
{
    return [NSString stringWithFormat:@"%lf",doubleValue];
}

+ (NSString*)stringFromFile:(NSString*)path
{
    if (LYStringIsNull(path)) {
        return nil;
    }
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

+ (BOOL)sourceString:(NSString*)sourceString regexMatch:(NSString *)regexString
{
    if (LYStringIsNull(sourceString) || LYStringIsNull(regexString) ) {
        return NO;
    }
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    return [emailTest evaluateWithObject:sourceString];
}

+ (BOOL)stringIsValidateEmailAddress:(NSString *)string
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [LYStringUitil sourceString:string regexMatch:emailRegex];
}

+ (BOOL)stringISValidateMobilePhone:(NSString *)string
{
    //手机号以13，14, 15，16,17,18,19开头，八个 \d 数字字符
//    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSString * phoneRegex = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
    return [LYStringUitil sourceString:string regexMatch:phoneRegex];
}

+ (BOOL)stringISValidateCarNumber:(NSString *)string
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    return [LYStringUitil sourceString:string regexMatch:carRegex];
}

+ (BOOL)stringIsValidateUrl:(NSString *)string
{
    NSString *checkRegex = @"^(([hH][tT]{2}[pP][sS]?)|([fF][tT][pP]))\\:\\/\\/[wW]{3}\\.[\\w-]+\\.\\w{2,4}(\\/.*)?$";
    return [LYStringUitil sourceString:string regexMatch:checkRegex];
}

+ (BOOL)stringIsAllChineseWord:(NSString *)string
{
    NSString *checkRegex = @"^[\u4e00-\u9fa5]+$";
    return [LYStringUitil sourceString:string regexMatch:checkRegex];
}

+ (BOOL)stringISValidatePersonCardNumber:(NSString *)string
{
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    return [LYStringUitil sourceString:string regexMatch:regex2];
}

+ (BOOL)stringIsValidatePhone:(NSString *)string
{
    NSString *phoneRegex = @"^(^0\\d{2}-?\\d{8}$)|(^0\\d{3}-?\\d{7}$)|(^\\(0\\d{2}\\)-?\\d{8}$)|(^\\(0\\d{3}\\)-?\\d{7}$)$";
    return [LYStringUitil sourceString:string regexMatch:phoneRegex];
}

+ (BOOL)stringIsValidateMailCode:(NSString *)string
{
    NSString *mailCodeRegex = @"^\\d{6}$";
    return [LYStringUitil sourceString:string regexMatch:mailCodeRegex];
}

+ (BOOL)stringJustHasNumberAndCharacter:(NSString *)string
{
    NSString *checkRegex = @"[a-z][A-Z][0-9]";
    return [LYStringUitil sourceString:string regexMatch:checkRegex];
}

+ (BOOL)stringIsOnlyNumberAndEnCode:(NSString *)string
{
    NSString *checkRegex = @"^[A-Za-z0-9]+$";
    return [LYStringUitil sourceString:string regexMatch:checkRegex];
}

+ (BOOL)stringChineseNumberCharacterOnly:(NSString *)string
{
    NSString *checkRegex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    return [LYStringUitil sourceString:string regexMatch:checkRegex];
}
+(BOOL)stringIsValidateQQ:(NSString *)string
{
    NSString *checkRegex = @"[1-9][0-9]{4,}";
    return [LYStringUitil sourceString:string regexMatch:checkRegex];
}

+(BOOL)stringHasChineseChar:(NSString *)string
{
    
    BOOL bool_value = NO;
    for (int i=0; i<string.length; i++) {
        NSRange range =NSMakeRange(i, 1);
        NSString * strFromSubStr=[string substringWithRange:range];
        const char * cStringFromstr=[strFromSubStr UTF8String];
        if (strlen(cStringFromstr)==3) {
            //有汉字
            bool_value = YES;
        }
    }
    return bool_value;
}

+(BOOL)stringIsValidateWeChat:(NSString *)string
{
    NSString *checkRegex = @"^[a-zA-Z]{1}[-_a-zA-Z0-9]{5,19}+$";
    return [LYStringUitil sourceString:string regexMatch:checkRegex];
}

+ (BOOL)stringJustHasNumber:(NSString *)string
{
    NSString *checkRegex = @"^[0-9]*$";
    return [LYStringUitil sourceString:string regexMatch:checkRegex];
}

+ (NSString*)currentTimeStampString
{
    NSDate *now = [NSDate date];
    NSTimeInterval timeInterval = [now timeIntervalSinceReferenceDate];
    
    NSString *timeString = [NSString stringWithFormat:@"%lf",timeInterval];
    timeString = [timeString stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    return timeString;
    
}

+ (NSString *)unarchieveFromPath:(NSString *)filePath
{
    return LYUnArchieveObject(filePath);
}

+ (NSString *)MD5:(NSString *)string
{
    const char* aString = [string UTF8String];
    unsigned char result[16];
    CC_MD5(aString, (CC_LONG)strlen(aString), result);
    NSString* hash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
    
    return [hash lowercaseString];
}

+ (NSString *)stringByTrimingLeadingWhiteSpace:(NSString *)string
{
    NSRange range = [string rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
    return [string stringByReplacingCharactersInRange:range withString:@""];
}

+ (NSString *)stringByTrimingTailingWhiteSpace:(NSString *)string
{
    NSRange range = [string rangeOfString:@"\\s*$" options:NSRegularExpressionSearch];
    return [string stringByReplacingCharactersInRange:range withString:@""];
}

+ (NSString *)stringByTrimingWhiteSpace:(NSString *)string
{
    NSString *temp = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

+ (NSString *)stringByTrimingWhiteSpaceAndBreak:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return string;
}

// 转化为UTF8编码
+ (NSString *)urlEncode:(id)object {
    
    if (LYCheckObjectNull(object)) {
        return nil;
    }
    
    NSString *string = (NSString*)object;
    NSString *encodedValue = (__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(nil, (CFStringRef)string, nil, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    return encodedValue;
}

+ (NSString *)urlDecode:(id)object {
    if (LYCheckObjectNull(object)) {
        return nil;
    }
    NSString *string = (NSString*)object;
    NSString *encodedValue = (__bridge NSString*)CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef) string, CFSTR(""));
    return encodedValue;
}

+ (NSString *)encodeStringFromDict:(NSDictionary *)dict
{
    if (LYCheckObjectNull(dict)) {
        return nil;
    }
    
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in dict) {
        @autoreleasepool {
            id value = [dict objectForKey: key];
            NSString *part = [NSString stringWithFormat: @"%@=%@",[LYStringUitil urlEncode:key],[LYStringUitil urlEncode:value]];
            [parts addObject: part];
        }
    }
    return [parts componentsJoinedByString: @"&"];//拼装字符串
}

+ (NSRange)stringRange:(NSString *)string
{
    if (LYStringIsNull(string)) {
        return NSMakeRange(NSNotFound, 0);
    }
    return NSMakeRange(0, string.length);
}

+ (NSString *)jsonStringFromNSDictionary:(NSDictionary *)dict
{
    NSString *res = nil;
    if (dict) {
        NSError *error = nil;
        NSData *data  = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            res = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    return res;
}

+ (NSDictionary *)dictionaryFromJSONString:(NSString *)str
{
    NSDictionary *res = nil;
    if (str) {
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (!error) {
            res = obj;
        }
    }
    return res;
}

+ (NSString *)jsonStringFromNSArray:(NSArray *)array
{
    NSString *res = nil;
    if (array) {
        
        if ( ![[array class] isSubclassOfClass:[NSArray class]] || [array count] == 0) {
            return @"[]";
        }
        
        NSError *error = nil;
        NSData *data  = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            res = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    return res;
}

+ (NSArray *)arrayFromJSONString:(NSString *)str
{
    NSArray *res = nil;
    if (str) {
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        id Obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (!error) {
            res = Obj;
        }
    }
    return res;
}

////Unicode转UTF-8 中文表情 ✌️
+ (NSString*)replaceUnicode:(NSString*)aUnicodeString
{
    NSString *tempStr1 = [aUnicodeString stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData
                                                                    options:NSPropertyListImmutable
                                                                     format:NULL
                                                                      error:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

//是否包含emoji
+ (BOOL)stringIsContainEmoji:(NSString *)string
{
    __block BOOL containsEmoji = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0,
                                                   [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring,
                                         NSRange substringRange,
                                         NSRange enclosingRange,
                                         BOOL *stop)
     {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs &&
             hs <= 0xdbff)
         {
             if (substring.length > 1)
             {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc &&
                     uc <= 0x1f9c0)
                 {
                     containsEmoji = YES;
                 }
             }
         }
         else if (substring.length > 1)
         {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3 ||
                 ls == 0xfe0f ||
                 ls == 0xd83c)
             {
                 containsEmoji = YES;
             }
         }
         else
         {
             // non surrogate
             if (0x2100 <= hs &&
                 hs <= 0x27ff)
             {
                 containsEmoji = YES;
             }
             else if (0x2B05 <= hs &&
                      hs <= 0x2b07)
             {
                 containsEmoji = YES;
             }
             else if (0x2934 <= hs &&
                      hs <= 0x2935)
             {
                 containsEmoji = YES;
             }
             else if (0x3297 <= hs &&
                      hs <= 0x3299)
             {
                 containsEmoji = YES;
             }
             else if (hs == 0xa9 ||
                      hs == 0xae ||
                      hs == 0x303d ||
                      hs == 0x3030 ||
                      hs == 0x2b55 ||
                      hs == 0x2b1c ||
                      hs == 0x2b1b ||
                      hs == 0x2b50)
             {
                 containsEmoji = YES;
             }
         }
         
         if (containsEmoji)
         {
             *stop = YES;
         }
     }];
    
    return containsEmoji;
}

+ (NSString *)stringNumToChinese:(NSString *)string
{
    NSString *unit = @"万"; // 默认单位
    NSDecimalNumber *numberA = [NSDecimalNumber decimalNumberWithString:string];
    NSDecimalNumber *numberB ;
    NSDecimalNumber *calculate = [NSDecimalNumber decimalNumberWithString:@"100000000"]; // 亿
    if ([numberA compare:calculate] != NSOrderedDescending) {
        numberB =  [NSDecimalNumber decimalNumberWithString:@"10000"];
        unit = @"万";
    } else {
        unit = @"亿";
        numberB =  [NSDecimalNumber decimalNumberWithString:@"100000000"];
    }
    
    //NSDecimalNumberBehaviors对象的创建  参数 1.RoundingMode 一个取舍枚举值 2.scale 处理范围 3.raiseOnExactness  精确出现异常是否抛出原因 4.raiseOnOverflow  上溢出是否抛出原因  4.raiseOnUnderflow  下溢出是否抛出原因  5.raiseOnDivideByZero  除以0是否抛出原因。
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    /// 这里不仅包含Multiply还有加 减 乘。
    NSDecimalNumber *numResult = [numberA decimalNumberByDividingBy:numberB withBehavior:roundingBehavior];
    if ([numResult compare:[NSDecimalNumber decimalNumberWithString:@"1"]] == NSOrderedAscending ) {
        // 小于10000 的情况
        unit = @"";
    }
    NSString *strResult = [NSString stringWithFormat:@"%@%@",[numResult stringValue], unit];
    
    return strResult;
}

/**
 *  将阿拉伯数字转换为中文数字
 */
+ (NSString *)translationArabicNum:(NSInteger)arabicNum type:(NSString *)second
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",second,@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}

+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2
{
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }
    
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }
    
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最大的，进行循环比较
    NSInteger bigCount = (v1Array.count > v2Array.count) ? v1Array.count : v2Array.count;
    
    for (int i = 0; i < bigCount; i++) {
        // 字段有值，取值；字段无值，置0。
        NSInteger value1 = (v1Array.count > i) ? [[v1Array objectAtIndex:i] integerValue] : 0;
        NSInteger value2 = (v2Array.count > i) ? [[v2Array objectAtIndex:i] integerValue] : 0;
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }
        
        // 版本相等，继续循环。
    }
    
    // 版本号相等
    return 0;
}

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    if (!fileURL) goto done;
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    // Feed the data to the hash object
    bool hasMoreData = true;
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    // Compute the string result
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
done:
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}

//获取制定路径文件的md5值，不能为文件夹，文件路径不能为空
+ (NSString*)getFileMD5WithPath:(NSString*)path
{
    if (!path) {
        return @"";
    }
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
}

//查找指定路径下文件信息
+ (NSMutableArray*)searchAllFileFromRightDirPath:(NSString *)rightDirPath{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExists = [fileManager fileExistsAtPath:rightDirPath isDirectory:&isDir];
    if (!isExists || !isDir) {
        return nil;
    }
    
    NSMutableArray * subFileNamesArr = [NSMutableArray array];
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:rightDirPath];
    for (NSString *fileName in enumerator){
        if (fileName && [fileName hasPrefix:@"."] == NO && [fileName containsString:@"/"] == NO) {
            /*
             NSFileCreationDate = "2017-02-09 09:04:50 +0000";
             NSFileExtensionHidden = 0;
             NSFileGroupOwnerAccountID = 20;
             NSFileGroupOwnerAccountName = staff;
             NSFileModificationDate = "2017-02-09 09:04:50 +0000";
             NSFileOwnerAccountID = 501;
             NSFilePosixPermissions = 493;
             NSFileReferenceCount = 2;
             NSFileSize = 68;//文件大小
             NSFileSystemFileNumber = 13723856;
             NSFileSystemNumber = 16777218;
             NSFileType = NSFileTypeDirectory;
             canDel = 1;
             title = Documents;*/
            
            NSFileManager * fileManager = [NSFileManager defaultManager];
            //获取文件属性
            NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:[rightDirPath stringByAppendingPathComponent:fileName] error:nil];
            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:fileAttributes];
            [dict setObject:fileName forKey:@"title"];
            [dict setObject:[NSNumber numberWithBool:[[NSFileManager defaultManager] isDeletableFileAtPath:[NSHomeDirectory() stringByAppendingPathComponent:fileName]]] forKey:@"canDel"];
            if ([[dict objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory]) {
                [dict setObject:@"Dir" forKey:@"FileType"];
            }else{
                [dict setObject:[self judgeFileTypeWithPath:[rightDirPath stringByAppendingPathComponent:fileName]] forKey:@"FileType"];
            }
            [subFileNamesArr addObject:dict];
        }
    }
    return subFileNamesArr;
}

//获取文件类型
+ (NSString *)judgeFileTypeWithPath:(NSString *)filePath{
    if ([filePath hasSuffix:@".note"]) {
        return  @"未知文件类型";
    }
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    if (data.length<2) {
        return  @"未知文件类型";
    }
    int char1 = 0 ,char2 =0 ;
    [data getBytes:&char1 range:NSMakeRange(0, 1)];
    [data getBytes:&char2 range:NSMakeRange(1, 1)];
    data = nil;
    NSString *numStr = [NSString stringWithFormat:@"%i%i",char1,char2];
    
    if ([numStr isEqualToString:@"255216"]) {
        return @"image/jpeg";
    }else if ([numStr isEqualToString:@"7173"]) {
        return @"image/gif";
    }else if ([numStr isEqualToString:@"6677"]) {
        return @"image/bmp";
    }else if ([numStr isEqualToString:@"13780"]) {
        return @"image/png";
    }else if ([numStr isEqualToString:@"7790"]) {
        return @"exe";
    }else if ([numStr isEqualToString:@"8297"]) {
        return @"rar";
    }else if ([numStr isEqualToString:@"8075"]) {
        return @"zip";
    }else if ([numStr isEqualToString:@"55122"]) {
        return @"7z";
    }else if ([numStr isEqualToString:@"6063"]) {
        return @"xml";
    }else if ([numStr isEqualToString:@"6033"]) {
        return @"html";
    }else if ([numStr isEqualToString:@"119105"]) {
        return @"js";
    }else if ([numStr isEqualToString:@"102100"]) {
        return @"txt";
    }else if ([numStr isEqualToString:@"255254"]) {
        return @"sql";
    }else{
        return @"未知文件类型";
    }
}

+ (BOOL)dictIsNULL:(id)dict
{
    if (!dict || [dict isKindOfClass:[NSNull class]] ||
        [dict isEqual:[NSNull null]] ||
        ![dict isKindOfClass:NSDictionary.class]
        ) {
         return YES;
    }
    
    return NO;
}

#pragma clang diagnostic pop
@end

