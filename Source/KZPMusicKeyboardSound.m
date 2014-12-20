//
//  KZPMusicKeyboardSound.m
//  KZPMusicKeyboard
//
//  Created by Matt Rankin on 4/07/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import "KZPMusicKeyboardSound.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface KZPMusicKeyboardSound ()

@property (strong, nonatomic) NSArray *tones;

@end

@implementation KZPMusicKeyboardSound

- (id)init
{
    self = [super init];
    if (self) {
        NSMutableArray *tones = [NSMutableArray array];
        for (int i = 0; i < TOTAL_KEYS; i++) {
            int noteID = LOWEST_KEY+i;
            NSURL *url = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%d", noteID] withExtension:@"aif"];
            [tones addObject:[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil]];
        }
        _tones = (NSArray *)tones;
    }
    return self;
}

- (BOOL)playNoteWithID:(NSUInteger)noteID
{
    if (noteID < LOWEST_KEY) return NO;
    [(AVAudioPlayer *)_tones[noteID] play];
    return YES;
}

@end
