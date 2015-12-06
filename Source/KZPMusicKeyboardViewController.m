//
//  KZPMusicKeyboardViewController.m
//  Schillinger
//
//  Created by Matt Rankin on 27/06/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import "KZPMusicKeyboardViewController.h"
#import "UIView+frameOperations.h"
#import "KZPMusicKeyboardAudio.h"
#import "KZPMusicSciNotation.h"
#import "UIView+frameOperations.h"

@interface KZPMusicKeyboardViewController ()

@property (weak, nonatomic) IBOutlet UIView *keyboardMainView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *keyButtons;

@property (weak, nonatomic) IBOutlet UIView *keyboardDefocusView;

@property (strong, nonatomic) KZPMusicKeyboardAudio *localAudio;

@end

@implementation KZPMusicKeyboardViewController

//- (NSMutableDictionary *)spellingButtons
//{
//    if (!_spellingButtons) _spellingButtons = [NSMutableDictionary dictionary];
//    return _spellingButtons;
//}
//
//- (NSMutableArray *)noteIDs
//{
//    if (!_noteIDs) _noteIDs = [NSMutableArray array];
//    return _noteIDs;
//}
//
//- (NSMutableArray *)inputTypes
//{
//    if (!_inputTypes) _inputTypes = [NSMutableArray array];
//    return _inputTypes;
//}
//
//- (NSMutableArray *)spellings
//{
//    if (!_spellings) _spellings = [NSMutableArray array];
//    return _spellings;
//}


- (void)setKeyboardEnabled:(BOOL)keyboardEnabled
{
    if (keyboardEnabled) {
        self.keyboardDefocusView.hidden = YES;
        self.keyboardDefocusView.alpha = 0.0;
    } else {
        self.keyboardDefocusView.hidden = NO;
        self.keyboardDefocusView.alpha = 0.5;
        for (UIButton *accidental in self.accidentalButtons) {
            accidental.selected = NO;
            accidental.layer.opacity = 0.5;
        }
    }
    _keyboardEnabled = keyboardEnabled;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.soundBankPlayer = [[SoundBankPlayer alloc] init];
    [self.soundBankPlayer setSoundBank:[self.toneSelector titleForSegmentAtIndex:[self.toneSelector selectedSegmentIndex]]];
    
    for (UIButton *keyButton in self.keyButtons) {
        [keyButton addTarget:self action:@selector(keyButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
        [keyButton addTarget:self action:@selector(keyButtonReleased:) forControlEvents:UIControlEventTouchUpOutside];
        
        //  What about drag events?
    }
    
    self.mapRegionVisible.layer.borderWidth = 2.0;
    self.mapRegionVisible.layer.borderColor = [UIColor yellowColor].CGColor;
    self.keyboardDefocusView.hidden = YES;
    self.keyboardDefocusView.alpha = 0.0;
    UITapGestureRecognizer *refocusGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refocusKeyboard)];
    [self.keyboardDefocusView addGestureRecognizer:refocusGesture];

    [self aggregatorThresholdSliderValueChanged:self.aggregatorThresholdSlider];
}

- (IBAction)toneSelected:(id)sender {
    self.soundBankPlayer = [[SoundBankPlayer alloc] init];
    [self.soundBankPlayer setSoundBank:[self.toneSelector titleForSegmentAtIndex:[self.toneSelector selectedSegmentIndex]]];
}










#pragma mark - Pitch -


// TODO: separate note on/off eventually
- (IBAction)keyButtonPressed:(id)sender
{
    NSUInteger noteID = [sender tag];
    [self.localAudio noteOn:noteID];
    [self.musicDataAggregator receiveDuration:[self.controlRibbon selectedDuration]];
    [self.musicDataAggregator receiveSpelling:[self.controlRibbon selectedAccidental]];
    [self.controlRibbon resetSpelling];
    
    

    
    [self.noteIDs addObject:@(noteID)];
    [self.inputTypes addObject:@(KBD__NOTE_ON)];
    if (selectedAccidental) [self.spellings addObject:selectedAccidental];
    self.selectedDuration = selectedDuration;
    
    [self.chordTimer invalidate];
    
    if (self.chordsEnabled) {
        NSUInteger sliderSetting = (NSUInteger)round([self.aggregatorThresholdSlider value]);
        self.chordTimer = [NSTimer scheduledTimerWithTimeInterval:(double)sliderSetting / 1000
                                                           target:self
                                                         selector:@selector(flushAggregatedNoteInformation)
                                                         userInfo:nil
                                                          repeats:NO];
    } else {
        [self flushAggregatedNoteInformation];
    }
}

- (IBAction)keyButtonReleased:(id)sender
{
    NSUInteger noteID = [sender tag];
    [self.localAudio noteOff:noteID];
}



#pragma mark - Rhythm -










@end
