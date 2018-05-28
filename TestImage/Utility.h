//
//  Utility.h
//  MobileMusic4
//
//  Created by 崔 晓乾 on 12-2-1.
//  Copyright (c) 2012年 云泓道元. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface Utility : NSObject
//获取当前时间字符串 “yyyyMMddHHmmss”
+ (NSString *)getDateString;

+ (NSString *)getDocumentsDir;

+ (NSString *)getCutMusicDir;

+ (NSString *)appendUaVersionForUrl:(NSString *)paramUrl;

+ (NSString *)currentTimeString;

+ (NSString *)stringWithMD5:(NSString *)str;

+ (NSDate *)dateFromString:(NSString *)dateString;   // yyyy-MM-dd hh:mm:ss

+ (NSString *)timeStringWithTimeInterval:(NSTimeInterval)interval;

//
// 移动号码段
//  134 135 136 137  138 139  147  150 151 152 157 158 159  182 183 187 188
// 只是简单判断，不考虑前缀情况
//
+ (BOOL)isNumber:(NSString *)txt;
+ (BOOL)isCUCCPhoneNum:(NSString*)phoneNum;

+ (BOOL)isCTCCPhoneNum:(NSString*)phoneNum;

+ (BOOL)isValidMobilePhoneForString:(NSString *)aString;

//4.1新增接口，判断是否为移动电话号码
+ (BOOL)isCMCCNumber:(NSString*)number;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (BOOL)isValidateEmail:(NSString *)email;

+ (BOOL)miguAccountCheck:(NSString*)nickname;
//
// 电话号码格式如下：1232|3422|1231|43434|1111
// 过滤其中不是移动号码，不符合规范，以及重复的号码
//
+ (NSDictionary*)fileterCMCCPhoneNumList:(NSString*)phoneNums;

+ (NSDictionary*)fileterPhoneNumList:(NSString*)phoneNums;

// 验证string非空   cleanWhileSpace:是否清除空格
+ (BOOL)stringIsEmpty:(NSString *)aString shouldCleanWhiteSpace:(BOOL)cleanWhileSpace;
// 去除号码中的特殊字符
+ (NSString *)replacePhoneCharacters:(NSString *)originalString;

//
// 从ipod library中获取歌曲封面图片
//
+ (MPMediaItem*)getMediaItemFromIpodLibrary:(NSString*)mediaPersistentID;

+ (UIImage *) resizeImage:(UIImage *)orginalImage resizeSize:(CGSize)size;
+ (UIImage *)maskImage:(UIImage *)originalImage toPath:(UIBezierPath *)path;
+ (UIImage *)clipImage:(UIImage*)image withRect:(CGRect)rect;

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
+ (UIColor *)getColorFrom16:(NSString *)hexColor; //获取16进制RGB颜色

+ (NSString*)urlEncode:(NSString*)source;
+ (NSString*)urlDecode:(NSString*)source;
+ (NSString*)urlEncode:(NSString *)source leaveUnescaped:(NSString*)unescapted;
+ (NSString*)urlEncode:(NSString*)source excludeCharactersInString:(NSString*)aString;

+ (UIImage*)filterImage:(UIImage*)image;

+ (NSString*)getFilePath:(NSString *)fileName;  //根据文件名获取文件路径
+ (BOOL)createFile:(NSString *)fileName;        //创建文件
+ (BOOL)removeFile:(NSString *)fileName;        //删除文件

+ (NSDictionary*)dictionaryFromQuery:(NSString *)query usingEncoding:(NSStringEncoding)encoding;    //将NSURL的参数转为dictionary

+ (UIImage *)createImageWithColor:(UIColor *) color; // 颜色生成图片

+ (BOOL)isEmpty:(NSString *)str;// 判断字符串是否全为空

+ (NSMutableAttributedString *)getTextAttribute:(NSString *)text highlightStr:(NSArray *)highlightStrs color:(UIColor *)color; // 设置高亮字符
//汉字转拼音
//汉字转全拼 如果为混排只会转换中文，不会有空格区分
+ (NSString *) hanziToQuanpin:(NSString *) hanziString;
//汉字转简拼 如果中英混排以空格为准返回首字母（小写）
+ (NSString *) hanziToJianpin:(NSString *) hanziString;
// 根据url生成二维码图片
+ (UIImage *)QRCodeImageCreateByUrl:(NSURL *)url size:(CGFloat)size;

+ (NSDictionary *)paramsForJumpToPage:(NSString *)data;

+ (NSString *)formatedUserName:(NSString *)userName userId:(NSString *)userId;
@end
