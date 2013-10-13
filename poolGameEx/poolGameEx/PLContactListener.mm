//
//  PLContactListener.cpp
//  poolGameEx
//
//  Created by 盖 永波 on 13-10-11.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#include "PLContactListener.h"
#include "PLGameDataManager.h"
#include "PLBallSprite.h"

void PLContactListener::BeginContact(b2Contact* contact)
{
    b2Body* bodyA = contact->GetFixtureA()->GetBody();
    b2Body* bodyB = contact->GetFixtureB()->GetBody();
    PLBallSprite* spriteA = (PLBallSprite*)bodyA->GetUserData();
    PLBallSprite* spriteB = (PLBallSprite*)bodyB->GetUserData();
    
    if (spriteA.mIsCurrent && spriteB) {
        //得分
        spriteA.mPlayer.mScore += 1;
        CGPoint worldPt = [spriteA convertToWorldSpace:centerOfSize(spriteA.contentSize)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QQQ" object:NSStringFromCGPoint(worldPt)];
    } else if (spriteB.mIsCurrent && spriteA) {
        spriteB.mPlayer.mScore += 1;
        CGPoint worldPt = [spriteA convertToWorldSpace:centerOfSize(spriteA.contentSize)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QQQ" object:NSStringFromCGPoint(worldPt)];
    }
}


void PLContactListener::EndContact(b2Contact* contact)
{
    
}