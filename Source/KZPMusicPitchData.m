//
//  KZPMusicPitchData.m
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import "KZPMusicPitchData.h"

@implementation KZPMusicPitchData

- (instancetype)initWithNoteData:(NSArray *)noteData spellingData:(NSArray *)spellingData
{
    self = [super init];
    if (self) {
        _noteValues = noteData;
        _spellings = spellingData;
    }
    return self;
}

- (void)addPitch:(NSUInteger)pitch
{
    if (!_noteValues) _noteValues = [NSArray array];
    _noteValues = [_noteValues arrayByAddingObject:@(pitch)];
}

- (void)addSpelling:(MusicSpelling)spelling
{
    if (spelling) {
        if (!_spellings) _spellings = [NSArray array];
        _spellings = [_spellings arrayByAddingObject:@(spelling)];
    }
}

@end
