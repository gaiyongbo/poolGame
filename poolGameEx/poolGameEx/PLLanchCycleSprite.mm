//
//  PLLanchCycleSprite.m
//  poolGameEx
//
//  Created by 郭 健 on 13-10-12.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import "PLLanchCycleSprite.h"
#import "HelloWorldLayer.h"

#define PL_LANCH_FORCE_DELTA        -0.24
@implementation PLLanchCycleSprite

+(id)LanchCycleSprite
{
    return [[[PLLanchCycleSprite alloc] InitLanchCycleSprite] autorelease];
}

-(id)InitLanchCycleSprite
{
    self = [super initWithSpriteFrameName:@"lanch_cycle.png"];
    if (self) {
        _mLanchAble = YES;
        mLanchBall = [ENDragableSprite DragableSpriteWithSprite:[CCSprite spriteWithSpriteFrameName:@"ball_0.png"]];
        mLanchBall.mTouchPriority = kCCMenuHandlerPriority - 100;
        mLanchBall.mSwallowTouches = YES;
        mLanchBall.mDelegate = self;
        mLanchBall.anchorPoint = ccp(0.5, 0.5);
        mLanchBall.position = centerOfSize(self.contentSize);
        [mLanchBall MakeBigSize:self.contentSize];
        [self addChild:mLanchBall z:0];
        
        mArrow = [CCSprite spriteWithFile:@"arrow.png"];
        mArrow.position = mLanchBall.position;
        mArrow.anchorPoint = ccp(1, 0.5);
        [self addChild:mArrow z:1];
        
        self.mLine = [CCSprite spriteWithFile:@"line.png"];
        self.mLine.position = ccp(-20, self.contentSize.height/2);
        self.mLine.scale = 1.25;
        [self addChild:self.mLine];
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
        [self.mDelegate LanchWithForce:ccp(tmpPt.x*PL_LANCH_FORCE_DELTA, tmpPt.y*PL_LANCH_FORCE_DELTA) withPt:self.position withPlayerType:self.mPlayerType];
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
    CGFloat maxDist = self.contentSize.width/2;
    if (dist > maxDist) {
        CGFloat x = center.x + maxDist * pt.x;
        CGFloat y = center.y + maxDist * pt.y;
        ballPt = ccp(x, y);
        dist = maxDist;
    }

    mArrow.rotation = -180*angle/M_PI;
    mArrow.scaleX = 1+(dist*0.06);
    mLanchBall.position = ballPt;
}

-(void)setMLanchAble:(BOOL)mLanchAble
{
    if (_mLanchAble == mLanchAble) {
        return;
    }
    
    if ([CURGAMELAYER IsBallInPlayGround:self]) {
        self.opacity = 180;
    }
    else
    {
        self.opacity = 255;
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
