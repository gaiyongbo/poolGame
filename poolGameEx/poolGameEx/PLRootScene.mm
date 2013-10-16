//
//  PLRootLayer.m
//  poolGameEx
//
//  Created by 郭 健 on 13-10-15.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import "PLRootScene.h"
#import "ENButton.h"
#import "HelloWorldLayer.h"

@implementation PLRootScene

-(id)init
{
    self = [super init];
    if (self) {
        CCSprite *bg = [CCSprite spriteWithSpriteFrameName:@"head_bg.png"];
        bg.position = centerOfSize(self.contentSize);
        [self addChild:bg];
        
        ENButton *btn = [ENButton ButtonWithTouchablePortion:[CCSprite spriteWithSpriteFrameName:@"danren_play_btn.png"] target:self selector:@selector(StartGame)];
        btn.position = ccp(150, 80);
        [bg addChild:btn];
        
        btn = [ENButton ButtonWithTouchablePortion:[CCSprite spriteWithSpriteFrameName:@"duoren_play_btn.png"] target:self selector:@selector(StartGame)];
        btn.position = ccp(330, 80);
        [bg addChild:btn];
        
        btn = [ENButton ButtonWithTouchablePortion:[CCSprite spriteWithSpriteFrameName:@"shezhi_btn.png"] target:nil selector:nil];
        btn.position = ccp(bg.contentSize.width - 10, 10);
        btn.anchorPoint = ccp(1, 0);
        [bg addChild:btn];
    }
    
    return self;
}

-(void)StartGame
{
    [[CCDirector sharedDirector] pushScene:[HelloWorldLayer scene]];
}

@end
