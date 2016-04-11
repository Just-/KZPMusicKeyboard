//
//  KZPMusicKeyboardViewController.h
//  KZPMusicKeyboard
//
//  Created by Matt Rankin on 27/06/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPMusicKeyboardDelegate.h"
#import "KZPMusicKeyboardAudio.h"

@interface KZPMusicKeyboardViewController : UIViewController

- (void)registerControlDelegate:(id<KZPMusicKeyboardControlDelegate>)controlDelegate;
- (void)registerMusicDelegate:(id<KZPMusicKeyboardDataDelegate>)musicalDelegate;

- (CGFloat)height;

@property (nonatomic, setter=enablePitchControl:) BOOL pitchControlEnabled;
@property (nonatomic, setter=enableLocalAudio:) BOOL localAudioEnabled;
@property (strong, nonatomic) KZPMusicKeyboardAudio *localAudioPlayer;

- (void)enableSpelling:(BOOL)setting;
- (void)enableChordDetection:(BOOL)setting;
- (void)enableDurationControls:(BOOL)setting;
- (void)durationControlsActive:(BOOL)setting;
- (void)enableManualDismiss:(BOOL)setting;
- (void)enableBackspaceControl:(BOOL)setting;
- (void)chordSensitivity:(NSUInteger)setting;

- (void)reconfigureForSettings;

@end
