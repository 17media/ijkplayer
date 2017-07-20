//
//  CountSpeed.h
//  IJKMediaPlayer
//
//  Created by mymac on 2017/6/18.
//  Copyright © 2017年 bilibili. All rights reserved.
//

#ifndef CountSpeed_h
#define CountSpeed_h

#include "ijkplayer.h"
#include "ijkplayer_internal.h"
#include "IJKFFMonitor.h"

@interface WeakNetwork : NSObject

+(long)getSpeed:(long)tBytes mplay:(IjkMediaPlayer *)mp mntr:(IJKFFMonitor *)monitor;
+(void)ajust_buffer_timer:(int) tcpSpeed mplay:(IjkMediaPlayer *)mp btr:(int)bitrate;
+(void)set_buffering;
@end

#endif /* CountSpeed_h */
