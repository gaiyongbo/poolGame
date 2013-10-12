//
//  HelloWorldLayer.mm
//  poolGameEx
//
//  Created by 盖 永波 on 13-10-9.
//  Copyright ggvggv 2013年. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"

// Not included in "cocos2d.h"
#import "CCPhysicsSprite.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "ENDragableSprite.h"

#import "PLPlayer.h"
#import "PLBallSprite.h"


#pragma mark - HelloWorldLayer

@interface HelloWorldLayer()
-(void) initPhysics;
-(void) createMenu;
@end

@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ball.plist"];

        self.playerArray = [NSMutableArray arrayWithCapacity:4];
        for (int i = 0; i < 4; i++) {
            PLPlayer *player = [[[PLPlayer alloc] init] autorelease];
            player.mType = (PLPlayerType)i;
            [self.playerArray addObject:player];
        }
        
        //创建可滚动的层
	     _panZoomLayer = [[PLCustomPanZoom node] retain];
        //_panZoomLayer.anchorPoint = ccp(0,0);
        [self addChild:_panZoomLayer];
        _panZoomLayer.delegate = self;
       
        //添加背景
        /*CCSprite *background = [CCSprite spriteWithFile: @"background.png"];
        background.anchorPoint = ccp(0,0);
		background.scale = CC_CONTENT_SCALE_FACTOR();
        [self addChild: background
                             z :1
                            tag: kBackgroundTag];*/
        
        //设置属性
        CGSize s = [CCDirector sharedDirector].winSize;
        
        _panZoomLayer.mode = kCCLayerPanZoomModeSheet;
        _panZoomLayer.minScale = 1.0f;
        _panZoomLayer.maxScale = 1.0f;
        _panZoomLayer.rubberEffectRatio = 0.0f;
        _panZoomLayer.panBoundsRect = CGRectMake(0, 0, s.width, s.height);
        [self updateForScreenReshape];
        // enable events
        
        
		self.touchEnabled = YES;
		self.accelerometerEnabled = YES;
		
		
		// init physics
		[self initPhysics];
		
		// create reset button
		//[self createMenu];
		
		//Set up sprite
		
//#if 1
//		// Use batch node. Faster
//		CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"球3.png" capacity:100];
//		spriteTexture_ = [parent texture];
//        
//        [spriteTexture_ setAntiAliasTexParameters];
//#else
//		// doesn't use batch node. Slower
//		spriteTexture_ = [[CCTextureCache sharedTextureCache] addImage:@"球3.png"];
//		CCNode *parent = [CCNode node];
//#endif
        
        CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"ball.pvr.ccz" capacity:100];
        [parent.texture setAntiAliasTexParameters];
		[_panZoomLayer addChild:parent z:1 tag:kTagParentNode];
		
		[self initGame];
		
		[self scheduleUpdate];
        
//        CCSprite *tt = [CCSprite spriteWithFile:@"Icon.png"];
//        ENDragableSprite *ss = [ENDragableSprite DragableSpriteWithSprite:tt];
//        ss.mSwallowTouches = YES;
//        ss.mTouchPriority = kCCMenuHandlerPriority - 100;
//        ss.position = centerOfSize(_panZoomLayer.contentSize);
//        [_panZoomLayer addChild:ss];
	}
	return self;
}

- (void) initGame
{
    //画框区
    
    CGSize s = [CCDirector sharedDirector].winSize;
    
    int starty = s.height*SIZE_RATIO*0.5 + FRAME_SIZE*0.5;
    int stepx =   FRAME_SIZE/4;
    int stepy = FRAME_SIZE/5;
    
    CCLayerColor *bgLayer = [CCLayerColor layerWithColor:ccc4(255, 0, 0, 200) width:FRAME_SIZE height:FRAME_SIZE];
    bgLayer.position = ccp(FRAME_X_POS, starty);
    bgLayer.ignoreAnchorPointForPosition = NO;
    bgLayer.anchorPoint = ccp(0, 1);
    [_panZoomLayer addChild:bgLayer z:0];
    playerGround = bgLayer;
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 4; j ++) {
            CGPoint pt = ccp(FRAME_X_POS + stepx*(i + 1), starty - stepy*(j + 1));
            [self addNewSpriteAtPosition:pt];
        }
    }
}

-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
	[super dealloc];
}	

