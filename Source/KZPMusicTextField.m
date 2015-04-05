//
//  KZPMusicTextField.m
//  KZPMusicKeyboard
//
//  Created by Matt Rankin on 1/07/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import "KZPMusicTextField.h"
#import "KZPMusicKeyboardManager.h"
#import "AGWindowView.h"
#import "UIView+frameOperations.h"

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
    self.keyboardType = UIKeyboardTypeDecimalPad;
    self.musicInputType = KZPMusicInputType_PianoKeyboard | KZPMusicInputType_NormalKeyboard;
    self.nullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self setupToggleButton];
    self.isCurrentlySwitchingKeyboards = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(qwertyKeyboardDidHide)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
}


#pragma mark - Qwerty Keyboard -

//
- (void)qwertyKeyboardDidHide
{
    if ([self isCurrentlySwitchingKeyboards]) {
        [self becomeFirstResponder];
    }
}


#pragma mark - UITextField -

// TODO: this crash seems to happen when a text field that still has focus is removed from the
// canvas. It means that rfr is called on a deallocated instance as part of a new field gaining
// focus. A bug somewhere is causing the text field to believe that it has resigned first responder
// status when in fact it hasn't. In any case it maintains the cursor, which indicates that the
// manual call to rfr isn't working properly.
- (BOOL)resignFirstResponder
{


    NSLog(@"resign first responder! (%@)", self.musicInputType == KZPMusicInputType_PianoKeyboard ? @"Music" : @"Normal");
    // DEPRECATED
    self.isCurrentlySwitchingKeyboards = NO;
    
//    if (self.keyboardType == KZPMusicInputType_NormalKeyboard) {
//        [[KZPMusicKeyboardManager defaultManager] removeImmediately];
//    }
    
    if ([self showingQwertyKeyboard]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.keyboardTypeToggle.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.keyboardTypeToggle.hidden = YES;
            [[KZPMusicKeyboardManager defaultManager] removeImmediately];
        }];
    } else {
        
        [[KZPMusicKeyboardManager defaultManager] hideControllerWithCompletionBlock:NULL deactivate:YES];
        [UIView animateWithDuration:0.3 animations:^{
            self.keyboardTypeToggle.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.keyboardTypeToggle.hidden = YES;
        }];
    }
    return [super resignFirstResponder];
}

// TODO: Will probably have to use keyboard did hide/show notifications here.
- (BOOL)becomeFirstResponder
{

        NSLog(@"become first responder! (%@)", self.musicInputType == KZPMusicInputType_PianoKeyboard ? @"Music" : @"Normal");
    
    if (self.musicInputType & KZPMusicInputType_PianoKeyboard) {
        
        [[KZPMusicKeyboardManager defaultManager] setResponder:self];
        NSDictionary *keyboardOptions = @{kENABLE_KEYBOARD: @(!self.pitchInputDisabled),
                                          kENABLE_CHORDS: @(!self.chordalInputDisabled),
                                          kENABLE_RHYTHM: @(self.needsRhythmControls)};
        UIView *windowView = [[KZPMusicKeyboardManager defaultManager] showControllerWithOptions:keyboardOptions];
        [windowView addSubview:self.keyboardTypeToggle];
        self.inputView = self.nullView; // Hide standard keyboard, but show blinking cursor
        
        // If this is also a normal keyboard, add the toggle button
        // DEPRECATED
        if (self.musicInputType & KZPMusicInputType_NormalKeyboard) {
            [self resetToggleButton];
            [UIView animateWithDuration:0.3 animations:^{
                self.keyboardTypeToggle.alpha = 1.0;
            }];
        }   
    }
    return [super becomeFirstResponder];
}


#pragma mark - PianoKeyboardDelegate -

- (void)keyboardWasDismissed
{
    [self resignFirstResponder];
}

- (void)keyboardDidSendBackspace
{
    self.text = @"";
}

- (void)keyboardDidSendSignal:(NSArray *)noteID
                    inputType:(NSArray *)type
                     spelling:(NSArray *)spelling
                     duration:(NSNumber *)duration
                       dotted:(BOOL)dotted
                         tied:(BOOL)tied
                   midiPacket:(NSArray *)MIDI
                    oscPacket:(NSArray *)OSC
{
    if ([self.text isEqualToString:@""]) {
        self.text = [NSString stringWithFormat:@"%@", [noteID count] > 1 ? [self chordFromNoteIDs:noteID] : [noteID lastObject]];
    } else {
        [self setText:[NSString stringWithFormat:@"%@ %@", self.text, [noteID count] > 1 ? [self chordFromNoteIDs:noteID] : [noteID lastObject]]];
    }
}


#pragma mark - Auxiliary -

// TODO: This method is worthless
- (NSString *)chordFromNoteIDs:(NSArray *)noteIDs
{
    NSMutableString *chordString = [NSMutableString stringWithString:@"[ "];
    for (NSNumber *noteID in noteIDs) {
        [chordString appendFormat:@"%@ ", noteID];
    }
    [chordString appendString:@"]"];
    return (NSString *)chordString;
}


#pragma mark - Toggle Button Functions -

// DEPRECATED
- (void)setupToggleButton
{
    self.keyboardTypeToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    self.keyboardTypeToggle.backgroundColor = [UIColor whiteColor];
    self.keyboardTypeToggle.titleLabel.text = @"";
    [self.keyboardTypeToggle addTarget:self action:@selector(switchKeyboards) forControlEvents:UIControlEventTouchUpInside];
    [self.keyboardTypeToggle setImage:[UIImage imageNamed:@"qwerty.png"] forState:UIControlStateNormal];
    [self.keyboardTypeToggle setImage:[UIImage imageNamed:@"piano_keyboard.png"] forState:UIControlStateSelected];
    self.keyboardTypeToggle.clipsToBounds = YES;
    self.keyboardTypeToggle.layer.borderWidth = 1.0;
    self.keyboardTypeToggle.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.keyboardTypeToggle.layer.cornerRadius = 2.0;
    [self resetToggleButton];
}

// DEPRECATED
- (void)resetToggleButton
{
    if (!self.isCurrentlySwitchingKeyboards) {
        self.keyboardTypeToggle.alpha = 0.0;
    }
    self.keyboardTypeToggle.hidden = NO;
    self.keyboardTypeToggle.selected = NO;
    self.keyboardTypeToggle.frame = CGRectMake(LOCATION_X__SWITCHER, LOCATION_Y__PIANO, WIDTH_SWITCHER, HEIGHT_SWITCHER);
}

// DEPRECATED
- (BOOL)showingQwertyKeyboard
{
    return self.keyboardTypeToggle.selected;
}

// DEPRECATED
- (void)switchKeyboards
{
    self.isCurrentlySwitchingKeyboards = YES;
    [super resignFirstResponder];
    
    if ([self showingQwertyKeyboard]) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.keyboardTypeToggle setFrameY:LOCATION_Y__PIANO];
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            [self.keyboardTypeToggle setFrameY:LOCATION_Y__QWERTY];
        }];
        [[KZPMusicKeyboardManager defaultManager] hideControllerWithCompletionBlock:^{
            self.inputView = nil;
            [super becomeFirstResponder];
        } deactivate:NO];
    }
    
    self.keyboardTypeToggle.selected = !self.keyboardTypeToggle.selected;
}

@end
