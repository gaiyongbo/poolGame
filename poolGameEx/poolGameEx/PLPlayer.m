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
        self.mBallCount = 5;
    }
    
    return self;
}

-(void)dealloc
{
    
    [super dealloc];
}
@end
