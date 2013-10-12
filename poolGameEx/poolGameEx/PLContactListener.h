//
//  PLContactListener.h
//  poolGameEx
//
//  Created by 盖 永波 on 13-10-11.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#ifndef __poolGameEx__PLContactListener__
#define __poolGameEx__PLContactListener__

#include <iostream>
#include "Box2D.h"
class PLContactListener : public b2ContactListener
{
private:
    //碰撞开始
    void BeginContact(b2Contact* contact);
    //碰撞结束
    void EndContact(b2Contact* contact);
};


#endif /* defined(__poolGameEx__PLContactListener__) */
