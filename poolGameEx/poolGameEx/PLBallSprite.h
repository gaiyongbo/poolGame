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
#import "ENButton.h"

typedef enum
{
    PLBallStatusIn = 0,
    PLBallStatusMoving,
    PLBallStatusOut
}PLBallStatus;

@interface PLBallSprite : CCPhysicsSprite
{
    ENButton            *mBtn;
}

+(id)BallSpriteWithPlayer:(PLPlayer*)player withBody:(b2Body*)body;
-(id)InitWithPlayer:(PLPlayer*)player withBody:(b2Body*)body;

-(void)Impulse:(CGPoint)force;

-(void)SetSelectable;

-(void)RemoveWithAddScore:(BOOL)flag;

-(void)CheckPrevStatus;

@property(nonatomic,assign)PLPlayer     *mPlayer;
@property(nonatomic)BOOL                mIsCurrent;
@property(nonatomic)PLBallStatus        mStatus;
@property(nonatomic)PLBallStatus        mPrevStatus;
@property(nonatomic)BOOL                mIsKnockout;
@end
