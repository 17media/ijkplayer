//
//  TextLog.m
//  IJKMediaPlayer
//
//  Created by mymac on 2017/6/18.
//  Copyright © 2017年 bilibili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextLog.h"
#import "STDPingServices.h"

static NSString *mc=@"11";//mac id
static NSString *uid=@"";//User Id
static NSString *lt=@"";//Log type
static NSString *os=@"";//os type
static NSString *osv=@"";//Os version
static NSString *mod=@"";// phone model
static NSString *carrier=@"";
static NSString *nt=@"";//net type
static NSString *lngt=@"";
static NSString *ltt=@"";
static NSString *mip=@"";//public ip.
static NSString *rg=@"";//computer region.
static NSString *av17=@"";//app version 17media.
static NSString *publicStr=@"";//app version 17media.

static STDPingServices    *pingServices=NULL;

@implementation TextLog : NSObject

+(void)Setmc:(NSString*)mcstr{
    mc = mcstr;
}
+(void)SetUid:(NSString*)id{
    uid = id;
}
+(void)Setlt:(NSString*)ltstr{
    lt = ltstr;
}

+(void)Setos:(NSString*)osstr{
    os = osstr;
}

+(void)Setosv:(NSString*)osvstr{
    osv = osvstr;
}

+(void)Setmod:(NSString*)modstr{
    mod = modstr;
}


+(void)Setcarrier:(NSString*)carrierstr{
    carrier = carrier;
}


+(void)Setnt:(NSString*)ntstr{
    nt = ntstr;
}

+(void)Setlngt:(NSString*)lngtstr{
    lngt = lngtstr;
}

+(void)Setltt:(NSString*)lttstr{
    ltt = lttstr;
}

+(void)Setmip:(NSString*)mipstr{
    mip = mipstr;
}

+(void)Setrg:(NSString*)rgstr{
    rg = rgstr;
}

+ (void)_pingActionFired {
    
    NSLog(@"111pingstart...");
    
    pingServices = [STDPingServices startPingAddress:@"www.baidu.com" sendnum:2 callbackHandler:^(STDPingItem *pingItem, NSArray *pingItems) {
        if (pingItem.status != STDPingStatusFinished) {
            //[weakSelf.textView appendText:pingItem.description];
            NSLog(@"%@",pingItem.description);
        } else {
            
            NSLog(@"%f",[STDPingItem getLossPercent]);
            NSLog(@"%li",[STDPingItem staticAvgRtridTime]);
            //NSLog(@"%@",[STDPingItem statisticsWithPingItems:pingItems]);
            /*
             [weakSelf.textView appendText:[STDPingItem statisticsWithPingItems:pingItems]];
             [button setTitle:@"Ping" forState:UIControlStateNormal];
             button.tag = 10001;
             weakSelf.pingServices = nil;
             */
        }
    }];
}

+(void)LogPublicText:(NSString*)fileName{
    
    //[TextLog _pingActionFired];
    
    NSString *time = [TextLog GetTimeStr];
    
    publicStr = [NSString stringWithFormat:@"time=%@&mc=%@&uid=%@&lt=%@&os=%@&osv=%@&mod=%@&carrier=%@&nt=%@&lngt=%@&ltt=%@&mip=%@&rg=%@&av17=%@&\r\n",
                 time,mc,uid,lt,os,osv,mod,carrier,nt,lngt,ltt,mip,rg,av17];
    
    [TextLog writefile:publicStr fn:fileName];
}


+ (NSString*)GetPublicText{
    
    NSString *time = [TextLog GetTimeStr];
    
    publicStr = [NSString stringWithFormat:@"time=%@&mc=%@&uid=%@&lt=%@&os=%@&osv=%@&mod=%@&carrier=%@&nt=%@&lngt=%@&ltt=%@&mip=%@&rg=%@&av17=%@&",
                 time,mc,uid,lt,os,osv,mod,carrier,nt,lngt,ltt,mip,rg,av17];
    
    return  publicStr;
}


+ (NSString*) GetTimeStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];
    return datestr;
}

+ (void)writefile:(NSString *)string fn:(NSString*)fileName
{
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *homePath = [paths objectAtIndex:0];
    
    NSString *filePath = [homePath stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:filePath]) //如果不存在
    {
        
        [string writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        return;
        
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    
    [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
    
    NSString *time = [TextLog GetTimeStr];
    
    //NSString *str = [NSString stringWithFormat:@"time=%@&%@\r\n",time,string];
    NSString *str = [NSString stringWithFormat:@"%@\r\n",string];
    //NSString *str = [NSString stringWithFormat:@"%@%@\r\n",GetPublicText(),string];
    //send to app
    [[NSNotificationCenter defaultCenter] postNotificationName: @"NotificationFromIJK_Log" object: str];
    //end
    NSData* stringData  = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [fileHandle writeData:stringData]; //追加写入数据
    
    [fileHandle closeFile];
}

//fromat:  "lt=www&" "log=www&"
+(void)LogText:(NSString *)fileName format:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    //NSString *logtxt =[NSString stringWithFormat:@"uid=%@&%@",uid,str];
    NSString *logtxt =[NSString stringWithFormat:@"%@%@",[TextLog GetPublicText ],str];
    //[TextLog WriteFile:log fn:@"log.txt"];
    [TextLog writefile:logtxt fn:fileName];
}

@end
