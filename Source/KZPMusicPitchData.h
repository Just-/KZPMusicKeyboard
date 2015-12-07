//
//  KZPMusicPitchData.h
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPMusicSciNotation.h"

@interface KZPMusicPitchData : NSObject

- (instancetype)initWithNoteData:(NSArray *)noteData spellingData:(NSArray *)spellingData;

@property (strong, nonatomic) NSArray *spellings;
@property (strong, nonatomic) NSArray *noteValues;
@property (strong, nonatomic) NSArray *sciNotations;

- (void)addPitch:(NSUInteger)pitch withSpelling:(MusicSpelling)spelling;

@end
