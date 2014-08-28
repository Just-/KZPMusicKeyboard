//
//  KZPMusicTextField.h
//  KZPMusicKeyboard
//
//  Created by Matt Rankin on 1/07/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPMusicKeyboardViewController.h"

// TODO: don't use these constants, measure instead
#define LOCATION_Y__PIANO       260
#define LOCATION_Y__QWERTY      370
#define LOCATION_X__SWITCHER    5
#define WIDTH_SWITCHER          80
#define HEIGHT_SWITCHER         40

typedef enum {
    KZPMusicInputType_PianoKeyboard  = 1<<0,
    KZPMusicInputType_NormalKeyboard = 1<<1
} KZPMusicInputType;

@interface KZPMusicTextField : UITextField <KZPMusicKeyboardDelegate>

// These parameters are available
@property (nonatomic) KZPMusicInputType musicInputType;
@property (nonatomic) BOOL needsRhythmControls;

- (BOOL)showingQwertyKeyboard;
- (void)qwertyKeyboardDidHide;

// Override these methods in a KZPMusicTextField subclass
- (void)keyboardDidSendBackspace;
- (void)keyboardDidSendSignal:(NSArray *)noteID
                    inputType:(NSArray *)type
                     spelling:(NSArray *)spelling
                     duration:(NSNumber *)duration
                   midiPacket:(NSArray *)MIDI
                    oscPacket:(NSArray *)OSC;

@end
