//
//  ENButton.h
//  poolGameEx
//
//  Created by 郭 健 on 13-10-14.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import "ENTouchableNode.h"

@interface ENButton : ENTouchableNode
{
    BOOL            touchInProgress;
    BOOL            buttonWasDown;
    
    id              target;
	SEL             selector;
}
@property(nonatomic,readwrite,retain)CCNode*    touchablePortion;
@property(nonatomic)BOOL                        isEnable;


+(id)ButtonWithTouchablePortion:(CCNode*)node target:(id)target selector:(SEL)selector;
-(id)InitWithTouchablePortion:(CCNode*)node target:(id)target selector:(SEL)selector;
@end
