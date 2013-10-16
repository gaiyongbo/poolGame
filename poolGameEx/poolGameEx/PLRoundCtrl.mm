//
//  PLRoundCtrl.m
//  poolGameEx
//
//  Created by 郭 健 on 13-10-14.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import "PLRoundCtrl.h"
#import "HelloWorldLayer.h"

@implementation PLRoundCtrl

-(id)init
{
    self = [super init];
    if (self) {
        self.mGameStatus = PLGameStatusReadyToLanch;
        self.mHaveCollisionInnerBall = NO;
        self.mCurPlayerIndex = PLPlayerType0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HandleCollision:) name:COLLISION_NOTIFY object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BallSelected:) name:SELECT_BALL_NOTIFY object:nil];
    }
    return self;
}

-(void)HandleCollision:(NSNotification*)notify
{
    PLBallSprite *ball = notify.object;
    
    self.mHaveCollisionInnerBall = self.mHaveCollisionInnerBall || ball.mPrevStatus == PLBallStatusIn;
}

-(void)setMCurPlayerIndex:(PLPlayerType)mCurPlayerIndex
{
    if (CURGAMELAYER == nil) {
        return;
    }
    
    _mCurPlayerIndex = mCurPlayerIndex;
    self.mHaveCollisionInnerBall = NO;
    self.mGameStatus = PLGameStatusReadyToLanch;
    
    PLBallSprite *outBall = nil;
    for (PLBallSprite *ball in CURGAMELAYER.ballArray) {
        [ball CheckPrevStatus];
        if (ball.mStatus == PLBallStatusOut && ball.mPlayer.mType == _mCurPlayerIndex) {
            outBall = ball;
        }
    }
    
    if (outBall) {
        [CURGAMELAYER SetLanchCycleWithPType:_mCurPlayerIndex withPt:outBall.position];
        [outBall RemoveWithAddScore:NO];
    }
    else
    {
        [CURGAMELAYER SetLanchCycleWithPType:_mCurPlayerIndex withPt:CGPointZero];
    }
}

-(void)NextPlayer
{
    if (CURGAMELAYER == nil) {
        return;
    }
    
    NSInteger ret = -1;
    for (int i = 1; i <= CURGAMELAYER.playerArray.count; i++) {
        NSInteger index = (self.mCurPlayerIndex + i)%CURGAMELAYER.playerArray.count;
        PLPlayer *player = [CURGAMELAYER.playerArray objectAtIndex:index];
        if (player.mBallCount > 0) {
            ret = index;
            break;
        }
    }
    
    if (ret >= 0 && ret < CURGAMELAYER.playerArray.count) {
        self.mCurPlayerIndex = (PLPlayerType)ret;
    }
    else
    {
        self.mGameStatus = PLGameStatusGameOver;
    }
}

-(void)Update
{
    if (self.mGameStatus > PLGameStatusMoving) {
        return;
    }
    
    if (CURGAMELAYER == nil) {
        return;
    }
    
    BOOL haveMovingBall = NO;
    BOOL haveInnerBall = NO;
    for (PLBallSprite *ball in CURGAMELAYER.ballArray) {
        haveMovingBall = haveMovingBall || ball.mStatus == PLBallStatusMoving;
        haveInnerBall = haveInnerBall || [CURGAMELAYER IsBallInPlayGround:ball];
    }
    
    if (!haveInnerBall && !haveMovingBall) {
        self.mGameStatus = PLGameStatusGameOver;
        return;
    }
    
    if (self.mGameStatus == PLGameStatusReadyToLanch)
    {
        if (haveMovingBall) {
            self.mGameStatus = PLGameStatusMoving;
        }
    }
    else if (self.mGameStatus == PLGameStatusMoving)
    {
        if (!haveMovingBall) {
            self.mGameStatus = PLGameStatusSelectOutBall;
        }
        else
        {
        }
    }
}

-(void)setMGameStatus:(PLGameStatus)mGameStatus
{
    _mGameStatus = mGameStatus;
    if (_mGameStatus == PLGameStatusGameOver) {
        [CURGAMELAYER ShowAlert];
    }
    else if (_mGameStatus == PLGameStatusSelectOutBall)
    {
        self.mKOBallArray = nil;
        
        NSInteger koCount = 0;
        NSMutableArray *koBall = [NSMutableArray arrayWithCapacity:4];
        for (PLBallSprite *ball in CURGAMELAYER.ballArray) {
            if ([ball IsKnockOut])//是否存在打出去的球
            {
                koCount += 1;
                [koBall addObject:ball];
            }
            else if ([ball IsCurPlayerAndOut])//是否存在当前用户的球
            {
//                koCount += 1;//当前球算作KO球
                [koBall addObject:ball];
            }
        }
        
        //判断外围是否存在打出去的球或者自己的球
        if (koBall.count > 0) {
            PLPlayer *curPlayer = [CURGAMELAYER.playerArray objectAtIndex:self.mCurPlayerIndex];
            curPlayer.mBallCount += 1;
        }
        
        //如果不存在碰撞或者没有打出球，开始下一轮
        if (!self.mHaveCollisionInnerBall || koCount == 0) {
            [koBall removeAllObjects];
            [self NextPlayer];
            return;
        }
        
        //设置可选择的球
        self.mKOBallArray = koBall;
        for (PLBallSprite *ball in self.mKOBallArray) {
            [ball SetSelectable];
        }
    }
}

-(void)BallSelected:(NSNotification*)notify
{
    if (notify.object && self.mGameStatus == PLGameStatusSelectOutBall && self.mKOBallArray && self.mKOBallArray.count) {
        for (PLBallSprite *ball in self.mKOBallArray) {
            if (ball != notify.object) {
                [ball RemoveWithAddScore:YES];
            }
        }
        
        self.mKOBallArray = nil;
    }
    
    self.mCurPlayerIndex = self.mCurPlayerIndex;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

@end
