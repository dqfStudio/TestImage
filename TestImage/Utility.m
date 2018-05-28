//
//  Utility.m
//  MobileMusic4
//
//  Created by 崔 晓乾 on 12-2-1.
//  Copyright (c) 2012年 云泓道元. All rights reserved.
//

#import "Utility.h"
#import <CommonCrypto/CommonDigest.h>
//#import "RCClient.h"
//#import "filter.h"
//#include <math.h>

#define DEFAULT_VOID_COLOR [UIColor whiteColor]


@implementation Utility

+ (NSString *) getDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
//    DLog(@"%@", strDate);
    return strDate;
}

+ (NSString *)getDocumentsDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

+ (NSString *) getCutMusicDir
{
    NSString* path = [[Utility getDocumentsDir] stringByAppendingString:@"/cutMusicDir/"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil] )
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSLog(@"path = %@", path);
    return path;
}

+ (NSString*)appendUaVersionForUrl:(NSString*)paramUrl
{
    //    return [NSString stringWithFormat:@"%@%@&ua=%@&version=%@",
    //                                        [NSString stringWithFormat:@"%@%@", [[MMClient sharedInstance] serverIP], REQUEST_VERSION],
    //                                        paramUrl,
    //                                        [[MMClient sharedInstance] getUA],
    //                                        [[MMClient sharedInstance] getVersion]];
    return nil;
}

+ (NSString*)currentTimeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:[NSDate date]];
}

+ (NSDate*)dateFromString:(NSString*)dateString
{
    
    static NSDateFormatter *dateFormatter = nil;
    if (nil == dateFormatter) {
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setTimeZone:gmt];
        //[dateFormatter setLocale:[NSLocale systemLocale]];
    }
    
    
    NSDate *myDate = [dateFormatter dateFromString:dateString];
    
    return myDate;
}

