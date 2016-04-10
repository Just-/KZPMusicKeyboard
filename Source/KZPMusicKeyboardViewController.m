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
#import "KZPMusicKeyboardMapViewController.h"
#import "KZPMusicKeyboardRibbonViewController.h"
#import "KZPMusicKeyboardDataAggregator.h"
#import "UIView+frameOperations.h"
#import "KZPMusicKeyboardSpellingViewController.h"


@interface KZPMusicKeyboardViewController () <KZPMusicKeyboardMapDelegate, KZPMusicKeyboardRibbonControlDelegate, KZPMusicKeyboardSpellingDelegate>

@property (weak, nonatomic) IBOutlet UIView *keyboardMainView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *keyButtons;
@property (weak, nonatomic) IBOutlet UIView *keyboardDefocusView;

@property (weak, nonatomic) id<KZPMusicKeyboardDataDelegate> musicalDelegate;

@property (nonatomic) BOOL ribbonVisible;
@property (strong, nonatomic) KZPMusicKeyboardRibbonViewController *controlRibbon;
@property (strong, nonatomic) KZPMusicKeyboardMapViewController *keyboardMapViewController;
@property (strong, nonatomic) KZPMusicKeyboardSpellingViewController *spellingSurfaceViewController;

@property (strong, nonatomic) KZPMusicKeyboardAudio *localAudioPlayer;
@property (strong, nonatomic) KZPMusicKeyboardDataAggregator *musicDataAggregator;

@property (nonatomic) BOOL chordSensitivityWasSetProgrammatically;

@end


@implementation KZPMusicKeyboardViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.musicDataAggregator = [[KZPMusicKeyboardDataAggregator alloc] init];

    [self applyKeyboardHighlightImages];
    [self loadControlRibbon];
    [self loadKeyboardMap];
    [self loadSpellingSurface];
    [self loadLocalAudio];
    [self setupKeyReleaseAction];
    [self focusKeyboardAnimated:NO];
}

- (void)registerControlDelegate:(id<KZPMusicKeyboardControlDelegate>)controlDelegate
{
    self.controlRibbon.controlDelegate = controlDelegate;
}

- (void)registerMusicDelegate:(id<KZPMusicKeyboardDataDelegate>)musicalDelegate
{
    self.musicalDelegate = musicalDelegate;
    self.musicDataAggregator.musicalDelegate = musicalDelegate;
}

- (void)applyKeyboardHighlightImages
{
    UIImage *ivoryKeydown = [UIImage imageNamed:@"ivory_keydown.png"];
    UIImage *ebonyKeydown = [UIImage imageNamed:@"ebony_keydown.png"];
    for (UIButton *key in self.keyButtons) {
        if ([KZPMusicSciNotation noteIsWhite:(int)[key tag]]) {
            [key setImage:ivoryKeydown forState:UIControlStateHighlighted];
        } else {
            [key setImage:ebonyKeydown forState:UIControlStateHighlighted];
        }
    }
}

- (void)loadKeyboardMap
{
    self.keyboardMapViewController = [[KZPMusicKeyboardMapViewController alloc] initWithNibName:@"KZPMusicKeyboardMapView" bundle:[NSBundle bundleForClass:[self class]]];
    self.keyboardMapViewController.delegate = self;
    [self.keyboardMapViewController.view setFrameY:self.controlRibbon.view.frame.size.height];
    [self.view addSubview:self.keyboardMapViewController.view];
}

- (void)loadControlRibbon
{
    self.controlRibbon = [[KZPMusicKeyboardRibbonViewController alloc] initWithNibName:@"KZPMusicKeyboardRibbonView" bundle:[NSBundle bundleForClass:[self class]]];
    self.controlRibbon.musicDataAggregator = self.musicDataAggregator;
    self.controlRibbon.delegate = self;
    [self.view addSubview:self.controlRibbon.view];
    self.ribbonVisible = YES;
}

- (void)loadSpellingSurface
{
    self.spellingSurfaceViewController = [[KZPMusicKeyboardSpellingViewController alloc] init];
    self.spellingSurfaceViewController.musicDataAggregator = self.musicDataAggregator;
    self.spellingSurfaceViewController.delegate = self;
    self.spellingSurfaceViewController.spellingSurface = self.keyboardMainView;
    NSMutableDictionary *keyButtonsByNoteID = [NSMutableDictionary dictionary];
    for (UIButton *key in self.keyButtons) {
        [keyButtonsByNoteID setObject:key forKey:@([key tag])];
    }
    self.spellingSurfaceViewController.keyButtonsByNoteID = [NSDictionary dictionaryWithDictionary:keyButtonsByNoteID];
}

- (void)loadLocalAudio
{
    self.localAudioPlayer = [[KZPMusicKeyboardAudio alloc] init];
    self.localAudioPlayer.patch = [self.controlRibbon selectedPatch];
}

- (void)reconfigureForSettings
{
    if (![self.controlRibbon spellingEnabled] &&
        ![self.controlRibbon durationControlsEnabled] &&
        ![self.controlRibbon dismissEnabled] &&
        ![self.controlRibbon backspaceEnabled] &&
        (![self.musicDataAggregator chordDetectionEnabled] || self.chordSensitivityWasSetProgrammatically)) {
        if (self.ribbonVisible) [self hideControlRibbon];
    } else {
        if (!self.ribbonVisible) [self showControlRibbon];
    }
}

