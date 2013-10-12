//
//  PLPlayer.m
//  poolGameEx
//
//  Created by 郭 健 on 13-10-12.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import "PLPlayer.h"

@implementation PLPlayer
-(id)init
{
    self = [super init];
    if (self) {
        self.mBalls = [NSMutableArray arrayWithCapacity:4];
    }
    
    return self;
}

-(void)dealloc
{
    self.mBalls = nil;
    
    [super dealloc];
}
@end
