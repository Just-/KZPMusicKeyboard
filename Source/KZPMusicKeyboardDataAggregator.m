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
@property (strong, nonatomic) NSTimer *chordTimer;
@property (strong, nonatomic) KZPMusicDurationData *durationData;
@property (strong, nonatomic) KZPMusicPitchData *pitchData;

@end

@implementation KZPMusicKeyboardDataAggregator

- (KZPMusicPitchData *)pitchData
{
    if (!_pitchData) _pitchData = [[KZPMusicPitchData alloc] init];
    return _pitchData;
}

- (void)reset
{
    self.durationData = nil;
    self.pitchData = nil;
}

- (void)receiveDuration:(unsigned int)duration rest:(BOOL)rest dotted:(BOOL)dotted tied:(BOOL)tied
{
    self.durationData = [[KZPMusicDurationData alloc] initWithDuration:duration rest:rest tied:dotted dotted:tied];
}

- (void)receiveSpelling:(MusicSpelling)spelling
{
    [self.pitchData addSpelling:spelling];
}

- (void)receivePitch:(NSUInteger)pitch
{
    [self.pitchData addPitch:pitch];
    
//    [self.noteIDs addObject:@(pitch)];
//    [self.inputTypes addObject:@(KBD__NOTE_ON)];
    
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

    [self.delegate keyboardDidSendPitchData:self.pitchData withDurationData:self.durationData];
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
