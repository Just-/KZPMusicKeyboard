//
//  KZPMusicPitchData.m
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import "KZPMusicPitchData.h"
#import "KZPMusicSciNotation.h"

@implementation KZPMusicPitchData

- (NSArray *)noteValues
{
    if (!_noteValues) _noteValues = [NSArray array];
    return _noteValues;
}

- (NSArray *)spellings
{
    if (!_spellings) _spellings = [NSArray array];
    return _spellings;
}

- (NSArray *)sciNotations
{
    if (!_sciNotations) _sciNotations = [NSArray array];
    return _sciNotations;
}

- (instancetype)initWithNoteData:(NSArray *)noteData spellingData:(NSArray *)spellingData
{
    self = [super init];
    if (self) {
        _noteValues = noteData;
        _spellings = spellingData;
    }
    return self;
}

- (void)addPitch:(NSUInteger)pitch withSpelling:(MusicSpelling)spelling
{
    NSString *sciNotation = [KZPMusicSciNotation sciNotationForPitch:(int)pitch modifier:(int)spelling resolve:YES];
    int resolvedSpelling;
    [KZPMusicSciNotation pitchValueForSciNotation:sciNotation modifier:&resolvedSpelling];
    self.spellings = [self.spellings arrayByAddingObject:@(resolvedSpelling)];
    self.noteValues = [self.noteValues arrayByAddingObject:@(pitch)];
    self.sciNotations = [self.sciNotations arrayByAddingObject:sciNotation];
}

- (void)addPitch:(NSUInteger)pitch
{
    self.noteValues = [self.noteValues arrayByAddingObject:@(pitch)];
}

- (void)addSpelling:(MusicSpelling)spelling
{
    self.spellings = [self.spellings arrayByAddingObject:@(spelling)];
}

@end
