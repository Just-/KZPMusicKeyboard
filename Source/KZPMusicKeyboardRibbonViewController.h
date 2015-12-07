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
#import "KZPMusicKeyboardDataAggregator.h"

@interface KZPMusicKeyboardRibbonViewController : UIViewController

@property (weak, nonatomic) id<KZPMusicKeyboardDelegate> delegate;

@property (weak, nonatomic) KZPMusicKeyboardDataAggregator *musicDataAggregator;

- (MusicSpelling)selectedAccidental;
- (void)resetSpelling;

- (NSString *)selectedPatch;

- (void)resetDuration;

- (void)sendDurationAndSpelling;

@end
