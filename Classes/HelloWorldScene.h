//
//  HelloWorldLayer.h
//  splashback-cocos2d
//
//  Created by Jared on 7/31/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "SplashBackGame.h"
#import "CCDirector.h"

// HelloWorld Layer
@interface HelloWorld : CCLayer
{
	SplashBackGame *game;
	CCLabel *StatusLabel;
	CCLabel *GameOverLabel;
	CCLabel *RestartLabel;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
+ (BOOL)collidesWithLabel:(CCLabel *)label atPoint:(CGPoint)point;
-(void) UpdateStatusLabel;
@end
