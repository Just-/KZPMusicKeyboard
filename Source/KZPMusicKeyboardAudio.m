//
//  KZPMusicKeyboardAudio.m
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import "KZPMusicKeyboardAudio.h"
#import "KZPSampler.h"

#define MIDI_NOTE_ON            (UInt32)0x90
#define MIDI_NOTE_OFF           (UInt32)0x80


@interface KZPMusicKeyboardAudio ()

@property (nonatomic, strong) AEAudioController *audioController;
@property (strong, nonatomic) KZPSampler *sampler;

@end


@implementation KZPMusicKeyboardAudio

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self startAudioEngine];
    }
    return self;
}

- (void)startAudioEngine
{
    if (![self setupAudioController]) {
        return;
    }
    
    NSError *error;
    
    if ([self.audioController start:&error]) {
        self.sampler = [[KZPSampler alloc] initWithAudioController:self.audioController];
    } else {
        NSLog(@"Failed to start audio engine: %@", error);
    }
}

- (BOOL)setupAudioController
{
    if (self.audioController != nil) {
        NSLog(@"ERROR: Audio engine attempted to create multiple instances of controller");
        return NO;
    }
    
    AudioStreamBasicDescription audioDescription = [AEAudioController nonInterleaved16BitStereoAudioDescription];
    self.audioController = [[AEAudioController alloc] initWithAudioDescription:audioDescription inputEnabled:NO];
    
    return YES;
}

- (void)setPatch:(NSString *)patch
{
    _patch = patch;
    NSString *soundfontDataFile = [[NSBundle bundleForClass:[self class]] pathForResource:@"Soundfonts" ofType:@"plist"];
    NSDictionary *soundfontData = [NSDictionary dictionaryWithContentsOfFile:soundfontDataFile];
    NSDictionary *patchData = [soundfontData valueForKey:patch];
    NSString *soundfont = [patchData valueForKey:@"soundfont"];
    NSNumber *preset = [patchData valueForKey:@"preset"];
    if (![self loadInstrument:soundfont withPreset:[preset intValue] gain:100]) {
        NSLog(@"Error: could not load soundfont '%@'", patch);
    }
}

- (BOOL)loadInstrument:(NSString *)instrumentName withPreset:(NSUInteger)presetNumber gain:(NSUInteger)gain
{
    [self.sampler setGain:gain];
    [self.sampler setPresetNumber:presetNumber];
    return [self.sampler loadSoundfontWithName:instrumentName];
}

- (void)noteOn:(NSUInteger)noteID
{
    UInt32 midiNoteID = (UInt32)(noteID);
    [self.sampler issueMIDIEventWithStatus:MIDI_NOTE_ON byte1:midiNoteID byte2:(UInt32)[self.sampler gain]];
}

- (void)noteOff:(NSUInteger)noteID
{
    UInt32 midiNoteID = (UInt32)(noteID);
    [self.sampler issueMIDIEventWithStatus:MIDI_NOTE_OFF byte1:midiNoteID byte2:(UInt32)0];
}

@end
