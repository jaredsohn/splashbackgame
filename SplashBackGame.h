//
//  SplashBackGame.h
//  opengltest
//
//  Created by Jared on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Board.h"
#import "Particle.h"

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

//TODO: make MULTIPLEFORBONUSATTEMPTS a constant that can be set in preferences (by default this is 2)


@interface SplashBackGame : NSObject {
	
	int remainingAttempts;
	float particleSpeed;
	int boardW;
	int boardH;
	int MaxValue;
	int level;
	int highestLevelEver;
	int highestLevelToday;
	bool Busy;
	
	Board *board;
	NSMutableArray *particles;
	
}

-(void) ChooseX: (int) _x AndY: (int) _y;
-(void) Tick;
-(void) Render: (EAGLContext *) _context;
-(void) draw;

- (void) SetRemainingAttempts: (int) _numAttempts;
- (int) GetRemainingAttempts;

- (void) SetBusy: (bool) _busy;
- (bool) GetBusy;

- (int) GetHighestLevelEver;
- (int) GetHighestLevelToday;

- (int) GetLevel;
- (int) IncrementLevel;

- (int) GetBoardH;
- (int) GetBoardW;

- (void) Restart;

@end
