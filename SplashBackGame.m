//
//  SplashBackGame.m
//  opengltest
//
//  Created by Jared on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SplashBackGame.h"


@implementation SplashBackGame

-(id) init {
	particleSpeed = .04;
	boardW = 6;
	boardH = 6;
	MaxValue = 5;
	Busy = NO;
	remainingAttempts = 10;
	level = 1;
	highestLevelEver = 1;
	highestLevelToday = 1;
		
	board = [[Board alloc] initWithW: boardW andH: boardH andMax: MaxValue];
    particles = [[NSMutableArray alloc] init];
	
	return self;
}

-(void) ChooseX: (int) _x AndY: (int) _y
{	
	if ([board ChooseX: _x andY: _y])
	{
		Particle *particle;
	
		// Add a particle moving in each direction if choosing this square should cause particles to be created
		particle = [[Particle alloc] CreateParticleAtX: _x andY: _y WithDx: 0 AndDy: particleSpeed];
		[particles addObject: particle];	 
		particle = [[Particle alloc] CreateParticleAtX: _x andY: _y WithDx: 0 AndDy: -particleSpeed];
		[particles addObject: particle];
		particle = [[Particle alloc] CreateParticleAtX: _x andY: _y WithDx: particleSpeed AndDy: 0];
		[particles addObject: particle];
		particle = [[Particle alloc] CreateParticleAtX: _x andY: _y WithDx: -particleSpeed AndDy: 0];
		[particles addObject: particle];
	}
}


-(void) Tick
{
	NSMutableArray *discardedItems = [[NSMutableArray alloc] init];
	NSMutableArray *collisionX = [[NSMutableArray alloc] init];
	NSMutableArray *collisionY = [[NSMutableArray alloc] init];

	Particle *particle;

//	int prevClear = [board GetSpotsCleared];
	
	for (particle in particles)
	{		
		if ([particle Move]) // indicates if it moved into a different position on the board
		{
			float particleX = [particle GetXPos];
			float particleY = [particle GetYPos];
			
			if (([board GetValueAtX: particleX AndY: particleY]) != 0)
			{
				// The particle just collided with this square.
				//[self ChooseX:particleX AndY:particleY];
				
				NSNumber *numX = [[NSNumber alloc] initWithFloat:particleX];
				NSNumber *numY = [[NSNumber alloc] initWithFloat:particleY];
				[collisionX addObject:numX];
				[collisionY addObject:numY];
				[discardedItems addObject:particle];
				continue;
			}						
					
			if ((particleX < 0) || (particleX >= boardW) || (particleY < 0) || (particleY >= boardH))
			{
				[discardedItems addObject:particle];
			}		
		}
	}
	
	if ([discardedItems count] > 0)
	{
		[particles removeObjectsInArray:discardedItems];
	}
	
	for (int i = 0; i < [collisionX count]; i++)
	{
		NSNumber *numX = (NSNumber *)[collisionX objectAtIndex:i];
		NSNumber *numY = (NSNumber *)[collisionY objectAtIndex:i];
	
		int prevCleared = [board GetSpotsCleared];
		[self ChooseX:[numX floatValue] AndY:[numY floatValue]];

		int spotsCleared = [board GetSpotsCleared];
		if ((spotsCleared != prevCleared) && (spotsCleared >= 3) && ((spotsCleared % 2) == 1))
		{
			[self SetRemainingAttempts: [self GetRemainingAttempts] + 1];
			//TODO: should update display, make a sound, etc
		}
	}
	
	if ([particles count] == 0)
	{
		Busy = false;
		[board SetSpotsCleared:0];
	}
}

- (void) Render: (EAGLContext *) _context;
{		
	//[EAGLContext setCurrentContext:_context];
		
	
	[board Render: _context];
	
	for (int i = 0; i < [particles count]; i++)
	{
		Particle *particle = [particles objectAtIndex:i];
			
		[particle Render:_context]; 
	}
	[self Tick];
	
	// If board is clear, reset it and kill all particles
    if ([board IsClear])
	{
		board = [[Board alloc] initWithW: boardW andH: boardH andMax: MaxValue];
		particles = [[NSMutableArray alloc] init];
		remainingAttempts++;
		[self IncrementLevel];
	}
}

- (void) Restart
{
	board = [[Board alloc] initWithW: boardW andH: boardH andMax: MaxValue];
	particles = [[NSMutableArray alloc] init];	
	remainingAttempts = 10;
	level = 1;
}

- (void) draw
{		
	
	[board draw];
	
	for (int i = 0; i < [particles count]; i++)
	{
		Particle *particle = [particles objectAtIndex:i];
		
		[particle draw];
	}
	[self Tick];
	
	// If board is clear, reset it and kill all particles
    if ([board IsClear])
	{
		board = [[Board alloc] initWithW: boardW andH: boardH andMax: MaxValue];
		particles = [[NSMutableArray alloc] init];
		remainingAttempts++;
		[self IncrementLevel];
	}
}


- (void) SetRemainingAttempts: (int) _numAttempts
{
	remainingAttempts = _numAttempts;	
}
- (int) GetRemainingAttempts
{
	return remainingAttempts;
}

- (void) SetBusy: (bool) _busy
{
	Busy = _busy;
}
- (bool) GetBusy
{
	return Busy;
}

- (int) GetLevel
{
	return level;
}

- (int) GetHighestLevelEver
{
	return highestLevelEver;
}

- (int) GetHighestLevelToday
{
	return highestLevelToday;
}

- (int) GetBoardH
{
	return boardH;
}

- (int) GetBoardW
{
	return boardW;
}


- (int) IncrementLevel
{
	level++;
	if (level > highestLevelToday) highestLevelToday = level;
	if (level > highestLevelEver) highestLevelEver = level;
	return (level);
}


@end
