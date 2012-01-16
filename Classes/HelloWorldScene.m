//
//  HelloWorldLayer.m
//  splashback-cocos2d
//
//  Created by Jared on 7/31/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

// Import the interfaces
#import "HelloWorldScene.h"

// HelloWorld implementation
@implementation HelloWorld

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void)draw
{
	if (game != NULL)
	{
		glPushMatrix();
			CGSize size = [[CCDirector sharedDirector] winSize];				
			glScalef(size.width/2.0f, size.height/2.0f, 1.0f);
			glTranslatef(1.0f,1.0f,0.0f);
			[game draw];
		glPopMatrix();
		[self UpdateStatusLabel];

		BOOL gameOver = ([game GetRemainingAttempts] == 0);
		RestartLabel.visible = gameOver;
		GameOverLabel.visible = gameOver;
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{

	if ([game GetBusy]) return;

	UITouch *touch = [[event allTouches] anyObject];
	CGPoint touchLocation = [touch locationInView:touch.view];
	CGPoint cLoc = [[CCDirector sharedDirector] convertToGL: touchLocation];
		
	float touchedX = ((touchLocation.x - 160) / 160.0f);
	float touchedY = -1 * ((touchLocation.y - 240) / 240.0f);
		
	if ([game GetRemainingAttempts] <= 0)
	{
		if ([HelloWorld collidesWithLabel:RestartLabel atPoint:cLoc])
		{
			[game Restart];
		}
		return;
	}
	
	[game SetBusy:true];
	[game SetRemainingAttempts:[game GetRemainingAttempts] - 1]; 		
	

	// Translate screen coordinates to board coordinates
	float w = [game GetBoardW];
	float h = [game GetBoardH];

	int boardX = (int)(touchedX * (w/2.0f) + (w/2.0f));
	int boardY = (int)(touchedY * (h/2.0f) + (h/2.0f));
		
	[game ChooseX: boardX AndY: boardY];	

	return;
}

+ (BOOL)collidesWithLabel:(CCLabel *)label atPoint:(CGPoint)point
{
	return (((point.x > [label position].x - [label boundingBox].size.width/2) && (point.x < [label position].x + [label boundingBox].size.width/2))
		&& ((point.y > [label position].y - [label boundingBox].size.height/2) && (point.y < [label position].y + [label boundingBox].size.height/2)));
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		self.isTouchEnabled = YES;
		
		game = [[SplashBackGame alloc] init];
		
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		StatusLabel = [CCLabel labelWithString:@"Status" fontName:@"Marker Felt" fontSize:10];			
		StatusLabel.position =  ccp(size.width*0.6, [StatusLabel boundingBox].size.height/2);
		[self addChild: StatusLabel];
		
		NSString *restartString;
		restartString = [[NSString alloc] initWithString:@"Click here to restart"];
		RestartLabel = [CCLabel labelWithString:restartString fontName:@"Marker Felt" fontSize:10];			
		RestartLabel.position =  ccp([RestartLabel boundingBox].size.width/2, [StatusLabel boundingBox].size.height/2);
		[self addChild: RestartLabel];
				
		NSString *gameOverString = [[NSString alloc] initWithString:@"Game Over"];
		GameOverLabel = [CCLabel labelWithString:gameOverString fontName:@"Marker Felt" fontSize:50];
		GameOverLabel.position = ccp(size.width/2, size.height/2);		
		[self addChild: GameOverLabel];		
		 
	}
	return self;
}

- (void) UpdateStatusLabel
{
	NSString *statusString = [[NSString alloc] initWithFormat:@"Remaining attempts: %i  Level: %i  Highest level: %i", [game GetRemainingAttempts], [game GetLevel], [game GetHighestLevelEver]];   
	
	[StatusLabel setString:statusString];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
