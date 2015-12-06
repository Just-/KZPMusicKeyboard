//
//  KZPMusicKeyboardMapViewController.h
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import "ViewController.h"
#import "KZPMusicKeyboardDelegate.h"

@protocol KZPMusicKeyboardMapDelegate <NSObject>

- (void)updateKeyboardPosition:(float)relativePosition;

@end

@interface KZPMusicKeyboardMapViewController : ViewController

@property (weak, nonatomic) id<KZPMusicKeyboardMapDelegate> delegate;

@end
