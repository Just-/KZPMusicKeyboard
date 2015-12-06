//
//  KZPMusicKeyboardViewController.h
//  KZPMusicKeyboard
//
//  Created by Matt Rankin on 27/06/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPMusicDurationData.h"
#import "KZPMusicPitchData.h"

typedef enum {
    SP__DOUBLE_FLAT = -2,
    SP__FLAT,
    SP__NATURAL,
    SP__SHARP,
    SP__DOUBLE_SHARP
} noteSpelling;

typedef enum {
    SPELLING_OP__POST,
    SPELLING_OP__PRE
} SpellingOperation;

typedef enum {
    KBD__NOTE_ON,
    KBD__NOTE_OFF
} inputType;

typedef enum {
    KZPMusicKeyboardRhythmMode_Passive,   // Rhythm is set prior to applying to pitch data
    KZPMusicKeyboardRhythmMode_Active     // Rhythm interactions are sent as keyboard signals with null pitch data
} KZPMusicKeyboardRhythmMode;

@protocol KZPMusicKeyboardDelegate <NSObject>

- (void)musicKeyboardDidPitchData:(KZPMusicPitchData *)pitchData withDurationData:(KZPMusicDurationData *)durationoData;

@optional
- (void)keyboardWasDismissed;
- (void)keyboardDidSendBackspace;

@end

@interface KZPMusicKeyboardViewController : UIViewController

@property (weak, nonatomic) id<KZPMusicKeyboardDelegate> delegate;

@property (nonatomic) BOOL keyboardEnabled;
@property (nonatomic) BOOL chordsEnabled;
@property (nonatomic) BOOL rhythmControlsEnabled;
@property (nonatomic) KZPMusicKeyboardRhythmMode rhythmMode;

@property (nonatomic) SpellingOperation spellingOperation;

- (void)panToRangeWithCenterNote:(NSUInteger)noteID animated:(BOOL)animated;

- (IBAction)keyButtonPressed:(id)sender;
- (IBAction)durationButtonPress:(id)sender;
- (IBAction)durationButtonTouch:(id)sender;
- (IBAction)accidentalButtonPress:(id)sender;

@end
