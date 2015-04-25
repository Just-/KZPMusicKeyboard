//
//  KZPMusicTextField.h
//  KZPMusicKeyboard
//
//  Created by Matt Rankin on 1/07/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPMusicKeyboardViewController.h"

typedef enum {
    KZPMusicInputType_PianoKeyboard  = 1<<0,
    KZPMusicInputType_NormalKeyboard = 1<<1
} KZPMusicInputType;

@interface KZPMusicTextField : UITextField <KZPMusicKeyboardDelegate>

// These parameters are available
@property (nonatomic) KZPMusicInputType musicInputType;
@property (nonatomic) BOOL needsRhythmControls;
@property (nonatomic) BOOL pitchInputDisabled;
@property (nonatomic) BOOL chordalInputDisabled;

// Override these methods in a KZPMusicTextField subclass
- (void)keyboardDidSendBackspace;
- (void)keyboardDidSendSignal:(NSArray *)noteID
                    inputType:(NSArray *)type
                     spelling:(NSArray *)spelling
                     duration:(NSNumber *)duration
                       dotted:(BOOL)dotted
                         tied:(BOOL)tied
                   midiPacket:(NSArray *)MIDI
                    oscPacket:(NSArray *)OSC;


@end
