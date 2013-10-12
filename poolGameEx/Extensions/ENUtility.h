/*
 *  Utility.h
 *  Linfo
 *
 *  Created by yanglei on 09-10-27.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */


//ptr release macro
#define RELEASE_PTR(_ptr_) if((_ptr_) != nil){[_ptr_ release];_ptr_ = nil;}

//null judge
#define _NULL_JUDGE_(_ptr_) ((_ptr_) != nil && (NSNull*)(_ptr_) != [NSNull null]) 

#define _NULL_(_ptr_) (_ptr_) == nil || (NSNull*)(_ptr_) == [NSNull null] 

#define centerOfSize(_size) CGPointMake((_size).width/2,(_size).height/2)

#define NSStringFromInteger(integer) [NSString stringWithFormat:@"%d", integer]

