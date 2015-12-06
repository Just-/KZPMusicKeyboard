//
//  ViewController.m
//  KZPMusicKeyboardDemo
//
//  Created by Matt Rankin on 28/08/2014.
//  Copyright (c) 2014 Sudoseng. All rights reserved.
//

#import "ViewController.h"
#import "KZPMusicKeyboard.h"
//#import "NSArray+functions"

@interface ViewController <KZPMusicKeyboardDelegate>

@property (weak, nonatomic) KZPMusicKeyboard *keyboard;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.keyboard = [KZPMusicKeyboard keyboard];
}

- (IBAction)showKeyboard:(id)sender
{
    [[KZPMusicKeyboard keyboard] setDelegate:self];
    [[KZPMusicKeyboard keyboard] show];
}

- (IBAction)hideKeyboard:(id)sender
{
    [[KZPMusicKeyboard keyboard] hide];
}

- (IBAction)shouldAnimateSwitchDidChange:(UISwitch *)sender
{
    self.keyboard = [sender isOn];
}

- (IBAction)sendNoteOffSwitchDidChange:(UISwitch *)sender
{
}

- (IBAction)enableKeyboardSwitchDidChange:(UISwitch *)sender
{
}

- (IBAction)enablePolyphonySwitchDidChange:(UISwitch *)sender
{
}

- (IBAction)enableSpellingSwitchDidChange:(UISwitch *)sender
{
}

- (IBAction)enableDurationSwitchDidChange:(UISwitch *)sender
{
}

- (IBAction)durationsActiveSwitchDidChange:(UISwitch *)sender
{
}

- (IBAction)localSoundSwitchDidChange:(UISwitch *)sender
{
}

- (IBAction)enableBackspaceSwitchDidChange:(UISwitch *)sender
{
}

- (IBAction)enableDismissSwitchDidChange:(UISwitch *)sender
{
}

- (IBAction)shouldAnimateDidChange:(id)sender
{
}


#pragma mark - KZPMusicKeyboardDelegate -

// Ideal - put relevant enum etc into these new classes
- (void)keyboardDidSendPitchData:(KZPMusicPitchData *)pitchData withDurationData:(KZPMusicDurationData *)durationData
{
    if (durationData) {
        self.durationTextView.text = [NSString stringWithFormat:@"%d%@%@",
                                      durationData.duration,
                                      durationData.isRest ? @"\nRest": @"",
                                      durationData.isDotted ? @"\nDotted" : @"",
                                      durationData.isTiedForward ? @"\Tied" : @""];
    }
    
    if (pitchData) {
        self.pitchTextView.text = [pitchData.noteValues oneLineDescriptionUsingDelimiter:@"\n"];
        self.spellingTextView.text = [pitchData.spellings oneLineDescriptionUsingDelimiter:@"\n"];
    }
}

- (void)keyboardWasDismissed
{
    self.keyboard
    [[KZPMusicKeyboardManager defaultManager] hideControllerWithCompletionBlock:^{
        self.showKeyboardButton.enabled = YES;
    } deactivate:YES];
}

- (void)keyboardDidSendBackspace
{
    self.spellingTextView.text = nil;
    self.pitchTextView.text = nil;
    self.durationTextView.text = nil;
}


@end
