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

@protocol KZPMusicKeyboardDelegate;

@interface KZPMusicKeyboard : NSObject

+ (KZPMusicKeyboard *)keyboard;

@property (weak, nonatomic) id<KZPMusicKeyboardDelegate> delegate;

- (void)show;
- (void)hide;
- (void)showWithCompletion:(void (^)())completionBlock deactivate:(BOOL)deactivate; // ?? deactivate?
- (void)hideWithCompletion:(void (^)())completionBlock deactivate:(BOOL)deactivate;

@property (nonatomic) BOOL shouldAnimate;
@property (nonatomic) BOOL sendNoteOff;
@property (nonatomic) BOOL allowSpelling;
@property (nonatomic) BOOL polyphonic;
@property (nonatomic) BOOL useDurationControls;
@property (nonatomic) BOOL durationControlsActive;
@property (nonatomic) BOOL useLocalAudio;
@property (nonatomic) BOOL allowDismiss;
@property (nonatomic) BOOL allowBackspace;
@property (nonatomic) float chordSensitivity;

@end
