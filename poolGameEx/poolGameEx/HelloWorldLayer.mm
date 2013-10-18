//
//  HelloWorldLayer.mm
//  poolGameEx
//
//  Created by 盖 永波 on 13-10-9.
//  Copyright ggvggv 2013年. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"

#import "CCPhysicsSprite.h"
#import "AppDelegate.h"
#import "PLPlayer.h"
#import "PLScoreBoardLayer.h"
#import "ENButton.h"
#import "PLGameAlertLayer.h"

#define kLanchCycleDefaultPt    ccp(_panZoomLayer.contentSize.width - 150, _panZoomLayer.contentSize.height/2)

static HelloWorldLayer *_curGameLayer = nil;
#pragma mark - HelloWorldLayer

@implementation HelloWorldLayer

+(HelloWorldLayer*)CurGameLayer
{
    return _curGameLayer;
}

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
        _curGameLayer = self;

        //创建可滚动的层
	     _panZoomLayer = [[PLCustomPanZoom node] retain];
        //_panZoomLayer.anchorPoint = ccp(0,0);
        [self addChild:_panZoomLayer];
        _panZoomLayer.delegate = self;
        
        CCSprite *bgSprite = [CCSprite spriteWithSpriteFrameName:@"game_bg.png"];
        bgSprite.anchorPoint = ccp(0, 0);
        bgSprite.position = ccp(0, 0);
        [_panZoomLayer addChild:bgSprite];
 
        //设置属性
        CGSize s = [CCDirector sharedDirector].winSize;
        
        _panZoomLayer.mode = kCCLayerPanZoomModeSheet;
        _panZoomLayer.minScale = 1.0f;
        _panZoomLayer.maxScale = 1.0f;
        _panZoomLayer.rubberEffectRatio = 0.0f;
        _panZoomLayer.panBoundsRect = CGRectMake(0, 0, s.width, s.height);
        [self updateForScreenReshape];
        
        [self addChild:[PLScoreBoardLayer node]];

        // enable events
		self.touchEnabled = YES;
		self.accelerometerEnabled = YES;
		
        [self CreateBtns];
		// init physics
		[self initPhysics];
		
		[self initGame];
    }
	return self;
}

-(void)onEnter
{
    [super onEnter];
    
    [self scheduleUpdate];
}

-(void)onExit
{
    [super onExit];
    
    [self unscheduleUpdate];
}

- (void) initGame
{
    
    int starty = SCREEN_HEIGHT*0.5 + FRAME_SIZE*0.5;
    
    CCLayerColor *bgLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 0) width:FRAME_SIZE height:FRAME_SIZE];
    bgLayer.position = ccp(FRAME_X_POS, starty);
    bgLayer.ignoreAnchorPointForPosition = NO;
    bgLayer.anchorPoint = ccp(0, 1);
    [_panZoomLayer addChild:bgLayer z:0];
    
    CCSprite *bgSprite = [CCSprite spriteWithSpriteFrameName:@"playeground_bg.png"];
    bgSprite.position = ccp(bgLayer.position.x + bgLayer.contentSize.width/2 + 7,
                            bgLayer.position.y - bgLayer.contentSize.height/2);
    bgSprite.anchorPoint = ccp(0.5, 0.5);
    bgSprite.scale = 0.8;
    [_panZoomLayer addChild:bgSprite];
    
    playerGround = bgSprite;
    
    lanchCycle = [PLLanchCycleSprite LanchCycleSprite];
    lanchCycle.mDelegate = self;
    lanchCycle.position = kLanchCycleDefaultPt;
    lanchCycle.mLine.visible = YES;
    [_panZoomLayer addChild:lanchCycle z:10];
    
    [self startGame];
}

-(void)startGame
{
    self.playerArray = [NSMutableArray arrayWithCapacity:4];
    self.ballArray = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < 4; i++) {
        PLPlayer *player = [[[PLPlayer alloc] init] autorelease];
        player.mType = (PLPlayerType)i;
        [self.playerArray addObject:player];
    }
    
    if (ballBatchNode) {
        [ballBatchNode removeFromParentAndCleanup:YES];
    }
    
    ballBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"ball.pvr.ccz" capacity:100];
    [ballBatchNode.texture setAntiAliasTexParameters];
    [_panZoomLayer addChild:ballBatchNode z:1];
    
    
    int starty = SCREEN_HEIGHT*0.5 + FRAME_SIZE*0.5;
    int stepx =   FRAME_SIZE/4 - 12;
    int stepy = FRAME_SIZE/5 -12;
    
    NSMutableArray *playerBallArray = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",
                                                                       @"1",@"1",@"1",
                                                                       @"2",@"2",@"2",
                                                                       @"3",@"3",@"3"]];
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 4; j ++) {
            CGPoint pt = ccp(FRAME_X_POS + 30 + stepx*(i + 1), starty - 30  - stepy*(j + 1));
            NSInteger index = arc4random() % playerBallArray.count;
            [self addNewSpriteAtPosition:pt withPlayer:(PLPlayerType)[[playerBallArray objectAtIndex:index] integerValue]];
            [playerBallArray removeObjectAtIndex:index];
        }
    }
    
    self.roundCtrl = [[[PLRoundCtrl alloc] init] autorelease];
}

