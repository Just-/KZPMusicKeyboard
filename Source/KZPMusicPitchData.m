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

- (instancetype)initWithNoteData:(NSArray *)noteData spellingData:(NSArray *)spellingData
{
    self = [super init];
    if (self) {
        if ([noteData count] != [spellingData count]) {
            NSLog(@"Error: note and spelling data don't match");
            return nil;
        }
        [self addNoteData:noteData withSpellingData:spellingData];
    }
    return self;
}

- (void)addNoteData:(NSArray *)noteData withSpellingData:(NSArray *)spellingData
{
    for (int i = 0; i < [noteData count]; i++) {
        NSUInteger pitch = [noteData[i] integerValue];
        [self addPitch:pitch withSpelling:spellingData[i]];
    }
}

- (void)addPitch:(NSUInteger)pitch withSpelling:(NSNumber *)spelling
{
    [self addPitch:pitch];
    
    if (spelling) {
        NSString *sciNotation = [KZPMusicSciNotation sciNotationForPitch:(int)pitch modifier:[spelling intValue] resolve:YES];
        int resolvedSpelling;
        [KZPMusicSciNotation pitchValueForSciNotation:sciNotation modifier:&resolvedSpelling];
        
        [self addSpelling:resolvedSpelling];
        
        if (!_sciNotations) _sciNotations = [NSArray array];
        self.sciNotations = [self.sciNotations arrayByAddingObject:sciNotation];
    }
}

- (void)addPitch:(NSUInteger)pitch
{
    if (!_noteValues) _noteValues = [NSArray array];
    self.noteValues = [self.noteValues arrayByAddingObject:@(pitch)];
}

- (void)addSpelling:(MusicSpelling)spelling
{
    if (!_spellings) _spellings = [NSArray array];
    self.spellings = [self.spellings arrayByAddingObject:@(spelling)];
}

@end
