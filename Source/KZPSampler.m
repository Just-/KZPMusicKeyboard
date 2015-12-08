//
//  KZPSampler.m
//  KZPNameTone
//
//  Created by Matt Rankin on 13/10/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import "KZPSampler.h"
#import "TheAmazingAudioEngine.h"


@interface KZPSampler ()

@property (nonatomic) AudioUnit samplerUnit;
@property (nonatomic, strong) AEAudioUnitChannel *AESampler;

@end


@implementation KZPSampler

- (AEAudioUnitChannel *)channel
{
    return self.AESampler;
}

- (instancetype)initWithAudioController:(AEAudioController *)audioController
{
    self = [super init];
    if (self) {
        [self setupSamplerWithAudioController:audioController];
    }
    return self;
}

- (void)setupSamplerWithAudioController:(AEAudioController *)audioController
{
    AudioComponentDescription audioComponent = AEAudioComponentDescriptionMake(kAudioUnitManufacturer_Apple,
                                                                               kAudioUnitType_MusicDevice,
                                                                               kAudioUnitSubType_Sampler);
    
    self.AESampler = [[AEAudioUnitChannel alloc] initWithComponentDescription:audioComponent];
    NSArray *audioControllerChannels = @[self.AESampler];
    [audioController addChannels:audioControllerChannels];
    
    self.samplerUnit = [self.AESampler audioUnit];
}

- (BOOL)loadSoundfontWithName:(NSString *)soundfontName
{
    NSURL *soundfontURL = [[NSBundle mainBundle] URLForResource:soundfontName withExtension:@"sf2"];
    OSStatus result = [self loadFromDLSOrSoundFont:soundfontURL withPatch:(int)self.presetNumber];
    if (result != noErr) {
        NSLog(@"Failed to load audio sampler unit's soundfont");
        return NO;
    }
    return YES;
}

- (OSStatus)loadFromDLSOrSoundFont:(NSURL *)bankURL withPatch:(int)presetNumber
{
    AUSamplerInstrumentData instrumentData;
    instrumentData.fileURL = (__bridge CFURLRef)bankURL;
    instrumentData.instrumentType = kInstrumentType_DLSPreset;
    instrumentData.bankMSB = kAUSampler_DefaultMelodicBankMSB;
    instrumentData.bankLSB = kAUSampler_DefaultBankLSB;
    instrumentData.presetID = (UInt8)presetNumber;
    
    OSStatus result = AudioUnitSetProperty(self.samplerUnit,
                                           kAUSamplerProperty_LoadInstrument,
                                           kAudioUnitScope_Global,
                                           0, // The element of the scope
                                           &instrumentData,
                                           sizeof(instrumentData));
    
    if (result != noErr) {
        NSLog(@"Unable to set the preset property on the Sampler. Error code: %d '%.4s'", (int)result, (const char *)&result);
    }
    
    return result;
}

- (void)issueMIDIEventWithStatus:(UInt32)status byte1:(UInt32)byte1 byte2:(UInt32)byte2
{
    OSStatus result = MusicDeviceMIDIEvent(self.samplerUnit, status, byte1, byte2, 0);
    if (result != noErr) {
        NSLog(@"Unable to start MIDI event: Error code %d '%.4s'\n", (int)result, (const char *)&result);
    }
}


@end
