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
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *durationControlButtons;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (UIButton *control in self.keyboardControlButtons) {
        [self styleControl:control];
        if (control != self.backspaceButton && control != self.dismissButton) {
            [self deselectControl:control];
        }
    }
    
    [self chordThresholdSliderValueChanged:self.chordThresholdSlider];
}

- (void)enableBackspace:(BOOL)backspaceEnabled
{
    backspaceEnabled ? [self enableControl:self.backspaceButton] : [self disableControl:self.backspaceButton];
    _backspaceEnabled = backspaceEnabled;
}

- (void)enableDismiss:(BOOL)dismissEnabled
{
    dismissEnabled ? [self enableControl:self.dismissButton] : [self disableControl:self.dismissButton];
    _dismissEnabled = dismissEnabled;
}

- (void)enableDurationControls:(BOOL)durationControlsEnabled
{
    for (UIButton *duration in self.durationControlButtons) {
        durationControlsEnabled ? [self enableControl:duration] : [self disableControl:duration];
        if ([duration tag] == 1 && [self durationControlsActive]) {
            [self selectControl:duration];
        }
    }
    _durationControlsEnabled = durationControlsEnabled;
}

- (void)enableSpelling:(BOOL)spellingEnabled
{
    for (UIButton *spelling in self.spellingButtons) {
        spellingEnabled ? [self enableControl:spelling] : [self disableControl:spelling];
    }
    _spellingEnabled = spellingEnabled;
}


#pragma mark - Actions -


- (IBAction)accidentalButtonPress:(UIButton *)sender
{
    for (UIButton *accidental in self.spellingButtons) {
        if (sender == accidental) {
            [self toggleControl:sender];
        } else {
            [self deselectControl:accidental];
        }
    }
}

- (IBAction)restButtonTouch:(UIButton *)sender
{
    if ([self durationControlsActive]) {
        [self toggleControl:sender];
    } else {
        [self selectControl:sender];
        [self sendDuration];
    }
}

- (IBAction)restButtonPress:(UIButton *)sender
{
    if (![self durationControlsActive]) {
        [self deselectControl:sender];
    }
}

- (IBAction)durationButtonTouch:(UIButton *)sender
{
    if ([self durationControlsActive]) {
        [self selectControl:sender];
        [self sendDuration];
    } else {
        for (UIButton *duration in self.durationButtons) {
            if (duration == sender) {
                [self selectControl:duration];
            } else {
                [self deselectControl:duration];
            }
        }
    }
}

- (IBAction)durationButtonPress:(UIButton *)sender
{
    if ([self durationControlsActive]) {
        [self deselectControl:sender];
    }
}

- (IBAction)dotButtonPress:(UIButton *)sender
{
    [self toggleControl:sender];
}

- (IBAction)tieButtonPress:(UIButton *)sender
{
    [self toggleControl:sender];
}


- (IBAction)backButtonPressed:(UIButton *)sender
{
    if ([self.controlDelegate respondsToSelector:@selector(keyboardDidSendBackspace)]) {
        [self.controlDelegate keyboardDidSendBackspace];
    }
}

- (IBAction)toneSelected:(id)sender
{
    //    self.soundBankPlayer = [[SoundBankPlayer alloc] init];
    //    [self.soundBankPlayer setSoundBank:[self.toneSelector titleForSegmentAtIndex:[self.toneSelector selectedSegmentIndex]]];
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
    self.chordThresholdLabel.text = [NSString stringWithFormat:@"Chord: %lums", (unsigned long)sliderSetting];
    self.musicDataAggregator.chordSensitivity = sliderSetting;
}


#pragma mark -


- (void)sendDurationAndSpelling
{
    [self sendDuration];
    [self.musicDataAggregator receiveSpelling:[self selectedAccidental]];
    [self resetSpelling];
}

- (void)sendDuration
{
    unsigned int duration = [self selectedDuration];
    [self.musicDataAggregator receiveDuration:self.restButton.selected ? -duration : duration
                                         rest:self.restButton.selected
                                       dotted:self.dottedButton.selected
                                         tied:self.tieButton.selected];
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

- (void)resetSpelling
{
    for (UIButton *accidental in self.spellingButtons) {
        accidental.selected = NO;
        accidental.alpha = 0.5;
    }
}

- (void)resetDuration
{
    self.tieButton.selected = NO;
    self.tieButton.layer.opacity = 0.5;
    self.manualSpellButton.selected = NO;
    self.manualSpellButton.layer.opacity = 0.5;
}

- (NSString *)selectedPatch
{
    return [self.toneSelector titleForSegmentAtIndex:[self.toneSelector selectedSegmentIndex]];
}

- (void)styleControl:(UIButton *)control
{
    control.layer.borderWidth = 1.0;
    control.layer.cornerRadius = 5.0;
    control.clipsToBounds = YES;
    control.layer.borderColor = [UIColor darkGrayColor].CGColor;
}

- (void)toggleControl:(UIButton *)control
{
    control.selected ? [self deselectControl:control] : [self selectControl:control];
}

- (void)selectControl:(UIButton *)control
{
    if (control.enabled) {
        control.selected = YES;
        control.alpha = 1.0;
    }
}

- (void)deselectControl:(UIButton *)control
{
    control.selected = NO;
    control.alpha = 0.5;
}

- (void)disableControl:(UIButton *)control
{
    control.selected = NO;
    control.enabled = NO;
    control.alpha = 0.15;
}

- (void)enableControl:(UIButton *)control
{
    control.selected = NO;
    control.enabled = YES;
    control.alpha = 0.5;
}

@end
