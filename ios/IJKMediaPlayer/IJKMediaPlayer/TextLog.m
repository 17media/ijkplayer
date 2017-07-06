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

static NSString *pt=@"";//scheme,protocal type.
static NSString *mc=@"";//mac id
static NSString *uid=@"";//User Id
static NSString *sd=@"play";//stream direction
static NSString *pd=@"wansu";//provider
static NSString *lt=@"";//Log type
static NSString *os=@"";//os type
static NSString *osv=@"";//Os version
static NSString *mod=@"";// phone model
static NSString *cr=@"中华电信";
static NSString *nt=@"";//net type
static NSString *lnt=@"";
static NSString *ltt=@"";
static NSString *mip=@"";//my public ip.
static NSString *url=@"";//url
static NSString *rg=@"";//computer region.
static NSString *av17=@"";//app version 17media.
static NSString *host=@"";
static NSString *publicStr=@"";//app version 17media.
static NSString *pingRtt=@"";//ping round trip interval.
static NSString *pingloss=@"";//ping packet loss.


@implementation TextLog : NSObject


+(void)Setpt:(NSString*)ptstr{
    pt = ptstr;
}

+(void)Setmc:(NSString*)mcstr{
    mc = mcstr;
}
+(void)SetUid:(NSString*)id{
    uid = id;
}
+(void)Setsd:(NSString*)sdstr{
    sd = sdstr;
}
+(void)Setpd:(NSString*)pdstr{
    pd = pdstr;
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


+(void)Setcr:(NSString*)crstr{
    cr = cr;
}


+(void)Setnt:(NSString*)ntstr{
    nt = ntstr;
}

+(void)Setlnt:(NSString*)lntstr{
    lnt = lntstr;
}

+(void)Setltt:(NSString*)lttstr{
    ltt = lttstr;
}

+(void)Setmip:(NSString*)mipstr{
    mip = mipstr;
}

+(void)Seturl:(NSString*)urlstr{
    url = urlstr;
}


+(void)Setrg:(NSString*)rgstr{
    rg = rgstr;
}

+(void)Sethost:(NSString*)hoststr{
    host = [[NSString alloc] initWithString:hoststr];
}

//for ping.
static STDPingServices    *pingServices=NULL;
+ (void)StartPing:(NSString*)host {
    
    NSLog(@"111pingstart...");
    
    pingServices = [STDPingServices startPingAddress:host sendnum:15 callbackHandler:^(STDPingItem *pingItem, NSArray *pingItems) {
        if (pingItem.status != STDPingStatusFinished) {
            //[weakSelf.textView appendText:pingItem.description];
            NSLog(@"%@",pingItem.description);
        } else {
            
            NSLog(@"%f",[STDPingItem getLossPercent]);
            NSLog(@"%li",[STDPingItem staticAvgRtridTime]);
            
            pingloss = [NSString stringWithFormat:@"%f",[STDPingItem getLossPercent]];
            pingRtt = [NSString stringWithFormat:@"%li",[STDPingItem staticAvgRtridTime]];
            
            [TextLog LogText:LOG_FILE_NAME format:@"lt=pv&prtt=%@&plss=%@",pingRtt,pingloss];
            int k=0;
        }
    }];
}


+ (NSString*)GetPublicText{
    
    NSString *time = [TextLog GetTimeStr];
    
    publicStr = [NSString stringWithFormat:@"tm=%@&mc=%@&uid=%@&sd=%@&pd=%@&os=%@&osv=%@&mod=%@&cr=%@&nt=%@&mip=%@&rg=%@&av17=%@&pt=%@&host=%@&url=%@&",
                 time,mc,uid,sd,pd,os,osv,mod,cr,nt,mip,rg,av17,pt,host,url];
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
    
    
    NSString *str = [NSString stringWithFormat:@"%@\r\n",string];
    NSData* stringData  = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [fileHandle writeData:stringData]; //追加写入数据
    
    [fileHandle closeFile];
}

//format:  "lt=www&" "log=www&"
+(void)LogText:(NSString *)fileName format:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    NSString *logtxt =[NSString stringWithFormat:@"%@%@",[TextLog GetPublicText ],str];
    //send to app
    [[NSNotificationCenter defaultCenter] postNotificationName: @"NotificationFromIJK_Log" object: logtxt];
    //end
    [TextLog writefile:logtxt fn:fileName];
}

@end
