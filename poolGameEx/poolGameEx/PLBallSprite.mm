//
//  PLBallSprite.m
//  poolGameEx
//
//  Created by 郭 健 on 13-10-12.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import "PLBallSprite.h"

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
        
        [self setPTMRatio:PTM_RATIO];
        [self setB2Body:body];
        [self setPosition: ccp(body->GetPosition().x * PTM_RATIO, body->GetPosition().y * PTM_RATIO)];
        body->SetUserData(self);
        
        [self.mPlayer.mBalls addObject:self];
    }

    return self;

}

-(void)dealloc
{
    self.mPlayer = nil;
    
    [super dealloc];
}
@end