- (void)hideControlRibbon
{
    self.controlRibbon.view.hidden = YES;
    CGFloat controlRibbonHeight = self.controlRibbon.view.frame.size.height;
    [self.keyboardMainView setFrameY:self.keyboardMainView.frame.origin.y - controlRibbonHeight + 3];
    [self.keyboardMapViewController.view setFrameY:self.keyboardMapViewController.view.frame.origin.y - controlRibbonHeight + 3];
    self.ribbonVisible = NO;
}

- (void)showControlRibbon
{
    self.controlRibbon.view.hidden = NO;
    CGFloat controlRibbonHeight = self.controlRibbon.view.frame.size.height;
    [self.keyboardMainView setFrameY:self.keyboardMainView.frame.origin.y + controlRibbonHeight - 3];
    [self.keyboardMapViewController.view setFrameY:self.keyboardMapViewController.view.frame.origin.y + controlRibbonHeight - 3];
    self.ribbonVisible = YES;
}

- (CGFloat)height
{
    CGFloat controlRibbonHeight = self.controlRibbon.view.frame.size.height;
    CGFloat keyboardMapHeight = self.keyboardMapViewController.view.frame.size.height;
    CGFloat keyboardHeight = self.keyboardMainView.frame.size.height;
    return (self.controlRibbon.view.hidden ? 3 : controlRibbonHeight) + keyboardMapHeight + keyboardHeight;
}


#pragma mark - KZPMusicKeyboardMapDelegate -


- (void)updateKeyboardPosition:(float)relativePosition
{
    [self.keyboardMainView setFrameX:-( (self.keyboardMainView.frame.size.width - self.view.frame.size.width) * relativePosition )];
}


#pragma mark - KZPMusicKeyboardRibbonControlDelegate -


- (void)playbackToneChanged
{
    self.localAudioPlayer.patch = [self.controlRibbon selectedPatch];
}


#pragma mark - KZPMusicKeyboardSpellingDelegate -


- (void)showSpellingSurface
{
    [self defocusKeyboardAnimated:YES light:YES];
}

- (void)hideSpellingSurface
{
    [self focusKeyboardAnimated:YES];
}


#pragma mark -


- (void)focusKeyboardAnimated:(BOOL)animated
{
    if ([self pitchControlEnabled]) {
        [UIView animateWithDuration:animated ? 0.3 : 0.0 animations:^{
            self.keyboardDefocusView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.keyboardDefocusView.hidden = YES;
        }];
    }
}

- (void)defocusKeyboardAnimated:(BOOL)animated light:(BOOL)light
{
    float lightness = light ? 0.3 : 0.5;
    self.keyboardDefocusView.hidden = NO;
    [UIView animateWithDuration:animated ? 0.2 : 0.0 animations:^{
        self.keyboardDefocusView.alpha = lightness;
    }];
}

- (void)setupKeyReleaseAction
{
    for (UIButton *keyButton in self.keyButtons) {
        [keyButton addTarget:self action:@selector(keyButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
        [keyButton addTarget:self action:@selector(keyButtonReleased:) forControlEvents:UIControlEventTouchUpOutside];
    }
}

- (IBAction)keyButtonPressed:(id)sender
{
    NSUInteger noteID = [sender tag];
    if ([self localAudioEnabled]) {
        [self.localAudioPlayer noteOn:noteID];
    }
    [self.controlRibbon sendDurationAndSpelling];    
    [self.musicDataAggregator receivePitch:noteID];
    if ([self.musicalDelegate respondsToSelector:@selector(keyboardDidSendNoteOn:noteOff:)]) {
        [self.musicalDelegate keyboardDidSendNoteOn:@(noteID) noteOff:nil];
    }
}

- (IBAction)keyButtonReleased:(id)sender
{
    NSUInteger noteID = [sender tag];
    if ([self localAudioEnabled]) {
        [self.localAudioPlayer noteOff:noteID];
    }
    if ([self.musicalDelegate respondsToSelector:@selector(keyboardDidSendNoteOn:noteOff:)]) {
        [self.musicalDelegate keyboardDidSendNoteOn:nil noteOff:@(noteID)];
    }
}


#pragma mark - Configuration -

- (void)enablePitchControl:(BOOL)pitchControlEnabled
{
    _pitchControlEnabled = pitchControlEnabled;
    if (pitchControlEnabled) {
        [self focusKeyboardAnimated:NO];
    } else {
        [self defocusKeyboardAnimated:NO light:NO];
    }
}

- (void)enableSpelling:(BOOL)setting { [self.controlRibbon enableSpelling:setting]; }
- (void)enableDurationControls:(BOOL)setting { [self.controlRibbon enableDurationControls:setting]; }
- (void)durationControlsActive:(BOOL)setting { [self.controlRibbon setDurationControlsActive:setting]; }
- (void)enableManualDismiss:(BOOL)setting { [self.controlRibbon enableDismiss:setting]; }
- (void)enableBackspaceControl:(BOOL)setting { [self.controlRibbon enableBackspace:setting]; }
- (void)enableChordDetection:(BOOL)setting { [self.musicDataAggregator enableChordDetection:setting]; }
- (void)chordSensitivity:(NSUInteger)setting {
    if (setting != 0) {
        [self.musicDataAggregator setChordSensitivity:setting];
        [self.controlRibbon resetChordSensitivitySlider];
        self.chordSensitivityWasSetProgrammatically = YES;
    } else {
        self.chordSensitivityWasSetProgrammatically = NO;
    }
}

@end
