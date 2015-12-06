//
//  KZPMusicKeyboardRibbonViewController.m
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import "KZPMusicKeyboardRibbonViewController.h"

@interface KZPMusicKeyboardRibbonViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *keyboardControlButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *durationButtons;
@property (weak, nonatomic) IBOutlet UIButton *restButton;
@property (weak, nonatomic) IBOutlet UISlider *chordThresholdSlider;
@property (weak, nonatomic) IBOutlet UILabel *chordThresholdLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *spellingButtons;
@property (weak, nonatomic) IBOutlet UIButton *dottedButton;
@property (weak, nonatomic) IBOutlet UIButton *tieButton;
@property (weak, nonatomic) IBOutlet UIButton *manualSpellButton;
@property (weak, nonatomic) IBOutlet UIButton *backspaceButton;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *toneSelector;

@end

@implementation KZPMusicKeyboardRibbonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIButton *keyboardControl in self.keyboardControlButtons) {
        keyboardControl.layer.borderWidth = 1.0;
        keyboardControl.layer.cornerRadius = 5.0;
        keyboardControl.clipsToBounds = YES;
        keyboardControl.layer.borderColor = [UIColor darkGrayColor].CGColor;
        if (keyboardControl != self.backspaceButton && keyboardControl != self.dismissButton) {
            keyboardControl.layer.opacity = 0.5;
        }
    }
}


- (void)setRhythmControlsEnabled:(BOOL)rhythmControlsEnabled
{
    for (UIButton *duration in self.durationButtons) {
        duration.selected = NO;
        duration.layer.opacity = 0.5;
    }
    if (rhythmControlsEnabled) {
        for (UIButton *duration in self.durationButtons) {
            if ([duration tag] == 1) {
                duration.selected = YES;
                duration.layer.opacity = 1.0;
            }
        }
    }
    _rhythmControlsEnabled = rhythmControlsEnabled;
}


#pragma mark - Actions -


- (IBAction)accidentalButtonPress:(id)sender {
    if (!self.keyboardEnabled) return;
    
    UIButton *accidentalButton = (UIButton*)sender;
    for (UIButton *accidental in self.accidentalButtons) {
        if (accidental == accidentalButton) {
            accidentalButton.selected = !accidentalButton.selected;
        } else {
            accidental.selected = NO;
        }
        accidental.layer.opacity = accidental.selected ? 1.0 : 0.5;
    }
}

- (IBAction)backButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(keyboardDidSendBackspace)]) {
        [self.delegate keyboardDidSendBackspace];
    }
}

- (IBAction)dismissButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(keyboardWasDismissed)]) {
        [self.delegate keyboardWasDismissed];
    }
}

- (IBAction)durationButtonPress:(id)sender
{
    if (!self.rhythmControlsEnabled) return;
    
    // Rhythm controls are treated as settings for pitch durations
    if (self.rhythmMode == KZPMusicKeyboardRhythmMode_Passive) {
        UIButton *durationButton = (UIButton*)sender;
        
        for (UIButton *duration in self.durationButtons) {
            if (duration == durationButton) {
                durationButton.selected = !durationButton.selected;
            } else {
                if (duration.selected) {
                    self.dotButton.selected = NO;
                    self.dotButton.layer.opacity = 0.5;
                }
                duration.selected = NO;
            }
            duration.layer.opacity = duration.selected ? 1.0 : 0.5;
        }
    }
    
    // Rhythm controls are used to express rhythms on their own, without pitch information
    else {
        [(UIButton *)sender layer].opacity = 0.5;
        int duration = [(UIButton *)sender tag];
        if (self.restButton.selected) {
            duration = -duration;
        }
        NSNumber *selectedDuration = @(duration);
        [self.delegate keyboardDidSendSignal:nil
                                   inputType:nil
                                    spelling:nil
                                    duration:selectedDuration
                                      dotted:self.dotButton.selected
                                        tied:self.tieButton.selected
                                  midiPacket:nil
                                   oscPacket:nil];
        
    }
    
}

- (IBAction)durationButtonTouch:(id)sender {
    if (self.rhythmControlsEnabled) {
        [(UIButton *)sender layer].opacity = 1.0;
    }
}

- (IBAction)dotButtonPress:(id)sender
{
    if (!self.rhythmControlsEnabled) return;
    self.dotButton.selected = !self.dotButton.selected;
    self.dotButton.layer.opacity = self.dotButton.selected ? 1.0 : 0.5;
}

- (IBAction)tieButtonPress:(id)sender
{
    if (!self.rhythmControlsEnabled) return;
    self.tieButton.selected = !self.tieButton.selected;
    self.tieButton.layer.opacity = self.tieButton.selected ? 1.0 : 0.5;
}

- (IBAction)restButtonPress:(id)sender
{
    if (!self.rhythmControlsEnabled) return;
    
    self.tieButton.selected = NO;
    self.tieButton.layer.opacity = 0.5;
    
    // Rest is acknowledged immediately
    if (self.rhythmMode == KZPMusicKeyboardRhythmMode_Passive) {
        [(UIButton *)sender layer].opacity = 0.5;
        for (UIButton *duration in self.durationButtons) {
            if (duration.selected) {
                NSNumber *selectedDuration = @(-[duration tag]);
                [self.delegate keyboardDidSendSignal:nil
                                           inputType:nil
                                            spelling:nil
                                            duration:selectedDuration
                                              dotted:self.dotButton.selected
                                                tied:NO
                                          midiPacket:nil
                                           oscPacket:nil];
            }
        }
    }
    
    // Rest is treated as a toggle
    else if (self.rhythmMode == KZPMusicKeyboardRhythmMode_Active) {
        self.restButton.selected = !self.restButton.selected;
        self.restButton.layer.opacity = self.restButton.selected ? 1.0 : 0.5;
    }
    
}

- (IBAction)restButtonTouch:(id)sender {
    if (self.rhythmControlsEnabled) {
        [(UIButton *)sender layer].opacity = 1.0;
    }
}

- (IBAction)aggregatorThresholdSliderValueChanged:(id)sender {
    NSUInteger sliderSetting = (NSUInteger)round([(UISlider *)sender value]);
    self.aggregatorThresholdLabel.text = [NSString stringWithFormat:@"Chord: %dms", sliderSetting];
}

- (MusicSpelling)selectedAccidental {
    for (UIButton *accidental in self.spellingButtons) {
        if (accidental.selected && accidental.tag) {
            return (MusicSpelling)[accidental tag];
        }
    }
    return MusicSpelling_Natural;
}

- (void)resetSpelling
{
    for (UIButton *accidental in self.spellingButtons) {
        accidental.selected = NO;
        accidental.layer.opacity = 0.5;
    }
}

- (unsigned int)selectedDuration
{
    for (UIButton *duration in self.durationButtons) {
        if (duration.selected) {
            return [duration tag];
        }
    }
    return 0;
}


@end
