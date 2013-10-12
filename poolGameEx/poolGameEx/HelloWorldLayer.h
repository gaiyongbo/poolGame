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
//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.


// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate,CCLayerPanZoomClickDelegate>
{
	CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
    PLCustomPanZoom *_panZoomLayer;
    PLContactListener *_contactListener;
   
}
@property (nonatomic,assign) NSMutableArray  *ballList;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
