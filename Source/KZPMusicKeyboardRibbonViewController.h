//
//  KZPMusicKeyboardRibbonViewController.h
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import "ViewController.h"
#import "KZPMusicKeyboardDelegate.h"
#import "KZPMusicSciNotation.h"

@interface KZPMusicKeyboardRibbonViewController : UIViewController

@property (weak, nonatomic) id<KZPMusicKeyboardDelegate> delegate;

- (MusicSpelling)selectedAccidental;
- (void)resetSpelling;
- (unsigned int)selectedDuration;
- (BOOL)isRest;
- (BOOL)isTied;
- (BOOL)isRest;

- (NSString *)selectedPatch;

- (void)resetDuration;

@end
