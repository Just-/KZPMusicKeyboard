//
//  KZPMusicKeyboardAudio.h
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KZPMusicKeyboardAudio : NSObject

@property (strong, nonatomic) NSString *patch;

- (void)noteOn:(NSUInteger)noteID;
- (void)noteOff:(NSUInteger)noteID;

@end
