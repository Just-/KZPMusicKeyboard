//
//  KZPMusicKeyboardManager.h
//  KZPMusicKeyboard
//
//  Created by Matt Rankin on 1/07/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPMusicKeyboardViewController.h"

//
// There are three ways to invoke KZPKeyboard
//
// 1. - Include KZPKeyboardManager, set responder to self, call 'showController';
//
// 2. - Subclass UITextFieldMusic (XYZ), then treat XYZ as a normal UITextField. In IB, don't forget to set the
//      custom class to XYZ;
//
// In both cases, the protocol is technically optional. In (1), whichever class has set itself as delegate must
// implement the protocol methods in order to do anything useful other than being able to play bad piano.
// In (2), the default behaviour of UIMusicTextField will occur (just appending MIDI note IDs) unless the protocol
// methods are overridden in XYZ.
//
// 3. - Use a project which is designed to work with KZPKeyboard automatically, such as KZPNotationEditor.
//

// Modes of Operation for Rhythm Buttons
// 1. No Rhythm (tapping disabled)
// 2. Active rhythm switches (tapping sends signal)
// 3. Passive rhythm switches (tapping toggles the mutex)

// NOTE: KZPKeyboardManager owns the controller, but is not its delegate.

@interface KZPMusicKeyboardManager : NSObject

+ (KZPMusicKeyboardManager *)defaultManager;

- (void)setResponder:(id<KZPMusicKeyboardDelegate>)responder;

- (UIView *)showControllerWithRhythmControls:(BOOL)needsRhythmControls;
- (void)hideControllerWithCompletionBlock:(void(^)())completionBlock;
- (void)removeImmediately;

//- (void)qwertyKeyboardDidHide:(id)receiver;

@end
