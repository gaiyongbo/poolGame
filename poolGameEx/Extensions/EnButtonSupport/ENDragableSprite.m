//
//  ENDragableSprite.m
//  poolGameEx
//
//  Created by 郭 健 on 13-10-11.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import "ENDragableSprite.h"

#define kENDragableNodeMinDragDist        10
@implementation ENDragableSprite

+(id)DragableSpriteWithSprite:(CCSprite *)sprite
{
    return [[[ENDragableSprite alloc] InitWithSprite:sprite] autorelease];
}

-(id)InitWithSprite:(CCSprite *)sprite
{
    self = [super init];
    if (self) {
        self.contentSize = sprite.contentSize;
        mSprite = sprite;
        mSprite.position = centerOfSize(self.contentSize);
        [self addChild:mSprite];
    }
    return self;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!self.visible) {
        return NO;
    }
	if([self Touch:touch hitsNode:self])
	{
        mDragDist = 0;
        mOriginPosition = self.position;
		mTouchInProgress = YES;
        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(DragBegin:)]) {
            [self.mDelegate DragBegin:self];
        }
		return YES;
	}
	return NO;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!self.visible) {
        return;
    }
    
	if(mTouchInProgress)
	{
        CGPoint curPt = [touch locationInView:[touch view]];
        CGPoint prePt = [touch previousLocationInView:[touch view]];
        mDragDist += ABS(ccpDistance(curPt, prePt));
        self.position = [self.parent convertTouchToNodeSpace:touch];
        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(Draging:)]) {
            [self.mDelegate Draging:self];
        }
	}
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!self.visible) {
        return;
    }
    
    if (mDragDist >= kENDragableNodeMinDragDist) {
        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(DragEnd:)]) {
            [self.mDelegate DragEnd:self];
        }
    }
    else
    {
        self.position = mOriginPosition;
    }
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!self.visible) {
        return;
    }
    
	mTouchInProgress = NO;
}


@end
