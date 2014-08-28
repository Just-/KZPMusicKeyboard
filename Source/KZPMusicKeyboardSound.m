//
//  KZPMusicKeyboardSound.m
//  KZPMusicKeyboard
//
//  Created by Matt Rankin on 4/07/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import "KZPMusicKeyboardSound.h"
#import <AudioToolbox/AudioToolbox.h>

@interface KZPMusicKeyboardSound ()
{
    SystemSoundID tones[88];
}

@end

@implementation KZPMusicKeyboardSound

- (id)init
{
    self = [super init];
    if (self) {
        for (int i = 0; i < TOTAL_KEYS; i++) {
            int noteID = LOWEST_KEY+i;
            NSURL *url = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%d", noteID] withExtension:@"aif"];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, tones+i);
        }
    }
    return self;
}

- (BOOL)playNoteWithID:(NSUInteger)noteID
{
    if (noteID < LOWEST_KEY) return NO;
    AudioServicesPlaySystemSound(tones[noteID - LOWEST_KEY]);
    return YES;
}

- (void)dealloc
{
    for (int i = 0; i < TOTAL_KEYS; i++) {
        AudioServicesDisposeSystemSoundID(tones[i]);
    }
}

@end