-(void) createMenu
{
	// Default font size will be 22 points.
	[CCMenuItemFont setFontSize:22];
	
	// Reset Button
	CCMenuItemLabel *reset = [CCMenuItemFont itemWithString:@"Reset" block:^(id sender){
		[[CCDirector sharedDirector] replaceScene: [HelloWorldLayer scene]];
	}];

	// to avoid a retain-cycle with the menuitem and blocks
	__block id copy_self = self;

	// Achievement Menu Item using blocks
	CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
		
		
		GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
		achivementViewController.achievementDelegate = copy_self;
		
		AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
		
		[[app navController] presentModalViewController:achivementViewController animated:YES];
		
		[achivementViewController release];
	}];
	
	// Leaderboard Menu Item using blocks
	CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
		
		
		GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
		leaderboardViewController.leaderboardDelegate = copy_self;
		
		AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
		
		[[app navController] presentModalViewController:leaderboardViewController animated:YES];
		
		[leaderboardViewController release];
	}];
	
	CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, reset, nil];
	
	[menu alignItemsVertically];
	
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/2, size.height/2)];
	
	
	[self addChild: menu z:-1];	
}

-(void) initPhysics
{
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, 0.0f);
	world = new b2World(gravity);
	
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
    _contactListener = new PLContactListener();
	world->SetContactListener(_contactListener);
	world->SetContinuousPhysics(true);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
    uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
//		flags += b2Draw::e_jointBit;
//		flags += b2Draw::e_aabbBit;
//		flags += b2Draw::e_pairBit;
//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);
	
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;		
	
	// bottom
	
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width*SIZE_RATIO/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,s.height*SIZE_RATIO/PTM_RATIO), b2Vec2(s.width*SIZE_RATIO/PTM_RATIO,s.height*SIZE_RATIO/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0,s.height*SIZE_RATIO/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(s.width*SIZE_RATIO/PTM_RATIO,s.height*SIZE_RATIO/PTM_RATIO), b2Vec2(s.width*SIZE_RATIO/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();	
	
	kmGLPopMatrix();
}

-(void)ApplyLinearImpulseSprite:(CCPhysicsSprite*)sprite withForce:(b2Vec2)force withPt:(b2Vec2)pt
{
    b2Body *body = [sprite b2Body];
    body->ApplyLinearImpulse(force,body->GetPosition());
}

-(b2Body*)CreateBodyAtPosition:(CGPoint)p
{
    CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
    bodyDef.angularDamping = 0.5f;
    bodyDef.linearDamping = 0.7f;
	
	bodyDef.type = b2_dynamicBody;
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
    b2CircleShape  dynamicCircle;
    dynamicCircle.m_radius = 12.0/PTM_RATIO;
    
    //b2PolygonShape dynamicCircle;
    //dynamicCircle.SetAsBox(0.5, 0.5);
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicCircle;
	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.5f;
    fixtureDef.restitution = 1.0f;
    
	body->CreateFixture(&fixtureDef);
    
    return body;
}

-(CCPhysicsSprite*)createSpriteAtPosition:(CGPoint)p
{
    CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
    bodyDef.angularDamping = 0.5f;
    bodyDef.linearDamping = 0.7f;
	
	bodyDef.type = b2_dynamicBody;
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
    b2CircleShape  dynamicCircle;
    dynamicCircle.m_radius = 12.0/PTM_RATIO;
    
    //b2PolygonShape dynamicCircle;
    //dynamicCircle.SetAsBox(0.5, 0.5);
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicCircle;
	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.5f;
    fixtureDef.restitution = 1.0f;
    
	body->CreateFixture(&fixtureDef);
    
    NSInteger index = arc4random()%4;
    body->SetUserData([self.playerArray objectAtIndex:index]);
    NSString *spriteFrameName = [NSString stringWithFormat:@"ball_%d.png", index];
    
    CCPhysicsSprite *sprite = [CCPhysicsSprite spriteWithSpriteFrameName:spriteFrameName];
	
	[sprite setPTMRatio:PTM_RATIO];
	[sprite setB2Body:body];
	[sprite setPosition: ccp( p.x, p.y)];
    
    return sprite;
}

-(void)addNewSpriteAtPosition:(CGPoint)p withForce:(b2Vec2)force
{
    CCNode *parent = [_panZoomLayer getChildByTag:kTagParentNode];
    
    b2Body *body = [self CreateBodyAtPosition:p];
    NSInteger index = arc4random()%4;
    PLBallSprite *sprite = [PLBallSprite BallSpriteWithPlayer:[self.playerArray objectAtIndex:index] withBody:body];
    sprite.mIsCurrent = YES;
    [parent addChild:sprite];
    
    body->ApplyLinearImpulse(force,body->GetPosition());
}

-(void) addNewSpriteAtPosition:(CGPoint)p
{
    CCNode *parent = [_panZoomLayer getChildByTag:kTagParentNode];

    b2Body *body = [self CreateBodyAtPosition:p];
    NSInteger index = arc4random()%4;
    PLBallSprite *sprite = [PLBallSprite BallSpriteWithPlayer:[self.playerArray objectAtIndex:index] withBody:body];
    [parent addChild:sprite];
}

-(void) update: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
    
    NSMutableArray *needRemoveBalls = [NSMutableArray array];

    BOOL haveAwakeBody = NO;
    for(b2Body* b = world->GetBodyList(); b && b->GetType() == b2_dynamicBody; b = b->GetNext())
    {
        b2Vec2 velo = b->GetLinearVelocity();
        if (ABS(velo.x) < 0.1 && ABS(velo.y) < 0.1) {
            b->SetAwake(NO);
        }
        
        
        if (!b->IsAwake() && b->GetUserData())
        {
            PLBallSprite *sprite = (PLBallSprite*)b->GetUserData();
            if (sprite && [sprite isKindOfClass:[PLBallSprite class]]) {
                sprite.mIsCurrent = NO;
                if (!CGRectIntersectsRect(playerGround.boundingBox, sprite.boundingBox)) {
                    [needRemoveBalls addObject:sprite];
                }
            }
        }
        
        haveAwakeBody = haveAwakeBody || b->IsAwake();
    }
    
    for (PLBallSprite *ball in needRemoveBalls) {
        world->DestroyBody([ball b2Body]);
        CCSequence *seq = [CCSequence actionOne:[CCScaleTo actionWithDuration:0.3 scale:0.1] two:[CCCallBlockN actionWithBlock:^(CCNode *node) {
            [node removeFromParentAndCleanup:YES];
            [ball.mPlayer.mBalls removeObject:ball];
        }]];
        [ball runAction:seq];
    }
    
    if (haveAwakeBody) {
//        NSLog(@"Have Awake Body!");
    }
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);	
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
//		CGPoint location = [touch locationInView: [touch view]];
		