+ (NSString*)stringWithMD5:(NSString*)str
{
    const char *cStr = [str UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cStr, (unsigned int)strlen(cStr), result);
	return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

/*
 * 将时间转换为显示字符串，因只在这个界面里面使用，所以没放到Utility.h 里面
 */
+ (NSString *)timeStringWithTimeInterval:(NSTimeInterval)interval
{
    long hour = 0;
    long minute = 0;
    long second = 0;
    
    long timeValue = (long)interval;
    
    hour = (timeValue / 3600);
    timeValue = timeValue %3600;
    
    minute = (timeValue / 60);
    timeValue = timeValue%60;
    
    second = timeValue;
    
    if (hour > 0) {
        NSString *timeStr = [NSString stringWithFormat:@"%ld:%02ld:%02ld", hour, minute, second];
        
        return timeStr;
    }else{
        
        NSString *timeStr = [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
        
        return timeStr;
    }
//    
//    
//    static NSDateFormatter *formatter = nil;
//    if (formatter == nil) {
//        formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"H:mm:ss"];
//    }
//    
//    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:interval];
//    NSString *timeStr = [formatter stringFromDate:date];
//    
//    return timeStr;
}

//移动号码
+ (BOOL)isCMCCNumber:(NSString*)number
{
    if (number.length <= 0) {
        return NO;
    }
    //判断是否为移动的号码
    NSString* regExp = @"^((\\+86)|(\\+86 )|(86)|(86 ))?(13[4-9]|147|15([0-2]|[7-9])|18([2-4]|[7-8])|178|170)\\d{8}$";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regExp];
    
    return [predicate evaluateWithObject:number];
}


// 联通号码段 130,131,132, 155,156,185,186
+ (BOOL)isCUCCPhoneNum:(NSString *)phoneNum
{
    NSString *regex = @"^((\\+86)|(\\+86 )|(86)|(86 ))?1(3[0-2]|5[56]|8[56])\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:phoneNum];
}

// 电信号码段 133, 153, 180, 189
+ (BOOL)isCTCCPhoneNum:(NSString*)phoneNum
{
    NSString *regex = @"^((\\+86)|(\\+86 )|(86)|(86 ))?1(33|53|8[019])\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:phoneNum];
}

+ (BOOL)isValidMobilePhoneForString:(NSString *)aString
{
    BOOL result = NO;
    
    // 用户名只可包含3-20位的字母、数字、下划线，且以字母开头
    NSString *resultStr = [NSString stringWithFormat:@"%@", aString];
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    resultStr = [resultStr stringByTrimmingCharactersInSet:charSet];
    if (resultStr.length > 0) {
        return result;
    }
    
    if (aString.length != 11) {
        return result;
    }
    
    // 134 135 136 137  138 139  147  150 151 152 157 158 159  182 183 187 188
    
    NSArray *objects = [NSArray arrayWithObjects:@"134", @"135", @"136",@"137", @"138", @"139", @"147",@"150",@"151", @"152", @"157",
                        @"158",@"159", @"182",@"183", @"187", @"188", nil];
    
    for (NSString *aStr in objects) {
        if ([aString compare:aStr options:NSCaseInsensitiveSearch range:NSMakeRange(0, 3)] == NSOrderedSame) {
            result = YES;
            break;
        }
    }
    
    return result;
}

//验证非空
+ (BOOL)stringIsEmpty:(NSString *)aString shouldCleanWhiteSpace:(BOOL)cleanWhileSpace {
    if ((NSNull *) aString == [NSNull null]) {
        return YES;
    }
    if (aString == nil) {
        return YES;
    }
    else if ([aString length] == 0) {
        return YES;
    }
    if (cleanWhileSpace) {
        aString = [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([aString length] == 0) {
            return YES;
        }
    }
    return NO;
}

//去除特殊字符
+ (NSString *)replacePhoneCharacters:(NSString *)originalString {
    if (originalString.length >= 3) {
        NSString *_86String = [originalString substringWithRange:NSMakeRange(0, 3)];
        if ([_86String isEqualToString:@"+86"]) {   //去除+86
            originalString = [originalString stringByReplacingOccurrencesOfString:_86String withString:@""];
        }
    }
    
    NSRange range = [originalString rangeOfString:@"("];
    if (range.location != NSNotFound) {
        originalString = [originalString stringByReplacingCharactersInRange:range withString:@""];
    }
    range = [originalString rangeOfString:@")"];
    if (range.location != NSNotFound) {
        originalString = [originalString stringByReplacingCharactersInRange:range withString:@""];
    }
    
    range = [originalString rangeOfString:@"+"];
    if (range.location != NSNotFound) {
        originalString = [originalString stringByReplacingCharactersInRange:range withString:@""];
    }
    
    range = [originalString rangeOfString:@"."];
    while (range.location != NSNotFound) {
        originalString = [originalString stringByReplacingCharactersInRange:range withString:@""];
        range = [originalString rangeOfString:@" "];
    }
    
    originalString = [originalString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //空白和换行
    originalString = [originalString stringByReplacingOccurrencesOfString:@" " withString:@""]; //空格
    originalString = [originalString stringByReplacingOccurrencesOfString:@"-" withString:@""]; //-
    
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"01234567890"] invertedSet];   //数字
    originalString = [originalString stringByTrimmingCharactersInSet:set];
    
    set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];   //特殊字符
    originalString = [originalString stringByTrimmingCharactersInSet:set];
    
    return originalString;
}

+ (BOOL)isNumber:(NSString *)txt{
    NSString *regex = @"^[0-9]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:[txt description]];
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188  add 183,
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0235-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188  add 183,
     12         */
    NSString * CM = @"^(\\+86)?(13[4-9]|147|15([0-2]|[7-9])|18([2-4]|[7-8])|178|170)\\d{8}$";//@"^1(34[0-8]|(3[5-9]|5[017-9]|8[23478])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(BOOL)miguAccountCheck:(NSString*)nickname
{
    NSString *regExp = @"^[a-zA-Z\\u4E00-\\u9FA5\\uF900-\\uFA2D][a-zA-Z0-9_\\u4E00-\\u9FA5\\uF900-\\uFA2D]{3,19}";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regExp];
    return [predicate evaluateWithObject:nickname];
}

//利用正则表达式验证
+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//
// 电话号码格式如下：1232|3422|1231|43434|1111
// 过滤其中不是移动号码，不符合规范，以及重复的号码
//
+ (NSDictionary*)fileterCMCCPhoneNumList:(NSString*)phoneNums
{
    if (phoneNums==nil) {
        return nil;
    }
    
    NSMutableArray *correctPhones = [NSMutableArray array];
    NSMutableArray *badPhones = [NSMutableArray array];
    NSMutableArray *repeatPhones = [NSMutableArray array];
    
    NSArray* phones = [phoneNums componentsSeparatedByString:@"_"];
    
    for (NSString *phone in phones) {
        if ([self isCMCCNumber:phone]) {
            [correctPhones addObject:phone];
        }
        else {
            [badPhones addObject:phone];
        }
    }
    
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (int i=0; i<[correctPhones count]; i++) {
        NSString *str = [correctPhones objectAtIndex:i];
        BOOL bExist = NO;
        for (int j=0; j<[tmpArray count]; j++) {
            if ([str isEqualToString:(NSString*)[tmpArray objectAtIndex:j]]) {
                bExist = YES;
                [repeatPhones addObject:str];
                break;
            }
        }
        if (!bExist) {
            [tmpArray addObject:str];
        }
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithArray:tmpArray], @"CORRECTPHONES", [NSArray arrayWithArray:badPhones], @"BADPHONES", [NSArray arrayWithArray:repeatPhones], @"REPEATEDPHONES", nil];
    
}

