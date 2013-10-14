//
//  PLLanchCycleSprite.m
//  poolGameEx
//
//  Created by 郭 健 on 13-10-12.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import "PLLanchCycleSprite.h"

#define PL_LANCH_FORCE_DELTA        -0.2
@implementation PLLanchCycleSprite

+(id)LanchCycleSprite
{
    return [[[PLLanchCycleSprite alloc] InitLanchCycleSprite] autorelease];
}

-(id)InitLanchCycleSprite
{
    self = [super initWithFile:@"cycle.png"];
    if (self) {
        _mLanchAble = YES;
        mLanchBall = [ENDragableSprite DragableSpriteWithSprite:[CCSprite spriteWithSpriteFrameName:@"ball_0.png"]];
        mLanchBall.mTouchPriority = kCCMenuHandlerPriority - 100;
        mLanchBall.mSwallowTouches = YES;
        mLanchBall.mDelegate = self;
        mLanchBall.anchorPoint = ccp(0.5, 0.5);
        mLanchBall.position = centerOfSize(self.contentSize);
        [self addChild:mLanchBall z:0];
        
        mArrow = [CCSprite spriteWithFile:@"arrow.png"];
        mArrow.position = mLanchBall.position;
        mArrow.anchorPoint = ccp(1, 0.5);
        [self addChild:mArrow z:1];
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    
    [self scheduleUpdate];
}

-(void)onExit
{
    [super onExit];
    
    [self unscheduleUpdate];
}

-(void)update:(ccTime)delta
{
    
}

-(void)DragBegin:(CCNode *)sender
{
    
}

-(void)Draging:(CCNode *)sender
{
    [self CheckBallAndArrow];
}

-(void)DragEnd:(CCNode *)sender
{
    [self CheckBallAndArrow];
    
    CGPoint ballPt = mLanchBall.position;
    CGPoint center = centerOfSize(self.contentSize);
    CGPoint tmpPt = ccpSub(ballPt, center);
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(LanchWithForce:withPt:withPlayerType:)]) {
        NSLog(@"%@[[%@", NSStringFromCGPoint(self.position), NSStringFromCGPoint(mLanchBall.position));
        CGPoint lanchPt = ccpAdd(self.position, tmpPt);
        [self.mDelegate LanchWithForce:ccp(tmpPt.x*PL_LANCH_FORCE_DELTA, tmpPt.y*PL_LANCH_FORCE_DELTA) withPt:lanchPt withPlayerType:self.mPlayerType];
    }
    
    self.mLanchAble = NO;
}

-(void)CheckBallAndArrow
{
    CGPoint ballPt = mLanchBall.position;
    CGPoint center = centerOfSize(self.contentSize);
    CGFloat dist = ccpDistance(center, ballPt);
    
    CGPoint tmpPt = ccpSub(ballPt, center);
    CGFloat angle = ccpToAngle(tmpPt);
    CGPoint pt = ccpForAngle(angle);
    
    NSLog(@"%f", angle);
    if (dist > 50) {
        CGFloat x = center.x + 50.0 * pt.x;
        CGFloat y = center.y + 50.0 * pt.y;
        ballPt = ccp(x, y);
        dist = 50;
    }

    mArrow.rotation = -180*angle/M_PI;
    mArrow.scaleX = 1+(dist*0.05);
    mLanchBall.position = ballPt;
}

-(void)setMLanchAble:(BOOL)mLanchAble
{
    if (_mLanchAble == mLanchAble) {
        return;
    }
    
    _mLanchAble = mLanchAble;
    self.visible = _mLanchAble;
    if (_mLanchAble) {
        mArrow.position = mLanchBall.position = centerOfSize(self.contentSize);
    }
    mArrow.visible = mLanchBall.visible = _mLanchAble;
    mArrow.rotation = 0;
    mArrow.scaleX = 1;
}

-(void)setMPlayerType:(PLPlayerType)mPlayerType
{
    _mPlayerType = mPlayerType;
    [mLanchBall.mSprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"ball_%d.png", _mPlayerType]]];
}

@end