//		location = [[CCDirector sharedDirector] convertToGL: location];
        CGPoint location = [_panZoomLayer convertTouchToNodeSpace:touch];
		
        CGFloat xForce = -(arc4random()%50 * 0.1 + 5);
        CGFloat yForce = 5 - (arc4random()%100 * 0.1);
		[self addNewSpriteAtPosition:location withForce:b2Vec2(xForce,yForce)];
	}
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

- (void) layerPanZoom: (CCLayerPanZoom *) sender
	   clickedAtPoint: (CGPoint) point
             tapCount: (NSUInteger) tapCount
{
	NSLog(@"CCLayerPanZoomTestLayer#layerPanZoom: %@ clickedAtPoint: { %f, %f }", sender, point.x, point.y);
}
-(CGRect)AtlasRect:(CCSprite *)atlSpr
{
    CGRect rc = [atlSpr textureRect];
    return CGRectMake( - rc.size.width / 2, -rc.size.height / 2, rc.size.width, rc.size.height);
}


- (void) layerPanZoom: (CCLayerPanZoom *) sender
 touchPositionUpdated: (CGPoint) newPos
{
    NSLog(@"CCLayerPanZoomTestLayer#layerPanZoom: %@ touchPositionUpdated: { %f, %f }", sender, newPos.x, newPos.y);
}

- (void) layerPanZoom: (CCLayerPanZoom *) sender touchMoveBeganAtPosition: (CGPoint) aPoint
{
    NSLog(@"CCLayerPanZoomTestLayer#layerPanZoom: %@ touchMoveBeganAtPosition: { %f, %f }", sender, aPoint.x, aPoint.y);
}

- (void) updateForScreenReshape
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	CCNode *background = _panZoomLayer;
	// our bounding rect
	CGRect boundingRect = CGRectMake(0, 0, 0, 0);
	boundingRect.size = [background boundingBox].size;
	[_panZoomLayer setContentSize: boundingRect.size];
    
	_panZoomLayer.anchorPoint = ccp(0.5f, 0.5f);
	_panZoomLayer.position = ccp(0.5f * winSize.width, 0.5f * winSize.height);
    
    _panZoomLayer.panBoundsRect = CGRectMake(0, 0, winSize.width, winSize.height);
    
}



@end
