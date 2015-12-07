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

@property (nonatomic) NSNumber *currentSpelling;

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
    self.currentSpelling = nil;
}

- (void)resetPitchData
{
    self.pitchData = nil;
}

- (void)receiveDuration:(unsigned int)duration rest:(BOOL)rest dotted:(BOOL)dotted tied:(BOOL)tied
{
    self.durationData = [[KZPMusicDurationData alloc] initWithDuration:duration rest:rest tied:tied dotted:dotted];
}

- (void)receiveSpelling:(MusicSpelling)spelling
{
    self.currentSpelling = @(spelling);
}

- (void)receivePitch:(NSUInteger)pitch
{
    [self.pitchData addPitch:pitch withSpelling:self.currentSpelling];
    [self.chordTimer invalidate];
    
    if (self.chordDetectionEnabled) {
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
