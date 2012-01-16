//
//  Particle.m
//  opengltest
//
//  Created by Jared on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Particle.h"


@implementation Particle

-(Particle *) CreateParticleAtX: (int) _x andY: (int) _y  WithDx: (float) _dx AndDy: (float) _dy {
	self = [super init];
	
	x = _x;
	y = _y;
	dx = _dx;
	dy = _dy;	
	
	return self;
}

-(bool) Move {
	int oldX = (int) x;
	int oldY = (int) y;
	x += dx;
	y += dy;
	return (((int)x != oldX) || ((int)y != oldY));
}

-(float) GetXPos
{
	return x;
}

-(float) GetYPos
{
	return y;
}


//TODO: use something besides x and y to determine if equal (maybe assign a random id?)
- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
	if ([self hash] == [other hash])
	{
		return YES;
	} else {
		return NO;
	}
}

- (NSUInteger)hash {
    NSUInteger hash = x * 256 + y; //TODO: adjust this too
    return hash;
}

- (void) Render: (EAGLContext *) _context
{	
//	[EAGLContext setCurrentContext:_context];

	glColor4f(1.0f,0.0f,1.0f,1.0f);
	
	float w = 6.0f;
	float h = 6.0f;
	float renderX = (x + 0.5f - w/2.0f) / (w/2.0f);
	float renderY = (y + 0.5f - h/2.0f) / (h/2.0f);
	float particleSize = 0.05f;
	const GLfloat line[] = {
		renderX - particleSize, renderY,
		renderX + particleSize, renderY,
	};
		
	glVertexPointer(2, GL_FLOAT, 0, line);
	glEnableClientState(GL_VERTEX_ARRAY);
	glDrawArrays(GL_LINES, 0, 2);

	
	const GLfloat line2[] = {
		renderX, renderY - particleSize, 
		renderX, renderY + particleSize, 
	};
	
	glVertexPointer(2, GL_FLOAT, 0, line2);
	glEnableClientState(GL_VERTEX_ARRAY);
	glDrawArrays(GL_LINES, 0, 2);
}

- (void) draw
{	
	//	[EAGLContext setCurrentContext:_context];
	
	glColor4f(1.0f,0.0f,1.0f,1.0f);
	
	float w = 6.0f;
	float h = 6.0f;
	float renderX = (x + 0.5f - w/2.0f) / (w/2.0f);
	float renderY = (y + 0.5f - h/2.0f) / (h/2.0f);
	float particleSize = 0.05f;
/*	const GLfloat line[] = {
		renderX - particleSize, renderY,
		renderX + particleSize, renderY,
	};
*/	
//	glVertexPointer(2, GL_FLOAT, 0, line);
//	glEnableClientState(GL_VERTEX_ARRAY);
//	glDrawArrays(GL_LINES, 0, 2);

	ccDrawLine( ccp(renderX - particleSize, renderY), ccp(renderX + particleSize, renderY) );
	
	
	const GLfloat line2[] = {
		renderX, renderY - particleSize, 
		renderX, renderY + particleSize, 
	};
/*	
	glVertexPointer(2, GL_FLOAT, 0, line2);
	glEnableClientState(GL_VERTEX_ARRAY);
	glDrawArrays(GL_LINES, 0, 2);
*/	
	ccDrawLine( ccp(renderX, renderY - particleSize), ccp(renderX, renderY + particleSize) );

}


@end
