//
//  KZPMusicKeyboardViewController.m
//  Schillinger
//
//  Created by Matt Rankin on 27/06/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import "KZPMusicKeyboardViewController.h"
#import "UIView+frameOperations.h"
#import "KZPMusicKeyboardManager.h"
#import "KZPMusicKeyboardSound.h"

@interface KZPMusicKeyboardViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *keyboardMap;
@property (weak, nonatomic) IBOutlet UIView *keyboardMainView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *keyButtons;
@property (weak, nonatomic) IBOutlet UIView *mapRegionLeftShadow;
@property (weak, nonatomic) IBOutlet UIView *mapRegionRightShadow;
@property (weak, nonatomic) IBOutlet UIView *mapRegionVisible;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *keyboardControlButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *durationButtons;
@property (weak, nonatomic) IBOutlet UIButton *restButton;
@property (weak, nonatomic) IBOutlet UISlider *aggregatorThresholdSlider;
@property (weak, nonatomic) IBOutlet UILabel *aggregatorThresholdLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *accidentalButtons;
@property (weak, nonatomic) IBOutlet UIButton *dotButton;
@property (weak, nonatomic) IBOutlet UIButton *tieButton;

@property (strong, nonatomic) KZPMusicKeyboardSound *keyboardSound;

// Aggregation of note information for the purpose of detecting chords
@property (strong, nonatomic) NSMutableArray *noteIDs;
@property (strong, nonatomic) NSMutableArray *inputTypes;
@property (strong, nonatomic) NSMutableArray *spellings;
@property (strong, nonatomic) NSNumber *selectedDuration;
@property (strong, nonatomic) NSMutableArray *MIDIPackets;
@property (strong, nonatomic) NSMutableArray *OSCPackets;
@property (strong, nonatomic) NSTimer *chordTimer;

@end

@implementation KZPMusicKeyboardViewController

- (NSMutableArray *)noteIDs
{
    if (!_noteIDs) _noteIDs = [NSMutableArray array];
    return _noteIDs;
}

- (NSMutableArray *)inputTypes
{
    if (!_inputTypes) _inputTypes = [NSMutableArray array];
    return _inputTypes;
}

- (NSMutableArray *)spellings
{
    if (!_spellings) _spellings = [NSMutableArray array];
    return _spellings;
}

- (NSMutableArray *)MIDIPackets
{
    if (!_MIDIPackets) _MIDIPackets = [NSMutableArray array];
    return _MIDIPackets;
}

- (NSMutableArray *)OSCPackets
{
    if (!_OSCPackets) _OSCPackets = [NSMutableArray array];
    return _OSCPackets;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.keyboardSound = [[KZPMusicKeyboardSound alloc] init];
    self.mapRegionVisible.layer.borderWidth = 2.0;
    self.mapRegionVisible.layer.borderColor = [UIColor yellowColor].CGColor;
    
    for (UIButton *keyboardControl in self.keyboardControlButtons) {
        keyboardControl.layer.borderWidth = 1.0;
        keyboardControl.layer.cornerRadius = 5.0;
        keyboardControl.clipsToBounds = YES;
        keyboardControl.layer.borderColor = [UIColor darkGrayColor].CGColor;
        keyboardControl.layer.opacity = 0.5;
    }
    
    [self aggregatorThresholdSliderValueChanged:self.aggregatorThresholdSlider];
}

- (IBAction)keyboardMapTapped:(id)sender {
    CGPoint position = [(UITapGestureRecognizer *)sender locationInView:self.keyboardMap];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self panToXPosition:position.x];
    }];
    
}

- (IBAction)keyboardMapPanned:(id)sender {
    CGPoint position = [(UIPanGestureRecognizer *)sender locationInView:self.keyboardMap];
    [self panToXPosition:position.x];
}

- (IBAction)dismissKeyboard:(id)sender {
    if ([self.delegate respondsToSelector:@selector(keyboardWasDismissed)]) {
        [self.delegate keyboardWasDismissed];
    }
}

- (IBAction)backButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(keyboardDidSendBackspace)]) {
        [self.delegate keyboardDidSendBackspace];
    }
}

