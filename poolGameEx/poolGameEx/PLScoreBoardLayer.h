//
//  PLScoreBoardLayer.h
//  poolGameEx
//
//  Created by 郭 健 on 13-10-13.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import "CCLayer.h"

@interface PLScoreBoardLayer : CCLayer
{
    CCLabelTTF              *curPlayerName;
    CCLabelTTF              *curPlayerBallCount;
    CCLabelTTF              *curPlayerScore;
}

@end
