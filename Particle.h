//
//  Particle.h
//  opengltest
//
//  Created by Jared on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

#import "cocos2d.h"
#import "ccNode.h"


@interface Particle : NSObject {
@public
	float x;
	float y;
	float dx;
	float dy;
}

-(Particle *) CreateParticleAtX: (int) _x andY: (int) _y  WithDx: (float) _dx AndDy: (float) _dy;
-(bool) Move;
-(float) GetXPos;
-(float) GetYPos;
- (void) Render: (EAGLContext *) _context;
- (void) draw;

@end
