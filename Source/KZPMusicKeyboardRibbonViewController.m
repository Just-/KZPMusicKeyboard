//
//  KZPMusicKeyboardRibbonViewController.m
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import "KZPMusicKeyboardRibbonViewController.h"
#import "KZPMusicKeyboardRibbonButton.h"

@interface KZPMusicKeyboardRibbonViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *keyboardControlButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *durationControlButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *durationButtons;
@property (weak, nonatomic) IBOutlet KZPMusicKeyboardRibbonButton *restButton;
@property (weak, nonatomic) IBOutlet UISlider *chordThresholdSlider;
@property (weak, nonatomic) IBOutlet UILabel *chordThresholdLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *spellingButtons;
@property (weak, nonatomic) IBOutlet KZPMusicKeyboardRibbonButton *dottedButton;
@property (weak, nonatomic) IBOutlet KZPMusicKeyboardRibbonButton *tieButton;
@property (weak, nonatomic) IBOutlet KZPMusicKeyboardRibbonButton *manualSpellButton;
@property (weak, nonatomic) IBOutlet KZPMusicKeyboardRibbonButton *backspaceButton;
@property (weak, nonatomic) IBOutlet KZPMusicKeyboardRibbonButton *dismissButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *toneSelector;

@end


@implementation KZPMusicKeyboardRibbonViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (KZPMusicKeyboardRibbonButton *control in self.keyboardControlButtons) {
        [control style];
        if (control != self.backspaceButton && control != self.dismissButton) {
            [control deselect];
        }
    }
    
    [self chordThresholdSliderValueChanged:self.chordThresholdSlider];
}


#pragma mark - Properties -


- (void)enableBackspace:(BOOL)backspaceEnabled
{
    _backspaceEnabled = backspaceEnabled;
    backspaceEnabled ? [self.backspaceButton enable] : [self.backspaceButton disable];
    [self.backspaceButton select];
}

- (void)enableDismiss:(BOOL)dismissEnabled
{
    _dismissEnabled = dismissEnabled;
    dismissEnabled ? [self.dismissButton enable] : [self.dismissButton disable];
    [self.dismissButton select];
}

- (void)enableDurationControls:(BOOL)durationControlsEnabled
{
    _durationControlsEnabled = durationControlsEnabled;
    for (KZPMusicKeyboardRibbonButton *duration in self.durationControlButtons) {
        durationControlsEnabled ? [duration enable] : [duration disable];
    }
    [self resetDefaultDuration];
}

- (void)enableSpelling:(BOOL)spellingEnabled
{
    _spellingEnabled = spellingEnabled;
    for (KZPMusicKeyboardRibbonButton *spelling in self.spellingButtons) {
        spellingEnabled ? [spelling enable] : [spelling disable];
    }
    if (!spellingEnabled) self.musicDataAggregator.manualSpellingEnabled = NO;
}

- (void)setDurationControlsActive:(BOOL)durationControlsActive
{
    _durationControlsActive = durationControlsActive;
    if (durationControlsActive) {
        for (KZPMusicKeyboardRibbonButton *duration in self.durationControlButtons) {
            [duration deselect];
        }
    } else {
        [self resetDefaultDuration];
    }
}

- (void)resetDefaultDuration
{
    for (KZPMusicKeyboardRibbonButton *duration in self.durationControlButtons) {
        if ([duration tag] == 1 && ![self durationControlsActive]) {
            [duration select];
        }
    }
}


#pragma mark - Actions -


- (IBAction)accidentalButtonPress:(KZPMusicKeyboardRibbonButton *)sender
{
    for (KZPMusicKeyboardRibbonButton *accidental in self.spellingButtons) {
        if (sender == accidental) {
            [sender toggle];
        } else {
            [accidental deselect];
        }
    }
    self.musicDataAggregator.manualSpellingEnabled = self.manualSpellButton.selected;
}

