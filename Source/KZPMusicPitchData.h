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

@property (strong, nonatomic) NSArray *spellings;
@property (strong, nonatomic) NSArray *noteValues;

- (void)addPitch:(NSUInteger)pitch;
- (void)addSpelling:(MusicSpelling)spelling;

@end
