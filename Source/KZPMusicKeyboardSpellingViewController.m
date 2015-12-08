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

- (void)setMusicDataAggregator:(id<KZPMusicKeyboardDataDelegate>)musicDataAggregator
{
    _musicDataAggregator = musicDataAggregator;
    _musicDataAggregator.delegate = self;
}

- (void)setSpellingSurface:(UIView *)spellingSurface
{
    _spellingSurface = spellingSurface;
    UITapGestureRecognizer *refocusGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelManualSpelling)];
    [_spellingSurface addGestureRecognizer:refocusGesture];
}

- (void)cancelManualSpelling
{
    for (NSNumber *key in [self.spellingButtons allKeys]) {
        [self hideSpellingButtonsForNoteID:key];
    }
    [self.musicDataAggregator reset];
    [self.delegate hideSpellingSurface];
}


#pragma mark - KZPMusicDataAggregatorDelegate -


- (void)provideManualSpellingForNoteValues:(NSArray *)noteValues
{
    [self.delegate showSpellingSurface];
    self.selectedSpellingChoices = [NSMutableDictionary dictionary];
    for (NSNumber *noteID in noteValues) {
        [self displaySpellingOptionsForNoteID:noteID];
        [self.selectedSpellingChoices setObject:[NSNull null] forKey:noteID];
    }
}


#pragma mark - KZPMusicKeyboardSpellingButtonDelegate -


- (void)spellingButtonPressed:(KZPMusicKeyboardSpellingButton *)sender
{
    [self.selectedSpellingChoices setObject:@([sender modifier]) forKey:[sender noteID]];
    [self hideSpellingButtonsForNoteID:[sender noteID]];
    if ([self spellingSelectionsComplete]) {
        [self finaliseSpelling];
    }
}


#pragma mark -


- (void)displaySpellingOptionsForNoteID:(NSNumber *)noteID
{
    UIButton *pianoKeyButton = [self.keyButtonsByNoteID objectForKey:noteID];
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
    [spellingButton show];    
    [self.spellingSurface addSubview:spellingButton];
    [self.spellingSurface bringSubviewToFront:spellingButton];
}

- (void)hideSpellingButtonsForNoteID:(NSNumber *)noteID
{
    NSArray *spellingButtons = [self.spellingButtons objectForKey:noteID];
    for (KZPMusicKeyboardSpellingButton *spellingButton in spellingButtons) {
        [spellingButton hide];
    }
    [self.spellingButtons removeObjectForKey:noteID];
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

- (void)finaliseSpelling
{
    [self sendPitchAndSpellingData];
    self.spellingButtons = nil;
    [self.delegate hideSpellingSurface];
}

- (void)sendPitchAndSpellingData
{
    [self.musicDataAggregator resetPitchData];
    [self.musicDataAggregator receivePitchArray:[self.selectedSpellingChoices allKeys]
                              withSpellingArray:[self.selectedSpellingChoices allValues]];
    [self.musicDataAggregator flush];
}

@end
