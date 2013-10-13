//
//  PLPlayer.h
//  poolGameEx
//
//  Created by 郭 健 on 13-10-12.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    PLPlayerType0 = 0,
    PLPlayerType1,
    PLPlayerType2,
    PLPlayerType3
}PLPlayerType;
@interface PLPlayer : NSObject

@property(nonatomic)PLPlayerType            mType;
@property(nonatomic)NSInteger               mBallCount;
@property(nonatomic)NSInteger               mScore;
@property(nonatomic,retain)NSMutableArray   *mBalls;
@end