// TODO: separate note on/off eventually
- (IBAction)keyButtonPressed:(id)sender
{
    NSUInteger noteID = [sender tag];
    [self.keyboardSound playNoteWithID:noteID];
    
    NSNumber *selectedAccidental;
    for (UIButton *accidental in self.accidentalButtons) {
        if (accidental.selected) {
            selectedAccidental = @((noteSpelling)[accidental tag]);
            accidental.selected = NO;
            accidental.layer.opacity = 0.5;
        }
    }
    
    NSNumber *selectedDuration;
    for (UIButton *duration in self.durationButtons) {
        if (duration.selected) {
            selectedDuration = @([duration tag]);
        }
    }
    
    [self.noteIDs addObject:@(noteID)];
    [self.inputTypes addObject:@(KBD__NOTE_ON)];
    if (selectedAccidental) [self.spellings addObject:selectedAccidental];
    self.selectedDuration = selectedDuration;
    [self.MIDIPackets addObject:[NSNull null]];
    [self.OSCPackets addObject:[NSNull null]];
    
    [self.chordTimer invalidate];
    NSUInteger sliderSetting = (NSUInteger)round([self.aggregatorThresholdSlider value]);
    self.chordTimer = [NSTimer scheduledTimerWithTimeInterval:(double)sliderSetting / 1000
                                                       target:self
                                                     selector:@selector(flushAggregatedNoteInformation)
                                                     userInfo:nil
                                                      repeats:NO];
}

- (void)flushAggregatedNoteInformation
{
    if (![self.spellings count]) [self.spellings addObject:@(SP__NATURAL)];
    if ([self.delegate respondsToSelector:@selector(keyboardDidSendSignal:inputType:spelling:duration:dotted:tied:midiPacket:oscPacket:)]) {
        [self.delegate keyboardDidSendSignal:self.noteIDs
                                   inputType:self.inputTypes
                                    spelling:self.spellings
                                    duration:self.selectedDuration
                                      dotted:self.dotButton.selected
                                        tied:self.tieButton.selected
                                  midiPacket:self.MIDIPackets
                                   oscPacket:self.OSCPackets];
    }
    self.noteIDs = nil;
    self.inputTypes = nil;
    self.spellings = nil;
    self.selectedDuration = nil;
    self.MIDIPackets = nil;
    self.OSCPackets = nil;
    self.tieButton.selected = NO;
    self.tieButton.layer.opacity = 0.5;
}


// TODO: MIDI and OSC should operate using Notifications
- (IBAction)durationButtonPress:(id)sender
{
    if (!self.rhythmControlsEnabled) return;
    UIButton *durationButton = (UIButton*)sender;
    
    for (UIButton *duration in self.durationButtons) {
        if (duration == durationButton) {
            durationButton.selected = !durationButton.selected;
        } else {
            duration.selected = NO;
        }
        duration.layer.opacity = duration.selected ? 1.0 : 0.5;
    }
    self.dotButton.selected = !self.dotButton.selected;
    self.dotButton.layer.opacity = self.dotButton.selected ? 1.0 : 0.5;
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
    self.tieButton.selected = NO;
    self.tieButton.layer.opacity = 0.5;
}

- (IBAction)restButtonTouch:(id)sender {
    if (self.rhythmControlsEnabled) {
        [(UIButton *)sender layer].opacity = 1.0;
    }
}

- (IBAction)accidentalButtonPress:(id)sender {
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

- (IBAction)aggregatorThresholdSliderValueChanged:(id)sender {
    NSUInteger sliderSetting = (NSUInteger)round([(UISlider *)sender value]);
    self.aggregatorThresholdLabel.text = [NSString stringWithFormat:@"Chord: %dms", sliderSetting];
}


#pragma mark - Keyboard Map -

- (void)panToRangeWithCenterNote:(NSUInteger)noteID animated:(BOOL)animated
{
    CGFloat positionX = (double)(noteID - 21) / 88 * self.keyboardMap.frame.size.width;
    [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
        [self panToXPosition:positionX];
    }];
}


#define KEYBOARD_MAP_OVERHANG   25

- (void)panToXPosition:(float)x
{
    CGFloat relativePosition = x / self.keyboardMap.frame.size.width;
    [self.keyboardMainView setFrameX:-( (self.keyboardMainView.frame.size.width - self.view.frame.size.width) * relativePosition )];
    
    [self updateMapRegionWindow:-KEYBOARD_MAP_OVERHANG + relativePosition * (self.keyboardMap.frame.size.width + KEYBOARD_MAP_OVERHANG * 2 - self.mapRegionVisible.frame.size.width)];
}

- (void)updateMapRegionWindow:(CGFloat)leftX
{
    [self.mapRegionVisible setFrameX:leftX];
    [self.mapRegionLeftShadow setFrameX:0];
    [self.mapRegionLeftShadow setFrameWidth:leftX < 0 ? 0 : leftX];
    [self.mapRegionRightShadow setFrameX:leftX + self.mapRegionVisible.frame.size.width];
}


@end
