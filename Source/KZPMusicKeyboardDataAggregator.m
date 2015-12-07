//
//  KZPMusicKeyboardDataAggregator.m
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import "KZPMusicKeyboardDataAggregator.h"

@interface KZPMusicKeyboardDataAggregator ()

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

- (void)resetPitchData
{
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
    [self.chordTimer invalidate];
    
    NSLog(@"chord sensitivity: %lu", (unsigned long)self.chordSensitivity);
    
    if (self.chordDetectionEnabled) {
        NSLog(@"start timer");
        self.chordTimer = [NSTimer scheduledTimerWithTimeInterval:(double)self.chordSensitivity / 1000
                                                           target:self
                                                         selector:@selector(chordDetected)
                                                         userInfo:nil
                                                          repeats:NO];
    } else {
        [self flush];
    }
}

- (void)receiveSpellingArray:(NSArray *)spellings
{
    self.pitchData.spellings = spellings;
}

- (void)receivePitchArray:(NSArray *)pitches
{
    self.pitchData.noteValues = pitches;
}

- (void)flush
{
    if ([[self.pitchData spellings] count] == 0) {
        [self.pitchData addSpelling:MusicSpelling_Natural];
    }
    if ([self.musicalDelegate respondsToSelector:@selector(keyboardDidSendPitchData:withDurationData:)]) {
        [self.musicalDelegate keyboardDidSendPitchData:self.pitchData withDurationData:self.durationData];
    }
    [self reset];
}

- (void)chordDetected
{
    if ([self manualSpellingEnabled]) {
        [self.delegate provideManualSpellingForNoteValues:[self.pitchData noteValues]];
    } else {
        [self flush];
    }
}


@end
