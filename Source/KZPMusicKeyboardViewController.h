//
//  KZPMusicKeyboardViewController.h
//  KZPMusicKeyboard
//
//  Created by Matt Rankin on 27/06/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPMusicKeyboardDelegate.h"

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



@interface KZPMusicKeyboardViewController : UIViewController

@property (nonatomic) BOOL keyboardEnabled;
@property (nonatomic) BOOL chordsEnabled;
@property (nonatomic) BOOL rhythmControlsEnabled;
@property (nonatomic) KZPMusicKeyboardRhythmMode rhythmMode;

@property (nonatomic) SpellingOperation spellingOperation;

- (void)panToRangeWithCenterNote:(NSUInteger)noteID animated:(BOOL)animated;

- (IBAction)keyButtonPressed:(id)sender;

@end
