//
//  TextLog.h
//  IJKMediaPlayer
//
//  Created by mymac on 2017/6/18.
//  Copyright © 2017年 bilibili. All rights reserved.
//

#ifndef TextLog_h
#define TextLog_h

#define LOG_FILE_NAME @"log.txt"

@interface TextLog : NSObject

//set public ;
+(void)Setpt:(NSString*)ptstr;
+(void)Setmc:(NSString*)mcstr;
+(void)SetUid:(NSString*)id;
+(void)Setsd:(NSString*)sdstr;
+(void)Setpd:(NSString*)pdstr;
+(void)Setlt:(NSString*)ltstr;
+(void)Setos:(NSString*)osstr;
+(void)Setosv:(NSString*)osvstr;
+(void)Setmod:(NSString*)modstr;
+(void)Setcr:(NSString*)crstr;
+(void)Setnt:(NSString*)ntstr;
+(void)Setlnt:(NSString*)lntstr;
+(void)Setltt:(NSString*)lttstr;
+(void)Setmip:(NSString*)mipstr;
+(void)Seturl:(NSString*)urlstr;
+(void)Setrg:(NSString*)rgstr;
+(void)Sethost:(NSString*)hoststr;

+ (void)StartPing:(NSString*)host;
+(void)LogText:(NSString *)fileName format:(NSString *)format, ...;

@end

#endif /* TextLog_h */
