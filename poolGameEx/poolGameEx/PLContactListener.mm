//
//  PLContactListener.cpp
//  poolGameEx
//
//  Created by 盖 永波 on 13-10-11.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#include "PLContactListener.h"
#include "cocos2d.h"
void PLContactListener::BeginContact(b2Contact* contact)
{
    b2Body* bodyA = contact->GetFixtureA()->GetBody();
    b2Body* bodyB = contact->GetFixtureB()->GetBody();
    CCSprite* spriteA = (CCSprite*)bodyA->GetUserData();
    CCSprite* spriteB = (CCSprite*)bodyB->GetUserData();
    
    if (spriteA.tag == kStartBallTag || spriteB.tag == kStartBallTag) {
        //得分
        NSLog(@"get 1 point");
    }
}


void PLContactListener::EndContact(b2Contact* contact)
{
    
}