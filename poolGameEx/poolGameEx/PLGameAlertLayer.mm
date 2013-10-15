//
//  PLGameAlertLayer.m
//  poolGameEx
//
//  Created by 郭 健 on 13-10-15.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import "PLGameAlertLayer.h"
#import "HelloWorldLayer.h"

@implementation PLGameAlertLayer

-(void)onEnter
{
    [super onEnter];
    
    self.touchEnabled = YES;
    
    ENButton *bg = [ENButton ButtonWithTouchablePortion:[CCLayer node] target:self selector:@selector(dismiss)];
    bg.anchorPoint = bg.position = ccp(0, 0);
    [self addChild:bg];
    
    mBgSprite = [CCSprite spriteWithSpriteFrameName:@"alert_bg.png"];
    mBgSprite.position = centerOfSize(self.contentSize);
    [self addChild:mBgSprite];
    
    CGFloat offsetX = 50;
    CGFloat offsetY = mBgSprite.contentSize.height - 30;
    
    for (int i = 0; i < CURGAMELAYER.playerArray.count; i++) {
        PLPlayer *player = [CURGAMELAYER.playerArray objectAtIndex:i];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"玩家 %d 得分：%d", player.mType, player.mScore] fontName:MF_FONT fontSize:13];
        label.anchorPoint = ccp(0, 0);
        label.position = ccp(offsetX, offsetY);
        [mBgSprite addChild:label];
        offsetY -= 30;
    }
    
    ENButton *btn = [ENButton ButtonWithTouchablePortion:[CCSprite spriteWithSpriteFrameName:@"home.png"] target:self selector:@selector(HomePressed)];
    btn.position = ccp(60, 10);
    btn.anchorPoint = ccp(0, 0);
    [mBgSprite addChild:btn];
    
    btn = [ENButton ButtonWithTouchablePortion:[CCSprite spriteWithSpriteFrameName:@"refresh.png"] target:self selector:@selector(RefreshPressed)];
    btn.position = ccp(130, 10);
    btn.anchorPoint = ccp(0, 0);
    [mBgSprite addChild:btn];
}

-(void)onExit
{
    [super onExit];
    
    [mBgSprite removeFromParentAndCleanup:YES];
}

-(void)dismiss
{
    [self removeFromParentAndCleanup:YES];
}
@end