-(void)LanchWithForce:(CGPoint)force withPt:(CGPoint)pt withPlayerType:(PLPlayerType)pType
{
    PLPlayer *player = [self.playerArray objectAtIndex:pType];
    player.mBallCount -= 1;
    [[self addNewSpriteAtPosition:pt withPlayer:pType] Impulse:force];
}

-(void) dealloc
{
    for (PLBallSprite *ball in self.ballArray) {
        world->DestroyBody(ball.b2Body);
    }
    
    delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
    
    self.playerArray = nil;
    self.ballArray = nil;
    self.roundCtrl = nil;
        	
	[super dealloc];
}	

-(void)CreateBtns
{
    ENButton *btn = [ENButton ButtonWithTouchablePortion:[CCSprite spriteWithSpriteFrameName:@"home.png"] target:self selector:@selector(HomePressed)];
    btn.position = ccp(10, self.contentSize.height - 5);
    btn.anchorPoint = ccp(0, 1);
    [self addChild:btn];
    
    btn = [ENButton ButtonWithTouchablePortion:[CCSprite spriteWithSpriteFrameName:@"refresh.png"] target:self selector:@selector(RefreshPressed)];
    btn.position = ccp(70, self.contentSize.height - 5);
    btn.anchorPoint = ccp(0, 1);
    [self addChild:btn];
}

-(void)HomePressed
{
    [[CCDirector sharedDirector] popScene];
}

-(void)RefreshPressed
{
    [self unscheduleUpdate];
    CCTransitionFade *scene = [CCTransitionFade transitionWithDuration:1 scene:[HelloWorldLayer scene]];
    [[CCDirector sharedDirector] replaceScene: scene];
}

-(void) initPhysics
{
//	CGSize s = [[CCDirector sharedDirector] winSize];
	
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
    
    float margin = 40.0/PTM_RATIO;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;		
	
	// bottom
    
    
	
	groundBox.Set(b2Vec2(0,margin), b2Vec2(SCREEN_WITH/PTM_RATIO,margin));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,SCREEN_HEIGHT/PTM_RATIO -margin), b2Vec2(SCREEN_WITH/PTM_RATIO,SCREEN_HEIGHT/PTM_RATIO - margin));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(margin,SCREEN_HEIGHT/PTM_RATIO), b2Vec2(margin,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(SCREEN_WITH/PTM_RATIO - margin,SCREEN_HEIGHT/PTM_RATIO), b2Vec2(SCREEN_WITH/PTM_RATIO - margin,0));
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
    bodyDef.angularDamping = 0.9f;
    bodyDef.linearDamping = 1.7;
	bodyDef.bullet = YES;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
    b2CircleShape  dynamicCircle;
    dynamicCircle.m_radius = 9.0/PTM_RATIO;
    
    //b2PolygonShape dynamicCircle;
    //dynamicCircle.SetAsBox(0.5, 0.5);
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicCircle;
	
	fixtureDef.density = 2.0f;
	fixtureDef.friction = 0.0f;
    fixtureDef.restitution = 0.7f;
    
	body->CreateFixture(&fixtureDef);
    
    return body;
}

-(PLBallSprite*) addNewSpriteAtPosition:(CGPoint)p withPlayer:(PLPlayerType)pType
{
    b2Body *body = [self CreateBodyAtPosition:p];
    PLBallSprite *sprite = [PLBallSprite BallSpriteWithPlayer:[self.playerArray objectAtIndex:pType] withBody:body];
    [ballBatchNode addChild:sprite];
//    [self.ballArray addObject:sprite];
    return sprite;
}

-(void) update: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
    
    [self.roundCtrl Update];
    
    // Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);	
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

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

-(b2World*)CurWorld
{
    return world;
}

-(void)DestroyBall:(PLBallSprite *)ball
{
    world->DestroyBody(ball.b2Body);
    [ball removeFromParentAndCleanup:YES];
    [self.ballArray removeObject:ball];
}

-(void)SetLanchCycleWithPType:(PLPlayerType)pType withPt:(CGPoint)pt
{
    lanchCycle.mLine.visible = NO;
    if (CGPointEqualToPoint(pt, CGPointZero)) {
        pt = kLanchCycleDefaultPt;
        lanchCycle.mLine.visible = YES;
    }
    lanchCycle.mPlayerType = pType;
    lanchCycle.position = pt;
    lanchCycle.mLanchAble = YES;
}

-(BOOL)IsBallInPlayGround:(CCNode *)ball
{
    CGRect playGroundRect = CGRectInset(playerGround.boundingBox, 3, 3);
    return CGRectIntersectsRect(playGroundRect, ball.boundingBox);
}

-(void)ShowAlert
{
    [self addChild:[PLGameAlertLayer node] z:100];
}
@end
