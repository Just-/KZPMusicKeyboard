//
//  KZPMusicKeyboardDelegate.h
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPMusicPitchData.h"
#import "KZPMusicDurationData.h"

@protocol KZPMusicKeyboardDelegate <NSObject>

@optional
- (void)keyboardDidSendPitchData:(KZPMusicPitchData *)pitchData
                withDurationData:(KZPMusicDurationData *)durationData;

- (void)keyboardDidSendNoteOn:(NSNumber *)noteOnPitch noteOff:(NSNumber *)noteOffPitch;

@end

@protocol KZPMusicKeyboardControlDelegate <NSObject>

@optional
- (void)keyboardWasDismissed;
- (void)keyboardDidSendBackspace;

@end
