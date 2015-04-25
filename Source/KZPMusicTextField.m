//
//  KZPMusicTextField.m
//  KZPMusicKeyboard
//
//  Created by Matt Rankin on 1/07/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import "KZPMusicTextField.h"
#import "KZPMusicKeyboardManager.h"
#import "NSArray+functions.h"

@interface KZPMusicTextField ()

@property (strong, nonatomic) UIButton *keyboardTypeToggle;
@property (strong, nonatomic) UIView *nullView;

@property (nonatomic) BOOL isCurrentlySwitchingKeyboards;

@end

@implementation KZPMusicTextField

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [KZPMusicKeyboardManager defaultManager];   // Lazy load
    self.nullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (BOOL)resignFirstResponder
{
    if (self.musicInputType == KZPMusicInputType_PianoKeyboard) {
        [[KZPMusicKeyboardManager defaultManager] hideControllerWithCompletionBlock:NULL deactivate:YES];
    }
    return [super resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    if (self.musicInputType == KZPMusicInputType_PianoKeyboard) {
        [[KZPMusicKeyboardManager defaultManager] setResponder:self];
        NSDictionary *keyboardOptions = @{kENABLE_KEYBOARD: @(!self.pitchInputDisabled),
                                          kENABLE_CHORDS: @(!self.chordalInputDisabled),
                                          kENABLE_RHYTHM: @(self.needsRhythmControls)};
        [[KZPMusicKeyboardManager defaultManager] showControllerWithOptions:keyboardOptions];
        self.inputView = self.nullView; // Hide standard keyboard, but show blinking cursor
    }
    return [super becomeFirstResponder];
}


#pragma mark - PianoKeyboardDelegate -

- (void)keyboardDidSendSignal:(NSArray *)noteID
                    inputType:(NSArray *)type
                     spelling:(NSArray *)spelling
                     duration:(NSNumber *)duration
                       dotted:(BOOL)dotted
                         tied:(BOOL)tied
                   midiPacket:(NSArray *)MIDI
                    oscPacket:(NSArray *)OSC
{
    self.text = [noteID oneLineDescriptionUsingDelimiter:@" "];
}

- (void)keyboardDidSendBackspace
{
    self.text = @"";
}

- (void)keyboardWasDismissed
{
    [self resignFirstResponder];
    [[KZPMusicKeyboardManager defaultManager] hideControllerWithCompletionBlock:NULL deactivate:YES];
}

@end