- (IBAction)restButtonTouch:(KZPMusicKeyboardRibbonButton *)sender
{
    if ([self durationControlsActive]) {
        [sender toggle];
    } else {
        [sender select];
        [self sendDuration];
        [self.musicDataAggregator flush];
    }
}

- (IBAction)restButtonPress:(KZPMusicKeyboardRibbonButton *)sender
{
    if (![self durationControlsActive]) {
        [sender deselect];
    }
}

- (IBAction)durationButtonTouch:(KZPMusicKeyboardRibbonButton *)sender
{
    if ([self durationControlsActive]) {
        [sender select];
        [self sendDuration];
        [self.musicDataAggregator flush];
    } else {
        for (KZPMusicKeyboardRibbonButton *duration in self.durationButtons) {
            if (duration == sender) {
                [duration select];
            } else {
                [duration deselect];
            }
        }
    }
}

- (IBAction)durationButtonPress:(KZPMusicKeyboardRibbonButton *)sender
{
    if ([self durationControlsActive]) {
        [sender deselect];
    }
}

- (IBAction)dotButtonPress:(KZPMusicKeyboardRibbonButton *)sender
{
    [sender toggle];
}

- (IBAction)tieButtonPress:(KZPMusicKeyboardRibbonButton *)sender
{
    [sender toggle];
}


- (IBAction)backButtonPressed:(KZPMusicKeyboardRibbonButton *)sender
{
    if ([self.controlDelegate respondsToSelector:@selector(keyboardDidSendBackspace)]) {
        [self.controlDelegate keyboardDidSendBackspace];
    }
}

- (IBAction)toneSelected:(id)sender
{
    [self.delegate playbackToneChanged];
}

- (IBAction)dismissButtonPressed:(UIButton *)sender
{
    if ([self.controlDelegate respondsToSelector:@selector(keyboardWasDismissed)]) {
        [self.controlDelegate keyboardWasDismissed];
    }
}

- (IBAction)chordThresholdSliderValueChanged:(UISlider *)sender
{
    NSUInteger sliderSetting = (NSUInteger)round([sender value]);
    self.musicDataAggregator.chordSensitivity = sliderSetting;
    [self displayChordSensitivity:sliderSetting];
}

- (void)displayChordSensitivity:(NSUInteger)sensitivity
{
    self.chordThresholdLabel.text = [NSString stringWithFormat:@"Chord: %lums", (unsigned long)sensitivity];
}


#pragma mark -


- (void)sendDurationAndSpelling
{
    if ([self durationControlsEnabled]) {
        [self sendDuration];
    }
    if ([self spellingEnabled]) {
        [self.musicDataAggregator receiveSpelling:[self selectedAccidental]];
    }
}

- (void)sendDuration
{
    unsigned int duration = [self selectedDuration];
    [self.musicDataAggregator receiveDuration:duration
                                         rest:self.restButton.selected
                                       dotted:self.dottedButton.selected
                                         tied:self.restButton.selected ? NO : self.tieButton.selected];
}

- (unsigned int)selectedDuration
{
    for (UIButton *duration in self.durationButtons) {
        if (duration.selected) {
            return (unsigned int)[duration tag];
        }
    }
    return 0;
}

- (MusicSpelling)selectedAccidental
{
    for (UIButton *accidental in self.spellingButtons) {
        if (accidental.selected && accidental.tag) {
            return (MusicSpelling)[accidental tag];
        }
    }
    return MusicSpelling_Natural;
}

// TODO: What is this for?
- (void)resetDuration
{
    [self.tieButton deselect];
    [self.manualSpellButton deselect];
}

- (void)resetChordSensitivitySlider
{
    NSUInteger sensitivity = [self.musicDataAggregator chordSensitivity];
    [self.chordThresholdSlider setValue:sensitivity];
    [self displayChordSensitivity:sensitivity];
}

- (NSString *)selectedPatch
{
    return [self.toneSelector titleForSegmentAtIndex:[self.toneSelector selectedSegmentIndex]];
}

@end
