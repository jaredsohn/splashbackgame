//
//  Board.h
//  opengltest
//
//  Created by Jared on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import "cocos2d.h"
#import "ccNode.h"

@interface Board : CCNode {
	int w;
	int h;
	int maxValue;
	int spotsCleared;
	NSMutableArray *state;
}

-(Board *) initWithW: (int) w andH: (int) h andMax: (int) maxValue;

-(bool) ChooseX: (int) _x andY: (int) _y;

-(int) GetValueAtX: (int) _x AndY: (int) _y;

-(void) SetValueAtX: (int) _x AndY: (int) _y WithValue: (int) _value;

-(bool) IsClear;

- (void) Render: (EAGLContext *) _context;

- (void) SetSpotsCleared: (int) _numSpots;
- (int) GetSpotsCleared;

-(void) draw;

@end