+ (NSDictionary*)fileterPhoneNumList:(NSString*)phoneNums
{
    if (phoneNums==nil) {
        return nil;
    }
    
    NSMutableArray *correctPhones = [NSMutableArray array];
    NSMutableArray *badPhones = [NSMutableArray array];
    NSMutableArray *repeatPhones = [NSMutableArray array];
    
    NSArray* phones = [phoneNums componentsSeparatedByString:@"|"];
    
    for (NSString *phone in phones) {
        if ([self isCMCCNumber:phone]||[self isCTCCPhoneNum:(phone)]||[self isCUCCPhoneNum:phone]) {
            [correctPhones addObject:phone];
        }
        else {
            [badPhones addObject:phone];
        }
    }
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    for (int i=0; i<[correctPhones count]; i++) {
        NSString *str = [correctPhones objectAtIndex:i];
        BOOL bExist = NO;
        for (int j=0; j<[tmpArray count]; j++) {
            if ([str isEqualToString:(NSString*)[tmpArray objectAtIndex:j]]) {
                bExist = YES;
                [repeatPhones addObject:str];
                break;
            }
        }
        if (!bExist) {
            [tmpArray addObject:str];
        }
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithArray:tmpArray], @"CORRECTPHONES", [NSArray arrayWithArray:badPhones], @"BADPHONES", [NSArray arrayWithArray:repeatPhones], @"REPEATEDPHONES", nil];
}

+ (MPMediaItem*)getMediaItemFromIpodLibrary:(NSString*)mediaPersistentID
{
    unsigned long long ullvalue = strtoull([mediaPersistentID UTF8String], NULL, 0);
    NSNumber * songId = [[NSNumber alloc] initWithUnsignedLongLong:ullvalue];
    
    //    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    //    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    //    NSNumber * songId = [f numberFromString:mediaPersistentID];
    //    [f release];
    
    //    NSNumber *songId = [NSNumber numberWithLongLong:[mediaPersistentID longLongValue]];
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:songId forProperty:MPMediaItemPropertyPersistentID];
    
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    [query addFilterPredicate:predicate];
    NSArray *songs = [query items];
    
    if ([songs count]>0) {
        return [songs objectAtIndex:0];
    }
    return nil;
}

#pragma mark -- UIColor
//字符串转颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIImage *)resizeImage:(UIImage *)orginalImage resizeSize:(CGSize)size
{
    CGFloat actualHeight = orginalImage.size.height;
    CGFloat actualWidth = orginalImage.size.width;
    float oldRatio = actualWidth/actualHeight;
    float newRatio = size.width/size.height;
    if(oldRatio < newRatio)
    {
        oldRatio = size.height/actualHeight;
        actualWidth = oldRatio * actualWidth;
        actualHeight = size.height;
    }
    else
    {
        oldRatio = size.width/actualWidth;
        actualHeight = oldRatio * actualHeight;
        actualWidth = size.width;
    }
    
    CGRect rect = CGRectMake(0.0,0.0,actualWidth,actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [orginalImage drawInRect:rect];
    orginalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return orginalImage;
}

+ (UIImage *)maskImage:(UIImage *)originalImage toPath:(UIBezierPath *)path {
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, 0);
    [path addClip];
    [originalImage drawAtPoint:CGPointZero];
    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return maskedImage;
}

+ (UIImage *)clipImage:(UIImage*)image withRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    //
    //    if (IS_IPHONE_5) {
    //        CGRect rect = CGRectMake(floorf(image.size.width-63)/2,
    //                                 floorf((image.size.height-63)/2),
    //                                 63, 63);
    //        CGContextAddEllipseInRect(context, rect);
    //        CGContextEOClip(context);
    //
    //    }else{
    //        CGRect rect = CGRectMake(floorf(image.size.width-50)/2,
    //                                 floorf((image.size.height-50)/2),
    //                                 50, 50);
    //        CGContextAddEllipseInRect(context, rect);
    //        CGContextEOClip(context);
    //    }
    
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    
    
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIColor *)getColorFrom16:(NSString *)hexColor
{
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:1.0f];
}

