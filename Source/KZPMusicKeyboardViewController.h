//
//  KZPMusicKeyboardViewController.h
//  KZPMusicKeyboard
//
//  Created by Matt Rankin on 27/06/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SP__NATURAL = 0,
    SP__SHARP,
    SP__FLAT,
    SP__DOUBLE_SHARP,
    SP__DOUBLE_FLAT
} noteSpelling;

typedef enum {
    SPELLING_OP__POST,
    SPELLING_OP__PRE
} SpellingOperation;

typedef enum {
    KBD__NOTE_ON,
    KBD__NOTE_OFF
} inputType;

@protocol KZPMusicKeyboardDelegate <NSObject>

@optional
- (void)keyboardDidSendSignal:(NSArray *)noteID
                    inputType:(NSArray *)type
                     spelling:(NSArray *)spelling
                     duration:(NSNumber *)duration
                   midiPacket:(NSArray *)MIDI
                    oscPacket:(NSArray *)OSC;

- (void)keyboardDidSendBackspace;
- (void)keyboardWasDismissed;

@end

@interface KZPMusicKeyboardViewController : UIViewController

@property (weak, nonatomic) id<KZPMusicKeyboardDelegate> delegate;
@property (nonatomic) BOOL rhythmControlsEnabled;
@property (nonatomic) SpellingOperation spellingOperation;

- (void)panToRangeWithCenterNote:(NSUInteger)noteID animated:(BOOL)animated;

- (IBAction)keyButtonPressed:(id)sender;
- (IBAction)durationButtonPress:(id)sender;
- (IBAction)durationButtonTouch:(id)sender;
- (IBAction)accidentalButtonPress:(id)sender;

@end
