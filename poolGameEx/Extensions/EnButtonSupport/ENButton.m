//
//  ENButton.m
//  poolGameEx
//
//  Created by 郭 健 on 13-10-14.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import "ENButton.h"

@implementation ENButton

+(id)ButtonWithTouchablePortion:(CCNode*)node target:(id)target selector:(SEL)selector
{
    return [[[ENButton alloc] InitWithTouchablePortion:node target:target selector:selector] autorelease];
}

-(id)InitWithTouchablePortion:(CCNode*)node target:(id)targetIn selector:(SEL)selectorIn
{
    self = [super init];
	if(self)
	{
		self.touchablePortion = node;
		
        self.mTouchPriority = kCCMenuHandlerPriority;
		self.mSwallowTouches = YES;
		self.mIsTouchEnable = YES;
		target = targetIn;
		selector = selectorIn;
        self.isEnable = YES;
		
		self.anchorPoint = ccp(0.5f, 0.5f);
	}
	return self;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if(self.isEnable && self.visible && [self Touch:touch hitsNode:self])
	{
        touchInProgress = YES;
        buttonWasDown = YES;
		return YES;
	}
	return NO;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!self.visible) {
        return;
    }
    
	if(touchInProgress)
	{
		if([self Touch:touch hitsNode:self])
		{
			if(!buttonWasDown)
			{
				[self onButtonDown];
			}
		}
		else
		{
			if(buttonWasDown)
			{
				[self onButtonUp];
			}
		}
	}
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!self.visible) {
        return;
    }
    
	if(buttonWasDown)
	{
		[self onButtonUp];
	}
	if(touchInProgress && [self Touch:touch hitsNode:self])
	{
        [self onButtonPressed];
		touchInProgress = NO;
	}
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!self.visible) {
        return;
    }
    
	if(buttonWasDown)
	{
		[self onButtonUp];
	}
	touchInProgress = NO;
}

- (void) onButtonDown
{
	buttonWasDown = YES;
}

- (void) onButtonUp
{
	buttonWasDown = NO;
}

- (void) onButtonPressed
{
    if (target != nil && [target respondsToSelector:selector] && self.isEnable) {
        [target performSelector:selector withObject:self];
    }
}

- (void) setTouchablePortion:(CCNode *) value
{
	if(nil != _touchablePortion)
	{
		[self removeChild:_touchablePortion cleanup:YES];
	}
	_touchablePortion = value;
	[self addChild:_touchablePortion];
	self.contentSize = _touchablePortion.contentSize;
	_touchablePortion.anchorPoint = ccp(0.5,0.5);
	_touchablePortion.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
}


-(void)MakeBigHitArea
{
    CGFloat widht = self.contentSize.width < 40 ? 40 : self.contentSize.width + 10;
    CGFloat height = self.contentSize.height < 40 ? 40 : self.contentSize.height + 10;
    self.contentSize = CGSizeMake(widht, height);
    
    CGPoint center = centerOfSize(self.contentSize);
    for (CCNode *node in self.children) {
        node.position = center;
    }
}

@end
