//
//  CountSpeed.m
//  IJKMediaPlayer
//
//  Created by mymac on 2017/6/18.
//  Copyright © 2017年 bilibili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeakNetwork.h"
#import "TextLog.h"
#import "IJKFFOptions.h"
#import "STDPingServices.h"

//begin, static speed by buffer update.
static long startTime=0;
static long speed=0;
static long transbytes=0;
static int64_t avspeed=0;
//end, static


//begin adjust variables.by speed,ping,rtt,bufferring times.
static STDPingServices    *pingServices=NULL;
static long checkTimes=0;
static CGFloat  curPingLoss=0.0;
static long curAvRtt=0;
static int64_t curAvspeed=0;
static int curBuffering=0;
//end adjust variables.
@implementation WeakNetwork : NSObject

+ (void)_pingActionFired {
    
    NSLog(@"pingstart...");
    
    pingServices = [STDPingServices startPingAddress:@"www.baidu.com" sendnum:10 callbackHandler:^(STDPingItem *pingItem, NSArray *pingItems) {
        if (pingItem.status != STDPingStatusFinished) {
            //[weakSelf.textView appendText:pingItem.description];
            //NSLog(@"%@",pingItem.description);
        } else {
            
            NSLog(@"%f",[STDPingItem getLossPercent]);
            NSLog(@"%li",[STDPingItem staticAvgRtridTime]);
            
            curPingLoss = [STDPingItem getLossPercent];
            curAvRtt = [STDPingItem staticAvgRtridTime];

        }
    }];
}
//don't use now.
+(long)getSpeed:(long)tBytes mplay:(IjkMediaPlayer *)mp mntr:(IJKFFMonitor *)monitor {
    transbytes += tBytes;
    NSDate * date = [NSDate date];
    long nowTime = date.timeIntervalSince1970;
    
    if( 0 == startTime ){
        startTime = nowTime;
        return 0;
    }
    
    long interval = (nowTime - startTime);
    
    if(interval > 10){
        speed = transbytes/interval;
        startTime = nowTime;
        transbytes = 0;
        //record once  per 10s
        [TextLog LogText:LOG_FILE_NAME format:@"pd=&lt=ps&type=play&speed=%ld&sip=",speed];
        int64_t bt = monitor.bitrate/1000;
        if(0!=monitor.bitrate && speed < (0.8 * bt) ){
            //mp->ffplayer->packet_buffering = 1;
        }
    }
    
    return speed;
}

+(void)reset{
    curPingLoss = 0;
    curAvRtt = 0;
    curAvspeed = 0;
    checkTimes = 0;
}


+(void)ajust_buffer_timer:(int64_t) tcpSpeed mplay:(IjkMediaPlayer *)mp btr:(int64_t)bitrate {
    
    checkTimes++;
    if(0!=tcpSpeed){
        curAvspeed+=tcpSpeed;
        curAvspeed=curAvspeed/2;
    }
//    if( 1 == checkTimes ){
//        //check ping result.
//        [WeakNetwork _pingActionFired];
//    }
    if( 20 == checkTimes ){
        
        //curAvspeed,curAvRtt,curPingLoss,curBuffering,
        //1,3,5,7.
        if( 0==curBuffering && (curAvspeed > 1.1*bitrate && bitrate!=0)) {//use the littlest buffer.
        //if( 0==curBuffering && curAvspeed > 1.1*bitrate && 0==curPingLoss && curAvRtt <= 250) {//use the littlest buffer.
            mp->ffplayer->dcc.current_high_water_mark_in_ms = 1000;
        }
        if(1 == curBuffering || (curAvspeed < bitrate && bitrate!=0)){//if has buffering,must increase.
            mp->ffplayer->dcc.current_high_water_mark_in_ms += 2000;
            if(mp->ffplayer->dcc.current_high_water_mark_in_ms >7000) mp->ffplayer->dcc.current_high_water_mark_in_ms = 7;
        }
        if(0 == curBuffering &&( (curAvspeed > 1.2*bitrate && bitrate!=0 )) ){
        //if(0 == curBuffering && 0==curPingLoss && ( curAvspeed > 1.1*bitrate || ( 0!=curAvRtt && curAvRtt < 200)) ){//
            mp->ffplayer->dcc.current_high_water_mark_in_ms -= 2000;
            if( mp->ffplayer->dcc.current_high_water_mark_in_ms <=1000 ) mp->ffplayer->dcc.current_high_water_mark_in_ms = 1000;
        }
        [WeakNetwork reset];
    }
}

+(void)set_buffering{
    curBuffering = 1;
}

@end
