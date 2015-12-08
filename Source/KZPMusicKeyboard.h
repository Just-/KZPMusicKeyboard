//
//  KZPMusicKeyboard.h
//  KZPMusicKeyboard
//
//  Created by Matt Rankin on 1/07/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPMusicPitchData.h"
#import "KZPMusicDurationData.h"
#import "KZPMusicKeyboardViewController.h"

@interface KZPMusicKeyboard : NSObject

+ (KZPMusicKeyboard *)keyboard;

@property (weak, nonatomic) id<KZPMusicKeyboardDelegate, KZPMusicKeyboardControlDelegate> delegate;

- (void)show;
- (void)hide;
- (void)showWithCompletion:(void (^)())completionBlock;
- (void)hideWithCompletion:(void (^)())completionBlock;

//
// Use these methods to override the keyboard's default settings
//
@property (nonatomic, setter=shouldAnimate:) BOOL shouldAnimate;
- (void)enablePitchControl:(BOOL)setting;
- (void)enableChordDetection:(BOOL)setting;
- (void)enableDurationControls:(BOOL)setting;
- (void)enableSpelling:(BOOL)setting;
- (void)durationControlsActive:(BOOL)setting;
- (void)enableLocalAudio:(BOOL)setting;
- (void)enableManualDismiss:(BOOL)setting;
- (void)enableBackspaceControl:(BOOL)setting;
- (void)chordSensitivity:(NSUInteger)setting;

@end
