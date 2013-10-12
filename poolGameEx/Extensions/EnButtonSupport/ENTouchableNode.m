//
//  ENTouchableNode.m
//  poolGameEx
//
//  Created by 郭 健 on 13-10-11.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import "ENTouchableNode.h"

@implementation ENTouchableNode

-(id)init
{
    self = [super init];
    if (self) {
        _mSwallowTouches = NO;
        _mIsTouchEnable = YES;
        _mTouchPriority = kCCMenuHandlerPriority;
        mRegisteredWithDispatcher = NO;
    }
    return self;
}

- (void) dealloc
{
	[self UnregisterWithTouchDispatcher];
	
	[super dealloc];
}

-(void) RegisterWithTouchDispatcher
{
	[self UnregisterWithTouchDispatcher];
	
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:self.mTouchPriority swallowsTouches:self.mSwallowTouches];
    mRegisteredWithDispatcher = YES;
}

- (void) UnregisterWithTouchDispatcher
{
	if(mRegisteredWithDispatcher)
	{
		[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
		mRegisteredWithDispatcher = NO;
	}
}

-(void)setMSwallowTouches:(BOOL)mSwallowTouches
{
	if(_mSwallowTouches != mSwallowTouches)
	{
		_mSwallowTouches = mSwallowTouches;
		
		if(_isRunning && _mIsTouchEnable)
		{
			[self RegisterWithTouchDispatcher];
		}
	}
}

-(void)setMTouchPriority:(NSInteger)mTouchPriority
{
	if(_mTouchPriority != mTouchPriority)
	{
		_mTouchPriority = mTouchPriority;
		if(_isRunning && _mIsTouchEnable)
		{
			[self RegisterWithTouchDispatcher];
		}
	}
}

-(void)setMIsTouchEnable:(BOOL)mIsTouchEnable
{
	if(_mIsTouchEnable != mIsTouchEnable)
	{
		_mIsTouchEnable = mIsTouchEnable;
		if(_isRunning)
		{
			if( _mIsTouchEnable )
			{
				[self RegisterWithTouchDispatcher];
			}
			else
			{
				[self UnregisterWithTouchDispatcher];
			}
		}
	}
}

- (void)cleanup
{
	self.mIsTouchEnable = NO;
}

#pragma mark TouchableNode - Callbacks
-(void) onEnter
{
	if (_mIsTouchEnable)
	{
		[self RegisterWithTouchDispatcher];
	}
	
	[super onEnter];
}

-(void) onExit
{
	if(_mIsTouchEnable)
	{
		[self UnregisterWithTouchDispatcher];
	}
	
	[super onExit];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(NO, @"TouchableNode#ccTouchBegan override me");
	return YES;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSAssert(NO, @"TouchableNode#ccTouchesBegan override me");
}

-(BOOL)TouchHitsSelf:(UITouch*) touch
{
	return [self Touch:touch hitsNode:self];
}

-(BOOL)Touch:(UITouch*) touch hitsNode:(CCNode*) node
{
	CGRect r = CGRectMake(0, 0, node.contentSize.width, node.contentSize.height);
	CGPoint local = [node convertTouchToNodeSpace:touch];
	
	return CGRectContainsPoint(r, local);
}

@end
