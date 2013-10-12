//
//  PLBallSprite.h
//  poolGameEx
//
//  Created by 郭 健 on 13-10-12.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import "CCPhysicsSprite.h"
#import "PLPlayer.h"
#import "Box2D.h"

@interface PLBallSprite : CCPhysicsSprite
{
    
}

+(id)BallSpriteWithPlayer:(PLPlayer*)player withBody:(b2Body*)body;
-(id)InitWithPlayer:(PLPlayer*)player withBody:(b2Body*)body;

@property(nonatomic,assign)PLPlayer     *mPlayer;
@property(nonatomic)BOOL                mIsCurrent;
@end