//simple API that encodes reserved characters according to:
//RFC 3986
//http://tools.ietf.org/html/rfc3986

+ (NSString*)urlEncode:(NSString *)source
{
	return [self urlEncode:source leaveUnescaped:nil];
}

+ (NSString*)urlEncode:(NSString *)source leaveUnescaped:(NSString*)unescapted
{
	return (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)source, (CFStringRef)unescapted, CFSTR("!@$&*()_+-=,./?;':"), kCFStringEncodingUTF8);
}

+ (NSString*)urlDecode:(NSString*)source
{
	return (__bridge_transfer NSString*)CFURLCreateStringByReplacingPercentEscapes(NULL,(CFStringRef)source,CFSTR("!@$&*()_+-=,./?;':"));
}

+ (NSString*)urlEncode:(NSString*)source excludeCharactersInString:(NSString*)aString
{
	if(0 == [source length])
		return source;
	
	static NSDictionary* urlEncodingDictionary = nil;
	if (nil == urlEncodingDictionary)
	{
		urlEncodingDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
								 @"%3B", @";",
								 @"%2F", @"/",
								 @"%3F", @"?",
								 @"%3A", @":",
								 @"%26", @"&",
								 @"%3D", @"=",
								 @"%2B", @"+",
								 @"%24", @"$",
								 @"%2C", @",",
								 @"%5B", @"[",
								 @"%5D", @"]",
								 @"%23", @"#",
								 @"%21", @"!",
								 @"%27", @"'",
								 @"%28", @"(",
								 @"%29", @")",
								 @"%2A", @"*",
								 nil];
	}
	
	NSMutableCharacterSet* characterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@";/?:&=+$,[]#!'()*"];
	if(aString && [aString length] > 0)
	{
		[characterSet removeCharactersInString:aString];
	}
	
	NSRange range = [source rangeOfCharacterFromSet:characterSet];
	if(range.location == NSNotFound)
	{
		return source;
	}
	
	
	
	NSMutableString *tempString = [source mutableCopy];
	do
	{
		NSString* key = [tempString substringWithRange:range];
		NSString* value = [urlEncodingDictionary valueForKey:key];
		[tempString replaceCharactersInRange:range withString:value];
		range = [tempString rangeOfCharacterFromSet:characterSet];
	}
	while(range.location != NSNotFound);
	
	return tempString;
}

-(NSData *)blurImage:(NSData *)imageData width:(int)width height:(int)height
{
    return nil;
}

+ (UIImage*)filterImage:(UIImage*)image
{
    
    return nil;
}

+ (NSString *)getFilePath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *onlinePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    return onlinePath;
}

+ (BOOL)createFile:(NSString *)fileName {
//    DLog(@"create file:%@", fileName);
    NSString *online = [Utility getFilePath:fileName];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:online]) {
        return true;
    }
    NSError *error = nil;
    [manager createFileAtPath:online contents:nil attributes:nil];
    if (error) {
//        DLog(@"create file :%@ failed, the error is:%@", fileName, error);
        return false;
    }
    return true;
}

+ (BOOL)removeFile:(NSString *)fileName {
//    DLog(@"remove file:%@", fileName);
    NSString *online = [Utility getFilePath:fileName];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:online]) {
        NSError *error;
        [manager removeItemAtPath:online error:&error];
        if (error) {
//            DLog(@"remove file :%@ failed, the error is:%@", fileName, error);
            return false;
        } else {
            return true;
        }
    }
    return false;
}

+ (NSDictionary*)dictionaryFromQuery:(NSString *)query usingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"?&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        NSString *pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}

// 用颜色生成图片
+ (UIImage *)createImageWithColor:(UIColor *) color {
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *myImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
}


- (NSString*)currentTimeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMddHHmmssfff"];
    return [formatter stringFromDate:[NSDate date]];
}

+ (BOOL)isEmpty:(NSString *)str {
    if (!str) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

+ (NSMutableAttributedString *)getTextAttribute:(NSString *)text highlightStr:(NSArray *)highlightStrs color:(UIColor *)color {
    if (text && text.length > 0) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
        [attr setAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(0, text.length)];
        if (highlightStrs.count > 0) {
            for (NSString *str in highlightStrs) {
                NSRange range = [text rangeOfString:str];
//                [attr setAttributes:@{NSForegroundColorAttributeName: UIColorFromRGB(GetCurrentSkinColorValue)} range:range];
            }
        }
        return attr;
    }
    return nil;
}

