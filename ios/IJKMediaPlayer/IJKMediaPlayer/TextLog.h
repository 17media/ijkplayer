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

//set public logt;
+(void)Setmc:(NSString*)mcstr;
+(void)SetUid:(NSString*)id;
+(void)Setlt:(NSString*)ltstr;
+(void)Setos:(NSString*)osstr;
+(void)Setosv:(NSString*)osvstr;
+(void)Setmod:(NSString*)modstr;
+(void)Setcarrier:(NSString*)carrierstr;
+(void)Setnt:(NSString*)ntstr;
+(void)Setlngt:(NSString*)lngtstr;
+(void)Setltt:(NSString*)lttstr;
+(void)Setmip:(NSString*)mipstr;
+(void)Setrg:(NSString*)rgstr;

+(void)LogPublicText:(NSString*)fileName;
+(void)LogText:(NSString *)fileName format:(NSString *)format, ...;

@end

#endif /* TextLog_h */
