//
//  PLGameDataManager.h
//  poolGameEx
//
//  Created by 盖 永波 on 13-10-12.
//  Copyright (c) 2013年 ggvggv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLGameDataManager : NSObject

@property(nonatomic,retain)NSNumber *score;

+(PLGameDataManager*)sharedDataManager;

- (void)reset;
@end
