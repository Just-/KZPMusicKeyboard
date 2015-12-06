//
//  KZPMusicPitchData.h
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KZPMusicPitchData : NSObject

- (instancetype)initWithNoteData:(NSArray *)noteData spellingData:(NSArray *)spellingData;

@property (strong, readonly) NSArray *spellings;
@property (strong, readonly) NSArray *noteValues;

@end
