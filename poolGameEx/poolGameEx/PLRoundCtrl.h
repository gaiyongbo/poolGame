//
//  PLRoundCtrl.h
//  poolGameEx
//
//  Created by 郭 健 on 13-10-14.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLPlayer.h"

typedef enum
{
    PLGameStatusReadyToLanch = 0,
    PLGameStatusMoving,
    PLGameStatusSelectOutBall,
    PLGameStatusGameOver
}PLGameStatus;

@interface PLRoundCtrl : NSObject

@property(nonatomic)BOOL            mHaveCollisionInnerBall;
@property(nonatomic)PLGameStatus    mGameStatus;
@property(nonatomic)PLPlayerType    mCurPlayerIndex;
@property(nonatomic,retain)NSMutableArray         *mKOBallArray;

-(void)Update;
@end
