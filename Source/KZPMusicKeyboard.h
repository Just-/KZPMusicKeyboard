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
#import "KZPMusicKeyboardDelegate.h"

@interface KZPMusicKeyboard : NSObject

+ (KZPMusicKeyboard *)keyboard;

@property (weak, nonatomic) id<KZPMusicKeyboardDelegate, KZPMusicKeyboardControlDelegate> delegate;

- (void)show;
- (void)hide;
- (void)showWithCompletion:(void (^)())completionBlock;
- (void)hideWithCompletion:(void (^)())completionBlock;

/*
   If enabled the keyboard will slide in and out of view on show/hide
 */
@property (nonatomic, setter=shouldAnimate:) BOOL shouldAnimate;

/* 
   Allow the use of the piano keyboard surface
 */
- (void)enablePitchControl:(BOOL)setting;

/* 
   Chord detection will aggregate multiple notes using a timer,
   then send every note in a single callback
 */
- (void)enableChordDetection:(BOOL)setting;

/* 
   The chord sensitivity is in milliseconds, which defines how relaxed
   the chord detection is. A higher setting makes it easier to enter chord
   information, but at the expense of being able to enter a sequence rapidly.
 */
- (void)chordSensitivity:(NSUInteger)setting;

/* 
   Enable the spelling controls on the top ribbon. If enabled, spelling
   and scientific notation will be returned for every pitch value. Spellings
   are automatically resolved to their next available possibility if the
   selected accidental cannot apply to a particular note.
 */
- (void)enableSpelling:(BOOL)setting;

/*
   Duration (rhythm) controls appear on the top ribbon. If enabled, duration
   information (plus rest, dot, and tie state) will be sent along with pitch.
 */
- (void)enableDurationControls:(BOOL)setting;

/*
   If duration controls are set to 'active', it means they can be used to
   enter a rhythm indepentently of pitch. No pitch data is sent when the duration
   buttons are used in this mode.
 */
- (void)durationControlsActive:(BOOL)setting;

/* 
   By default the keyboard will play sound natively, giving the choice
   between a cheap and nasty grand piano and an utterly disgraceful electric piano.
   You can easily switch this off and use the note on/off data to drive some
   other virtual or remote instrument.
 */
- (void)enableLocalAudio:(BOOL)setting;

/* 
   Allow the keyboard to be dismissed by the user from the ribbon control
 */
- (void)enableManualDismiss:(BOOL)setting;

/* 
   Allow the user to hit a 'backspace' button - useful during the entry
   of musical sequences
 */
- (void)enableBackspaceControl:(BOOL)setting;


@end
