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


@interface KZPMusicKeyboardViewController () <KZPMusicKeyboardMapDelegate>

@property (weak, nonatomic) IBOutlet UIView *keyboardMainView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *keyButtons;

@property (weak, nonatomic) IBOutlet UIView *keyboardDefocusView;

@property (strong, nonatomic) KZPMusicKeyboardAudio *localAudio;
@property (strong, nonatomic) KZPMusicKeyboardRibbonViewController *controlRibbon;

@property (strong, nonatomic) KZPMusicKeyboardDataAggregator *musicDataAggregator;
@property (strong, nonatomic) KZPMusicKeyboardSpellingViewController *spellingSurface;

@property (strong, nonatomic) KZPMusicKeyboardMapViewController *keyboardMapViewController;

@end


@implementation KZPMusicKeyboardViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.localAudio = [[KZPMusicKeyboardAudio alloc] init];
    self.localAudio.patch = [self.controlRibbon selectedPatch];

    [self loadKeyboardMap];
    [self loadControlRibbon];
    [self setupKeyReleaseAction];
    [self setupDefocusView];
}

- (void)loadKeyboardMap
{
    self.keyboardMapViewController = [[KZPMusicKeyboardMapViewController alloc] initWithNibName:@"KZPMusicKeyboardMapView" bundle:nil];
    self.keyboardMapViewController.delegate = self;
    [self.keyboardMapViewController.view setFrameY:42];
    [self.view addSubview:self.keyboardMapViewController.view];
}

- (void)loadControlRibbon
{
    self.controlRibbon = [[KZPMusicKeyboardRibbonViewController alloc] initWithNibName:@"KZPMusicKeyboardRibbonView" bundle:nil];
    [self.view addSubview:self.controlRibbon.view];
}

#pragma mark - KZPMusicKeyboardMapDelegate -


- (void)updateKeyboardPosition:(float)relativePosition
{
    [self.keyboardMainView setFrameX:-( (self.keyboardMainView.frame.size.width - self.view.frame.size.width) * relativePosition )];
}


#pragma mark -


- (void)setKeyboardEnabled:(BOOL)keyboardEnabled
{
    if (keyboardEnabled) {
        self.keyboardDefocusView.hidden = YES;
        self.keyboardDefocusView.alpha = 0.0;
    } else {
        self.keyboardDefocusView.hidden = NO;
        self.keyboardDefocusView.alpha = 0.5;
        [self.controlRibbon resetSpelling];
    }
    _keyboardEnabled = keyboardEnabled;
}

- (void)setupDefocusView
{
    self.keyboardDefocusView.hidden = YES;
    self.keyboardDefocusView.alpha = 0.0;
    UITapGestureRecognizer *refocusGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refocusKeyboard)];
    [self.keyboardDefocusView addGestureRecognizer:refocusGesture];
}

- (void)recenter
{
    [self.keyboardMapViewController panToRangeWithCenterNote:60 animated:NO];
}

- (void)setupKeyReleaseAction
{
    for (UIButton *keyButton in self.keyButtons) {
        [keyButton addTarget:self action:@selector(keyButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
        [keyButton addTarget:self action:@selector(keyButtonReleased:) forControlEvents:UIControlEventTouchUpOutside];
        
        // TODO: What about drag events?
    }
}


- (void)refocusKeyboard
{
    if (!self.keyboardEnabled) return;
    
    [self.musicDataAggregator reset];
    [self.controlRibbon resetDuration];
    [self.spellingSurface dismissWithCompletion:^{
        self.keyboardDefocusView.hidden = YES;
    }];
}


// TODO: separate note on/off eventually
- (IBAction)keyButtonPressed:(id)sender
{
    NSUInteger noteID = [sender tag];
    [self.localAudio noteOn:noteID];
    [self.musicDataAggregator receiveDuration:[self.controlRibbon selectedDuration]];
    [self.musicDataAggregator receiveSpelling:[self.controlRibbon selectedAccidental]];
    [self.controlRibbon resetSpelling];
}

- (IBAction)keyButtonReleased:(id)sender
{
    NSUInteger noteID = [sender tag];
    [self.localAudio noteOff:noteID];
}

@end
