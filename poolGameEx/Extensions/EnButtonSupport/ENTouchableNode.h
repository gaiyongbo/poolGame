//
//  ENTouchableNode.h
//  poolGameEx
//
//  Created by 郭 健 on 13-10-11.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import "cocos2d.h"
#import "CCNode.h"


@interface ENTouchableNode : CCNode<CCTouchOneByOneDelegate>
{
    BOOL                            mRegisteredWithDispatcher;
}

@property(nonatomic)BOOL            mIsTouchEnable;
@property(nonatomic)NSInteger       mTouchPriority;
@property(nonatomic)BOOL            mSwallowTouches;

-(BOOL)TouchHitsSelf:(UITouch*) touch;
-(BOOL)Touch:(UITouch*) touch hitsNode:(CCNode*) node;
@end
