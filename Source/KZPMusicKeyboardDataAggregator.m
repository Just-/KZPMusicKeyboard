//
//  KZPMusicKeyboardDataAggregator.m
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import "KZPMusicKeyboardDataAggregator.h"

@interface KZPMusicKeyboardDataAggregator ()

// Aggregation of note information for the purpose of detecting chords
@property (strong, nonatomic) NSMutableArray *noteIDs;
@property (strong, nonatomic) NSMutableArray *inputTypes;
@property (strong, nonatomic) NSMutableArray *spellings;
@property (strong, nonatomic) NSNumber *selectedDuration;
@property (strong, nonatomic) NSTimer *chordTimer;

@end

@implementation KZPMusicKeyboardDataAggregator

- (void)resetAggregation
{
    self.noteIDs = nil;
    self.inputTypes = nil;
    self.spellings = nil;
    self.selectedDuration = nil;
    self.MIDIPackets = nil;
    self.OSCPackets = nil;
    self.tieButton.selected = NO;
    self.tieButton.layer.opacity = 0.5;
    self.manualSpellButton.selected = NO;
    self.manualSpellButton.layer.opacity = 0.5;
}

- (void)flushAggregatedNoteInformation
{
    if (self.manualSpellButton.selected) {
        self.spellingChoices = [NSMutableDictionary dictionary];
        for (NSNumber *noteID in self.noteIDs) {
            [self displayAccidentalOptionsForNoteID:[noteID intValue]];
            [self.spellingChoices setObject:[NSNull null] forKey:noteID];
        }
        return;
    }
    
    if (![self.spellings count]) [self.spellings addObject:@(SP__NATURAL)];
    if ([self.delegate respondsToSelector:@selector(keyboardDidSendSignal:inputType:spelling:duration:dotted:tied:midiPacket:oscPacket:)]) {
        [self.delegate keyboardDidSendSignal:self.noteIDs
                                   inputType:self.inputTypes
                                    spelling:self.spellings
                                    duration:self.rhythmControlsEnabled ? self.selectedDuration : nil
                                      dotted:self.dotButton.selected
                                        tied:self.tieButton.selected
                                  midiPacket:self.MIDIPackets
                                   oscPacket:self.OSCPackets];
    }
    [self resetAggregation];
}

@end
