//
//  KZPMusicKeyboardSound.h
//  KZPMusicKeyboard
//
//  Created by Matt Rankin on 4/07/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TOTAL_KEYS      88
#define LOWEST_KEY      21

@interface KZPMusicKeyboardSound : NSObject

- (BOOL)playNoteWithID:(NSUInteger)noteID;

@end
