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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowCurPlayerTip:) name:SHOW_CUR_PLAYER_TIP object:nil];
        
        curPlayerName = [CCLabelTTF labelWithString:@"" fontName:MF_FONT fontSize:18];
        curPlayerName.position = ccp(150, self.contentSize.height - 20);
        curPlayerName.color = ccORANGE;
        [self addChild:curPlayerName];
        
        curPlayerBallCount = [CCLabelTTF labelWithString:@"" fontName:MF_FONT fontSize:15];
        curPlayerBallCount.position = ccp(250, self.contentSize.height - 20);
        curPlayerBallCount.color = ccMAGENTA;
        [self addChild:curPlayerBallCount];
        
        curPlayerScore = [CCLabelTTF labelWithString:@"" fontName:MF_FONT fontSize:15];
        curPlayerScore.position = ccp(350, self.contentSize.height - 20);
        curPlayerScore.color = ccRED;
        [self addChild:curPlayerScore];
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
    PLPlayer *curPlayer = [CURGAMELAYER.playerArray objectAtIndex:CURGAMELAYER.roundCtrl.mCurPlayerIndex];
    
    curPlayerName.string = [kPlayerNames objectAtIndex:CURGAMELAYER.roundCtrl.mCurPlayerIndex];
    curPlayerBallCount.string = [NSString stringWithFormat:@"剩余：%d", curPlayer.mBallCount];
    curPlayerScore.string = [NSString stringWithFormat:@"得分：%d", curPlayer.mScore];
}

-(void)AddScoreForCollision:(NSNotification*)notify
{
    PLBallSprite *targetBall = notify.object;
    targetBall.mPlayer.mScore += 10;
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"+10" fontName:MF_FONT fontSize:15];
    label.color = ccc3(255, 0, 0);
    label.position = [targetBall convertToWorldSpace:centerOfSize(targetBall.contentSize)];
    [self addChild:label z:3];
    
    CCMoveTo *moveAction = [CCMoveTo actionWithDuration:2 position:curPlayerScore.position];
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
    
    CCMoveTo *moveAction = [CCMoveTo actionWithDuration:2 position:curPlayerScore.position];
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

-(void)ShowCurPlayerTip:(NSNotification*)notify
{
    NSString *playerName = [kPlayerNames objectAtIndex:[notify.object integerValue]];
    CCLabelTTF *tipLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@ 击打", playerName] fontName:MF_FONT fontSize:50];
    tipLabel.color = ccORANGE;
    tipLabel.position = centerOfSize(self.contentSize);
    tipLabel.scale = 0.01;
    [self addChild:tipLabel];
    
    CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:1 scale:1.5];
    CCFadeOut *fadeAction = [CCFadeOut actionWithDuration:0.5];
    CCCallBlockN *endCall = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    
    [tipLabel runAction:[CCSequence actions:scaleAction, fadeAction, endCall, nil]];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}
@end
