//
//  PLLanchCycleSprite.h
//  poolGameEx
//
//  Created by 郭 健 on 13-10-12.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import "CCSprite.h"
#import "ENDragableSprite.h"

@protocol PLLanchCycleDelegate <NSObject>

-(void)LanchWithForce:(CGPoint)force withPt:(CGPoint)pt;

@end

@interface PLLanchCycleSprite : CCSprite<DragableDelegate>
{
    ENDragableSprite            *mLanchBall;
    CCSprite                    *mArrow;
}

@property(nonatomic,assign)id<PLLanchCycleDelegate> mDelegate;
@property(nonatomic)BOOL mLanchAble;
+(id)LanchCycleSprite;
-(id)InitLanchCycleSprite;
@end
