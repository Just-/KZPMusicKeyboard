//
//  ViewController.m
//  KZPMusicKeyboardDemo
//
//  Created by Matt Rankin on 28/08/2014.
//  Copyright (c) 2014 Sudoseng. All rights reserved.
//

#import "ViewController.h"
#import "KZPMusicKeyboard.h"
#import "NSArray+functions.h"


@interface ViewController () <KZPMusicKeyboardDelegate, KZPMusicKeyboardControlDelegate>

@property (weak, nonatomic) KZPMusicKeyboard *keyboard;

@end


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.keyboard = [KZPMusicKeyboard keyboard];
    self.keyboard.delegate = self;    
    [self applySettings];
}

- (IBAction)showKeyboard:(id)sender
{
    [self.keyboard showWithCompletion:^{
        [self enableHideKeyboard];
    }];
}

- (IBAction)hideKeyboard:(id)sender
{
    [self.keyboard hideWithCompletion:^{
        [self enableShowKeyboard];
    }];
}

- (IBAction)configurationSwitchChanged:(UISwitch *)sender
{
    [self applySettings];
}

- (void)applySettings
{
    self.keyboard.shouldAnimate = [self.shouldAnimateSwitch isOn];
    self.keyboard.sendNoteOff = [self.sendNoteOffSwitch isOn];
    self.keyboard.allowPitchControl = [self.enablePitchControlSwitch isOn];
    self.keyboard.useChordDetection = [self.polyphonicSwitch isOn];
    self.keyboard.allowSpelling = [self.enableSpellingSwitch isOn];
    self.keyboard.useDurationControls = [self.enableDurationControlsSwitch isOn];
    self.keyboard.durationControlsActive = [self.durationControlsActiveSwitch isOn];
    self.keyboard.useLocalAudio = [self.localAudioSwitch isOn];
}

- (void)enableShowKeyboard
{
    self.hideKeyboardButton.enabled = NO;
    self.showKeyboardButton.enabled = YES;
}

- (void)enableHideKeyboard
{
    self.hideKeyboardButton.enabled = YES;
    self.showKeyboardButton.enabled = NO;
}


#pragma mark - KZPMusicKeyboardDelegate -


- (void)keyboardDidSendPitchData:(KZPMusicPitchData *)pitchData withDurationData:(KZPMusicDurationData *)durationData
{
    if (durationData) {
        self.durationTextView.text = [NSString stringWithFormat:@"%u%@%@%@",
                                      durationData.duration,
                                      durationData.isRest ? @"\nRest": @"",
                                      durationData.isDotted ? @"\nDotted" : @"",
                                      durationData.isTiedForward ? @"\nTied" : @""];
    }
    
    if (pitchData) {
        self.pitchTextView.text = [pitchData.noteValues oneLineDescriptionUsingDelimiter:@"\n"];
        self.spellingTextView.text = [pitchData.spellings oneLineDescriptionUsingDelimiter:@"\n"];
    }
}

- (void)keyboardDidSendNoteOn:(NSNumber *)noteOnPitch noteOff:(NSNumber *)noteOffPitch
{
    NSLog(@"%@, %@", noteOnPitch, noteOffPitch);
}


#pragma mark - KZPMusicKeyboardControlDelegate


- (void)keyboardWasDismissed
{
    [self enableShowKeyboard];
}

- (void)keyboardDidSendBackspace
{
    self.spellingTextView.text = nil;
    self.pitchTextView.text = nil;
    self.durationTextView.text = nil;
}


@end
