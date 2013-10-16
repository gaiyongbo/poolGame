//
//  PLScoreBoardLayer.m
//  poolGameEx
//
//  Created by 郭 健 on 13-10-13.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import "PLScoreBoardLayer.h"
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"

@implementation PLScoreBoardLayer

-(id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddScoreForCollision:) name:COLLISION_NOTIFY object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddScoreForKnockout:) name:KNOCKOUT_NOTIFY object:nil];

        curPlayerInfoLabel = [CCLabelTTF labelWithString:@"" fontName:MF_FONT fontSize:15];
        curPlayerInfoLabel.anchorPoint = ccp(0, 1);
        curPlayerInfoLabel.position = ccp(150, self.contentSize.height - 12);
        [self addChild:curPlayerInfoLabel];
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    [[SimpleAudioEngine sharedEngine] playEffect:@"aeffect.mp3"];
    [self scheduleUpdate];
}

-(void)onExit
{
    [super onExit];
    
    [self unscheduleUpdate];
}

-(void)update:(ccTime)delta
{
    [self UPdateCurPlayerInfo];
}

-(void)UPdateCurPlayerInfo
{
    NSString *info = @"";

    PLPlayer *curPlayer = [CURGAMELAYER.playerArray objectAtIndex:CURGAMELAYER.roundCtrl.mCurPlayerIndex];
    info = [NSString stringWithFormat:@"玩家：%d      剩余：%d      得分：%d",
            CURGAMELAYER.roundCtrl.mCurPlayerIndex+1,
            curPlayer.mBallCount,
            curPlayer.mScore];
    
    curPlayerInfoLabel.string = info;
}

-(void)AddScoreForCollision:(NSNotification*)notify
{
    PLBallSprite *targetBall = notify.object;
    targetBall.mPlayer.mScore += 1;
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"+1" fontName:MF_FONT fontSize:15];
    label.color = ccc3(255, 0, 0);
    label.position = [targetBall convertToWorldSpace:centerOfSize(targetBall.contentSize)];
    [self addChild:label z:3];
    
    CCMoveTo *moveAction = [CCMoveTo actionWithDuration:2 position:ccp(self.contentSize.width/2, self.contentSize.height)];
    CCCallBlockN *call = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    
    [label runAction:[CCSequence actionOne:moveAction two:call]];
    
    CCParticleSystemQuad *hitParticle = [[CCParticleSystemQuad particleWithFile:@"hitInMap.plist"] retain];
    hitParticle.positionType = kCCPositionTypeRelative;
    hitParticle.position = label.position;
    [self addChild:hitParticle];
    
    CCDelayTime *delay = [CCDelayTime actionWithDuration:1];
    call = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    
    [hitParticle runAction:[CCSequence actionOne:delay two:call]];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"aeffect.mp3"];
}

-(void)AddScoreForKnockout:(NSNotification*)notify
{
    PLBallSprite *targetBall = notify.object;
    targetBall.mPlayer.mScore += 100;
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"+100" fontName:MF_FONT fontSize:15];
    label.color = ccc3(255, 0, 0);
    label.position = [targetBall convertToWorldSpace:centerOfSize(targetBall.contentSize)];
    [self addChild:label z:3];
    
    CCMoveTo *moveAction = [CCMoveTo actionWithDuration:2 position:ccp(self.contentSize.width/2, self.contentSize.height)];
    CCCallBlockN *call = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    
    [label runAction:[CCSequence actionOne:moveAction two:call]];
    
    CCParticleSystemQuad *hitParticle = [[CCParticleSystemQuad particleWithFile:@"hitInMap.plist"] retain];
    hitParticle.positionType = kCCPositionTypeRelative;
    hitParticle.position = label.position;
    [self addChild:hitParticle];
    
    CCDelayTime *delay = [CCDelayTime actionWithDuration:1];
    call = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    
    [hitParticle runAction:[CCSequence actionOne:delay two:call]];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"aeffect.mp3"];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}
@end
