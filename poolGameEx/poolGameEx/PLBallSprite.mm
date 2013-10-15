//
//  PLBallSprite.m
//  poolGameEx
//
//  Created by 郭 健 on 13-10-12.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import "PLBallSprite.h"
#import "HelloWorldLayer.h"
#import "ENButton.h"

@implementation PLBallSprite

@synthesize mIsCurrent;
+(id)BallSpriteWithPlayer:(PLPlayer *)player withBody:(b2Body *)body
{
    return [[[PLBallSprite alloc] InitWithPlayer:player withBody:body] autorelease];
}

-(id)InitWithPlayer:(PLPlayer *)player withBody:(b2Body *)body
{
    NSString *spriteFrameName = [NSString stringWithFormat:@"ball_%d.png", player.mType];
    
    self = [super initWithSpriteFrameName:spriteFrameName];
    if (self) {
        self.mIsCurrent = NO;
        self.mPlayer = player;
        self.mPrevStatus = PLBallStatusIn;
        
        [self setPTMRatio:PTM_RATIO];
        [self setB2Body:body];
        [self setPosition: ccp(body->GetPosition().x * PTM_RATIO, body->GetPosition().y * PTM_RATIO)];
        body->SetUserData(self);
        
        [CURGAMELAYER.ballArray addObject:self];
        
        CCSprite *tmp = [CCSprite node];
        tmp.contentSize = CGSizeMake(self.contentSize.width * 3, self.contentSize.height * 3);
        ENButton *btn = [ENButton ButtonWithTouchablePortion:tmp target:self selector:@selector(BtnPressed)];
        btn.position = centerOfSize(self.contentSize);
        btn.anchorPoint = ccp(0.5, 0.5);
        [self addChild:btn];
    }

    return self;

}

-(void)BtnPressed
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SELECT_BALL_NOTIFY object:self];
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
    b2Vec2 velo = self.b2Body->GetLinearVelocity();
    if (ABS(velo.x) < 0.1 && ABS(velo.y) < 0.1) {
        self.b2Body->SetAwake(NO);
    }
    
    if (self.b2Body->IsAwake()) {
        self.mStatus = PLBallStatusMoving;
    }
    else if ([CURGAMELAYER IsBallInPlayGround:self])
    {
        self.mStatus = PLBallStatusIn;
    }
    else
    {
        self.mStatus = PLBallStatusOut;
    }

    if (self.mStatus != PLBallStatusMoving) {
        self.mIsCurrent = NO;
    }
}

-(BOOL)mIsKnockout
{
    _mIsKnockout = (self.mStatus == PLBallStatusOut && self.mPrevStatus == PLBallStatusIn)
                    || (self.mStatus == PLBallStatusOut && self.mPlayer.mType == CURGAMELAYER.roundCtrl.mCurPlayerIndex);
    return _mIsKnockout;
}

-(void)Impulse:(CGPoint)force
{
    self.mPrevStatus = PLBallStatusOut;
    self.mIsCurrent = YES;
    b2Body *body = [self b2Body];
    body->ApplyLinearImpulse(b2Vec2(force.x, force.y),body->GetPosition());
}

-(void)SetSelectable
{
    self.mPlayer = [CURGAMELAYER.playerArray objectAtIndex:CURGAMELAYER.roundCtrl.mCurPlayerIndex];
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"ball_%d.png", self.mPlayer.mType]]];
    CCRepeatForever *action = [CCRepeatForever actionWithAction:[CCSequence actionOne:[CCScaleTo actionWithDuration:0.5 scale:0.6] two:[CCScaleTo actionWithDuration:0.5 scale:1]]];
    [self runAction:action];
}

-(void)RemoveWithAddScore:(BOOL)flag
{
    if (flag) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOCKOUT_NOTIFY object:self];
    }
    [CURGAMELAYER DestroyBall:self];
}

-(void)CheckPrevStatus
{
    self.mPrevStatus = [CURGAMELAYER IsBallInPlayGround:self] ? PLBallStatusIn : PLBallStatusOut;
}

-(void)dealloc
{
    self.mPlayer = nil;
    
    [super dealloc];
}
@end
