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
@property (nonatomic) unsigned int selectedDuration;
@property (strong, nonatomic) NSTimer *chordTimer;

@end

@implementation KZPMusicKeyboardDataAggregator

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

- (void)reset
{
    self.noteIDs = nil;
    self.inputTypes = nil;
    self.spellings = nil;
    self.selectedDuration = 0;
}

- (void)receiveDuration:(unsigned int)duration
{
    self.selectedDuration = duration;
}

- (void)receiveSpelling:(MusicSpelling)spelling
{
    if (spelling) [self.spellings addObject:@(spelling)];
}

- (void)receivePitch:(NSUInteger)pitch
{
    [self.noteIDs addObject:@(pitch)];
    [self.inputTypes addObject:@(KBD__NOTE_ON)];
    
    [self.chordTimer invalidate];
    
    if (self.chordDetectionEnabled) {
//        NSUInteger sliderSetting = (NSUInteger)round([self.aggregatorThresholdSlider value]);
//        self.chordTimer = [NSTimer scheduledTimerWithTimeInterval:(double)sliderSetting / 1000
//                                                           target:self
//                                                         selector:@selector(flushAggregatedNoteInformation)
//                                                         userInfo:nil
//                                                          repeats:NO];
    } else {
        [self flush];
    }
}

- (void)flush
{
    KZPMusicDurationData *durationData = [[KZPMusicDurationData alloc] init]; //initWithDuration:self.selectedDuration isTied:];
    KZPMusicPitchData *pitchData = [[KZPMusicPitchData alloc] initWithNoteData:self.noteIDs spellingData:self.spellings];
    
    [self.delegate keyboardDidSendPitchData:pitchData withDurationData:durationData];
    [self reset];
}

- (void)chordDetected
{
//    if (self.manualSpellButton.selected) {
//        self.spellingChoices = [NSMutableDictionary dictionary];
//        for (NSNumber *noteID in self.noteIDs) {
//            [self displayAccidentalOptionsForNoteID:[noteID intValue]];
//            [self.spellingChoices setObject:[NSNull null] forKey:noteID];
//        }
//        return;
//    }
}


- (void)flushAggregatedNoteInformation
{

    
//    if (![self.spellings count]) [self.spellings addObject:@(SP__NATURAL)];
//    if ([self.delegate respondsToSelector:@selector(keyboardDidSendSignal:inputType:spelling:duration:dotted:tied:midiPacket:oscPacket:)]) {
//        [self.delegate keyboardDidSendSignal:self.noteIDs
//                                   inputType:self.inputTypes
//                                    spelling:self.spellings
//                                    duration:self.rhythmControlsEnabled ? self.selectedDuration : nil
//                                      dotted:self.dotButton.selected
//                                        tied:self.tieButton.selected
//                                  midiPacket:self.MIDIPackets
//                                   oscPacket:self.OSCPackets];
//    }
//    [self resetAggregation];
}

@end
