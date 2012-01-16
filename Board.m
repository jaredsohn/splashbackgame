//
//  Board.m
//  opengltest
//
//  Created by Jared on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Board.h"


@implementation Board

//TO_DO: initialize board differently based on level
-(Board *) initWithW: (int) _w andH: (int) _h andMax: (int) _maxValue {

	self = [super init];
	
	w = _w;
	h = _h;
	maxValue = _maxValue;	
	state = [[NSMutableArray alloc] init];
	spotsCleared = 0;
	
	for (int i = 0; i < w; i++)
	{
		for (int j = 0; j < h; j++)
		{
			int value = (int) (arc4random() % maxValue);
			NSNumber *nsNumberValue = [NSNumber numberWithInt: value];
			[state addObject: nsNumberValue];
		}
	}
	
	return self;
}

-(int) GetValueAtX: (int) _x AndY: (int) _y {
	if ((_x < 0) || (_y < 0) || (_x >= w) || (_y >= h))
	{
		return 0;
	}
	NSNumber *nsNumber = [state objectAtIndex: (_y * w + _x)];
	return nsNumber.intValue;
}

-(void) SetValueAtX: (int) _x AndY: (int) _y WithValue: (int) _value {
	if ((_x < 0) || (_y < 0) || (_x >= w) || (_y >= h))
	{
		return;
	}
		
	NSNumber *valueNsNumber = [NSNumber numberWithInt:_value];
	[state replaceObjectAtIndex: (_y * w + _x)  withObject: valueNsNumber];
}

// Change the value at a square and create particles if appropriate
-(bool) ChooseX: (int) _x andY: (int) _y {		
	int val = [self GetValueAtX: _x AndY: _y];
	val = (val + 1) % maxValue;
	
	[self SetValueAtX : _x AndY: _y WithValue: val];
	
	if (val == 0) spotsCleared++;
	
	return (val == 0);
}

//TODO: should draw each square of the board and indicate the current value
- (void) Render: (EAGLContext *) _context;
{	
	int err = glGetError();
	NSLog(@"OpenGL Error A: %d", err);
	
	// 1) draw the grid.  We assume that we have -1...1,-1...1 to work with	
	glColor4f(0.0f,1.0f,0.0f,1.0f);

	for (int i = 0; i <= w; i++)
	{
		float x = (i - w/2.0f) / (w/2.0f);
		const GLfloat line[] = {
			x, -1, //point A
			x, 1, //point B
		};
		
		glVertexPointer(2, GL_FLOAT, 0, line);
		glEnableClientState(GL_VERTEX_ARRAY);
		glDrawArrays(GL_LINES, 0, 2);
		
	}
	for (int j = 0; j <= h; j++)
	{
		float y = (j - h/2.0f) / (h/2.0f);
		const GLfloat line[] = {
			-1, y, //point A
			1, y, //point B
		};
		
		glVertexPointer(2, GL_FLOAT, 0, line);
		glEnableClientState(GL_VERTEX_ARRAY);
		glDrawArrays(GL_LINES, 0, 2);
		
	}
	err = glGetError();
	NSLog(@"OpenGL Error B: %d", err);
	
	// 2) TODO draw current value for each cell	
	
	for (int i = 0; i < w; i++)
	{
		float x = (i - w/2.0f) / (w/2.0f);
		
		for (int j = 0; j < h; j++)
		{
			NSNumber *nsNumVal = [state objectAtIndex:(j*w+i)];			
			float val = [nsNumVal floatValue] / (float)maxValue;
			
			float y = (j - h/2.0f) / (h/2.0f);

			glPushMatrix();
			glTranslatef(x + 0.5f * (1 / (w/2.0f)), y + 0.5f * (1 / (h/2.0f)), y + 0.5f * (1 / (h/2.0f)));
			glScalef(1.0f / (float)w, 1.0f / (float)h, 1.0f);
			glColor4f(val * 1.0f,0.0f,0.0f,val * 1.0f);
			
			const GLfloat shape[] = {
				-val, -val,
				val, val,
				-val, val,
				val, -val
			};
			
			glVertexPointer(2, GL_FLOAT, 0, shape);
			glEnableClientState(GL_VERTEX_ARRAY);
			glDrawArrays(GL_LINES, 0, 4);
						
			glPopMatrix();
		}
	}		
}

- (void) draw
{	
	// 1) draw the grid.  We assume that we have -1...1,-1...1 to work with	
	glColor4f(0.0f,1.0f,0.0f,1.0f);
	
	for (int i = 0; i <= w; i++)
	{
		float x = (i - w/2.0f) / (w/2.0f);

		/*
		const GLfloat line[] = {
			x, -1, //point A
			x, 1, //point B
		};*/
		
		ccDrawLine( ccp(x, -1), ccp(x, 1) );

		/*
		
		glVertexPointer(2, GL_FLOAT, 0, line);
		glEnableClientState(GL_VERTEX_ARRAY);
		glDrawArrays(GL_LINES, 0, 2);*/
		
	}
	
	for (int j = 0; j <= h; j++)
	{
		float y = (j - h/2.0f) / (h/2.0f);
/*		const GLfloat line[] = {
			-1, y, //point A
			1, y, //point B
		};
		
		glVertexPointer(2, GL_FLOAT, 0, line);
		glEnableClientState(GL_VERTEX_ARRAY);
		glDrawArrays(GL_LINES, 0, 2);
*/	
		ccDrawLine( ccp(-1, y), ccp(1, y) );
	}
	
	// 2) Draw current value for each cell	
	
	for (int i = 0; i < w; i++)
	{
		float x = (i - w/2.0f) / (w/2.0f);
		
		for (int j = 0; j < h; j++)
		{
			NSNumber *nsNumVal = [state objectAtIndex:(j*w+i)];			
			float val = [nsNumVal floatValue] / (float)maxValue;
			
			float y = (j - h/2.0f) / (h/2.0f);
			
			glPushMatrix();
			glTranslatef(x + 0.5f * (1 / (w/2.0f)), y + 0.5f * (1 / (h/2.0f)), y + 0.5f * (1 / (h/2.0f)));
			glScalef(1.0f / (float)w, 1.0f / (float)h, 1.0f);
			glColor4f(val * 1.0f,0.0f,0.0f,val * 1.0f);
			
			/*
			const GLfloat shape[] = {
				-val, -val,
				val, val,
				-val, val,
				val, -val
			};*/
			
//			glVertexPointer(2, GL_FLOAT, 0, shape);
//			glEnableClientState(GL_VERTEX_ARRAY);
//			glDrawArrays(GL_LINES, 0, 4);
			ccDrawLine( ccp(-val, -val), ccp(val, val) );
			ccDrawLine( ccp(-val, val), ccp(val, -val) );

			
			glPopMatrix();
		}
	}
}


- (void) SetSpotsCleared: (int) _numSpots
{
	spotsCleared = _numSpots;
}
- (int) GetSpotsCleared
{
	return spotsCleared;
}

-(bool) IsClear
{
	bool isClear = YES;
	for (int x = 0; x < w; x++)
	{
		for (int y = 0; y < h; y++)
		{
			int val = [self GetValueAtX: x AndY: y];

			if (val != 0)
			{
				isClear = NO;
				break;
			}
		}
	}
	
	return isClear;
}



@end
