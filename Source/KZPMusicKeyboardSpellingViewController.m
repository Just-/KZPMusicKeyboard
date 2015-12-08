//
//  KZPMusicKeyboardSpellingViewController.m
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import "KZPMusicKeyboardSpellingViewController.h"
#import "KZPMusicSciNotation.h"
#import "KZPMusicKeyboardSpellingButton.h"

#define N_MODIFIERS 5
static int _modifierOrder[N_MODIFIERS] = {-2, 2, -1, 1, 0};

@interface KZPMusicKeyboardSpellingViewController () <KZPMusicDataAggregatorDelegate, KZPMusicKeyboardSpellingButtonDelegate>

@property (strong, nonatomic) NSDictionary *imageNameMap;
@property (strong, nonatomic) NSMutableDictionary *spellingButtons;
@property (strong, nonatomic) NSMutableDictionary *selectedSpellingChoices;

@end

@implementation KZPMusicKeyboardSpellingViewController

- (NSMutableDictionary *)spellingButtons
{
    if (!_spellingButtons) _spellingButtons = [NSMutableDictionary dictionary];
    return _spellingButtons;
}



//- (NSMutableArray *)spellings
//{
//    if (!_spellings) _spellings = [NSMutableArray array];
//    return _spellings;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageNameMap = @{@"double-flat": @(-2),
                          @"flat": @(-1),
                          @"natural": @(0),
                          @"sharp": @(1),
                          @"double-sharp": @(2)};
}

- (void)setSpellingSurface:(UIView *)spellingSurface
{
    _spellingSurface = spellingSurface;
    UITapGestureRecognizer *refocusGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelManualSpelling)];
    [_spellingSurface addGestureRecognizer:refocusGesture];
}

- (void)cancelManualSpelling
{
    [self.delegate hideSpellingSurface];
}

- (void)setMusicDataAggregator:(id<KZPMusicKeyboardDelegate>)musicDataAggregator
{
    _musicDataAggregator = musicDataAggregator;
    _musicDataAggregator.delegate = self;
}


#pragma mark - KZPMusicDataAggregatorDelegate -


- (void)provideManualSpellingForNoteValues:(NSArray *)noteValues
{
    [self.delegate showSpellingSurface];
    self.selectedSpellingChoices = [NSMutableDictionary dictionary];
    for (NSNumber *noteID in noteValues) {
        [self displaySpellingOptionsForNoteID:[noteID intValue]];
        [self.selectedSpellingChoices setObject:[NSNull null] forKey:noteID];
    }
}

- (void)displaySpellingOptionsForNoteID:(int)noteID
{
    UIButton *pianoKeyButton = [self.keyButtonsByNoteID objectForKey:[NSString stringWithFormat:@"%d", noteID]];
    [self generateSpellingButtonsForPianoKey:pianoKeyButton];
}

- (void)generateSpellingButtonsForPianoKey:(UIButton *)pianoKeyButton
{
    NSUInteger noteID = pianoKeyButton.tag;
    NSMutableArray *spellingButtonsForKey = [NSMutableArray array];
    
    for (int i = 0; i < N_MODIFIERS; i++) {
        int modifier = _modifierOrder[i];
        
        if ([KZPMusicSciNotation modifier:modifier isLegalForPitch:(int)noteID]) {
            KZPMusicKeyboardSpellingButton *spellingButton = [[KZPMusicKeyboardSpellingButton alloc] initWithPianoKey:pianoKeyButton
                                                                                                  existingButtonCount:[spellingButtonsForKey count]
                                                                                                             modifier:modifier];
            [spellingButtonsForKey addObject:spellingButton];
            [self displaySpellingButton:spellingButton];
        }
    }
    
    [self.spellingButtons setObject:spellingButtonsForKey forKey:@(noteID)];
}

- (void)displaySpellingButton:(KZPMusicKeyboardSpellingButton *)spellingButton
{
    spellingButton.delegate = self;
    [self.spellingSurface addSubview:spellingButton];
    [self.spellingSurface bringSubviewToFront:spellingButton];
    [spellingButton show];
}


#pragma mark - KZPMusicKeyboardSpellingButtonDelegate -


- (void)spellingButtonPressed:(KZPMusicKeyboardSpellingButton *)sender
{
    NSNumber *key = [NSNumber numberWithLong:[sender tag]];
    NSArray *buttonSet = [self.spellingButtons objectForKey:key];
    [self.spellingButtons removeObjectForKey:key];
    
    for (KZPMusicKeyboardSpellingButton *spellingButton in [self.spellingButtons objectForKey:key]) {
        [spellingButton hide];
    }
    
    [self.spellingChoices setObject:[self.imageNameMap valueForKey:sender.titleLabel.text] forKey:key];
    
    if ([self spellingSelectionsComplete]) {
        [self sendPitchAndSpellingData];
        self.spellingButtons = nil;
//        [self.delegate manualSpellingComplete];
        [UIView animateWithDuration:0.2 animations:^{
            self.spellingSurface.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.spellingSurface.hidden = YES;
        }];
    }
}

- (void)dismissWithCompletion:(void (^)())completionBlock
{
    [UIView animateWithDuration:0.2 animations:^{
        self.spellingSurface.alpha = 0.0;
        for (NSArray *buttonSet in [self.spellingButtons allValues]) {
            for (UIButton *button in buttonSet) {
                button.alpha = 0.0;
            }
        }
        
    } completion:^(BOOL finished) {
        for (NSArray *buttonSet in [self.spellingButtons allValues]) {
            for (UIButton *button in buttonSet) {
                [button removeFromSuperview];
            }
        }
        self.spellingButtons = nil;
        completionBlock();
    }];
}

- (BOOL)spellingSelectionsComplete
{
    for (NSNumber *k in [self.selectedSpellingChoices allKeys]) {
        if ([[self.selectedSpellingChoices objectForKey:k] isEqual:[NSNull null]]) {
            return NO;
        }
    }
    return YES;
}

- (void)sendPitchAndSpellingData
{
    [self.musicDataAggregator resetPitchData];
    [self.musicDataAggregator receivePitchArray:[self.selectedSpellingChoices allKeys]];
    [self.musicDataAggregator receiveSpellingArray:[self.selectedSpellingChoices allValues]];
    [self.musicDataAggregator flush];
}

@end
