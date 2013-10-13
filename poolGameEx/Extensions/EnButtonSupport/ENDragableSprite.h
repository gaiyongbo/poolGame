//
//  ENDragableSprite.h
//  poolGameEx
//
//  Created by 郭 健 on 13-10-11.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import "ENTouchableNode.h"


@protocol DragableDelegate <NSObject>

-(void)DragBegin:(CCNode*)sender;
-(void)Draging:(CCNode*)sender;
-(void)DragEnd:(CCNode*)sender;

@optional
-(void)TouchUpinside:(CCNode*)sender;
@end


@interface ENDragableSprite : ENTouchableNode
{
	BOOL                            mTouchInProgress;
	bool                            mScaleOnPush;
    
    CGFloat                         mDragDist;
    
    CGPoint                         mOriginPosition;
	
    
    
    CGFloat                         mOriginScale;
}

@property(nonatomic,retain)CCSprite*                       mSprite;
@property(nonatomic,assign)id<DragableDelegate>            mDelegate;

+(id)DragableSpriteWithSprite:(CCSprite*)sprite;
-(id)InitWithSprite:(CCSprite*)sprite;
@end
