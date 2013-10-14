//
//  HelloWorldLayer.h
//  poolGameEx
//
//  Created by 盖 永波 on 13-10-9.
//  Copyright ggvggv 2013年. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "PLCustomPanZoom.h"
#import "PLContactListener.h"
#import "PLLanchCycleSprite.h"
#import "PLBallSprite.h"
#import "PLRoundCtrl.h"

#define CURGAMELAYER ([HelloWorldLayer CurGameLayer])

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <PLLanchCycleDelegate,GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate,CCLayerPanZoomClickDelegate>
{
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
    PLCustomPanZoom *_panZoomLayer;
    PLContactListener *_contactListener;
    CCLayerColor    *playerGround;
    PLLanchCycleSprite  *lanchCycle;
    CCSpriteBatchNode   *ballBatchNode;
}

@property(nonatomic,retain)NSMutableArray           *playerArray;
@property(nonatomic,retain)NSMutableArray           *ballArray;
@property(nonatomic,retain)PLRoundCtrl              *roundCtrl;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
+(HelloWorldLayer*)CurGameLayer;

-(b2World*)CurWorld;
-(void)DestroyBall:(PLBallSprite*)ball;
-(void)SetLanchCycleWithPType:(PLPlayerType)pType withPt:(CGPoint)pt;
-(BOOL)IsBallInPlayGround:(PLBallSprite*)ball;
@end
