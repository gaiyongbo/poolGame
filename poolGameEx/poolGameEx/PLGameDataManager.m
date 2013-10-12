//
//  PLGameDataManager.m
//  poolGameEx
//
//  Created by 盖 永波 on 13-10-12.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import "PLGameDataManager.h"

@implementation PLGameDataManager

@synthesize score;

+(PLGameDataManager*)sharedDataManager
{
    static PLGameDataManager *_instance = NULL;
    
    if (_instance == NULL) {
        _instance = [[PLGameDataManager alloc] init];
    }
    
    return _instance;
    
}

-(id)init
{
    self = [super init];
    if (self) {
        self.score = [NSNumber numberWithInt:0];
    }
    return  self;
}

- (void)reset
{
    self.score = [NSNumber numberWithInt:0];
}

-(void)dealloc
{
    
    [super dealloc];
}
@end