//汉字转全拼
+ (NSString *) hanziToQuanpin:(NSString *)hanziString {
    
    if (!hanziString || [hanziString isEqualToString:@""]) {
        return nil;
    }
    
    NSMutableString * mStr = [NSMutableString stringWithString:hanziString];
    CFStringTransform((__bridge CFMutableStringRef)mStr, 0, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)mStr, NULL, kCFStringTransformStripDiacritics, NO);
    
    
    NSMutableString *lowString = [NSMutableString stringWithString:[mStr lowercaseString]];
    
    for (int i = 0; i<lowString.length; i++) {
        unichar C = [lowString characterAtIndex:i];

        if((C >='0' && C<= '9')) {
            if (i != 0) {
                unichar Ef = [lowString characterAtIndex:i - 1];
                if ((Ef>96)&&(Ef<123) && Ef != ' ') {
                    [lowString insertString:@" " atIndex: i];
                    i = i+2;
                }
            
            }
            
            if (i != lowString.length - 1) {
                unichar Eb = [lowString characterAtIndex:i + 1];
                if ((Eb>96)&&(Eb<123)&& Eb != ' ') {
                    [lowString insertString:@" " atIndex:i+1];
                    i = i+2;
                }
            }
            
        }
    }
    return lowString;
}

+ (NSString *) hanziToJianpin:(NSString *)hanziString {
    
    if (!hanziString || [hanziString isEqualToString:@""]) {
        return nil;
    }
    NSMutableString * mStr = [NSMutableString stringWithString:hanziString];
    CFStringTransform((__bridge CFMutableStringRef)mStr, 0, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)mStr, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSString * pinyin  = [mStr capitalizedString];

    NSMutableString * First = [NSMutableString stringWithString:pinyin];
    NSString * ABC =[[NSString alloc] init];
    
    for (int i = 0; i<First.length; i++) {
        unichar C = [First characterAtIndex:i];
        // 找出所有的大写字母
        if((C<= 'Z' && C>='A') || (C >='0' && C<= '9')) {
            ABC = [ABC stringByAppendingFormat:@"%C",C];
        }
    }
    
    [ABC lowercaseString];
    return  [ABC lowercaseString];
}

+ (UIImage *)QRCodeImageCreateByUrl:(NSURL *)url size:(CGFloat)size {
    // 1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 3. 将字符串转换成NSData
    NSString *urlStr = url.absoluteString;
    NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 6. 将CIImage转换成UIImage，并放大显示 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
    //    UIImage *codeImage = [UIImage imageWithCIImage:outputImage scale:1.0 orientation:UIImageOrientationUp];
    
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];//重绘二维码,使其显示清晰
    return image;
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (NSDictionary *)paramsForJumpToPage:(NSString *)data {

    if (![data isKindOfClass:[NSString class]]) {
        return nil;
    }
    if (![data containsString:@"?"]) {
        return nil;
    }

    NSRange range = [data rangeOfString:@"?"];
    NSString *type = [data substringToIndex:range.location];
    if (type.length == 0) {
        return nil;
    }
    NSString *keyValues = [data substringFromIndex:range.location + 1];
    if (keyValues.length == 0) {
        return nil;
    }
    NSArray *paramsArr = [keyValues componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSString *keyValue in paramsArr) {
        if (![keyValue containsString:@"="]) {
            continue;
        }
        NSRange range = [keyValue rangeOfString:@"="];
        NSString *key = [keyValue substringToIndex:range.location];
        NSString *value = [keyValue substringFromIndex:range.location + 1];
        if (key && value) {
            params[key] = value;
        }
    }
    return @{@"type": type, @"params": params};
}

+ (NSString *)formatedUserName:(NSString *)userName userId:(NSString *)userId {
    if (userName.length > 0 && ![userName isEqualToString:@"咪咕音乐用户"]) {
        return userName;
    }
    if (userId.length >= 4) {
        ;
        return [NSString stringWithFormat:@"咪咕音乐用户%@", [userId substringFromIndex:userId.length - 4]];
    } else if (userId.length > 0 && userId.length < 4) {
        return [NSString stringWithFormat:@"咪咕音乐用户%@", userId];
    } else {
        return @"咪咕音乐用户";
    }
}

@end
