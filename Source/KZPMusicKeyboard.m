//
//  KZPMusicKeyboard.m
//  KZPMusicKeyboard
//
//  Created by Matt Rankin on 1/07/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import "KZPMusicKeyboard.h"
#import "UIView+frameOperations.h"
#import "AGWindowView.h"
#import "KZPMusicTextField.h"

@interface KZPMusicKeyboard ()

@property (strong, nonatomic) KZPMusicKeyboardViewController *pianoKeyboard;
@property (strong, nonatomic) AGWindowView *windowView;

@end

@implementation KZPMusicKeyboard

static KZPMusicKeyboard *default;

+ (KZPMusicKeyboard *)default
{
    if (!default) default = [[KZPMusicKeyboard alloc] init];
    return default;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.pianoKeyboard = [[KZPMusicKeyboardViewController alloc] initWithNibName:@"KZPMusicKeyboardView" bundle:nil];
        [self.pianoKeyboard.view setFrameY:[[UIScreen mainScreen] bounds].size.width - self.pianoKeyboard.view.frame.size.height];

    }
    return self;
}

- (void)setResponder:(id<KZPMusicKeyboardDelegate>)responder
{
    self.pianoKeyboard.delegate = responder;
}


#pragma mark - Show / Hide -

- (UIView *)showControllerWithOptions:(NSDictionary *)keyboardOptions
{
    if (self.windowView == nil) {
        self.windowView = [[AGWindowView alloc] initAndAddToKeyWindow];
        self.windowView.supportedInterfaceOrientations = AGInterfaceOrientationMaskLandscape;
    }
    self.pianoKeyboard.rhythmControlsEnabled = [[keyboardOptions valueForKey:kENABLE_RHYTHM] boolValue];
    self.pianoKeyboard.keyboardEnabled = [[keyboardOptions valueForKey:kENABLE_KEYBOARD] boolValue];
    self.pianoKeyboard.chordsEnabled = [[keyboardOptions valueForKey:kENABLE_CHORDS] boolValue];
    self.pianoKeyboard.rhythmMode = self.pianoKeyboard.rhythmControlsEnabled && !self.pianoKeyboard.keyboardEnabled ?KZPMusicKeyboardRhythmMode_Active : KZPMusicKeyboardRhythmMode_Passive;
    
    // iOS7 and iOS8 have different notions of screen height
    CGFloat landscapeScreenHeight = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat landscapeScreenWidth = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [self.pianoKeyboard.view setFrameY:landscapeScreenHeight];
    [self.windowView addSubview:self.pianoKeyboard.view];
    [UIView animateWithDuration:0.3 animations:^{
        [self.pianoKeyboard.view setFrameY:landscapeScreenHeight - self.pianoKeyboard.view.frame.size.height];
    }];
//    self.windowView.passThroughFrame = CGRectMake(0, 0, landscapeScreenWidth, self.pianoKeyboard.view.frame.origin.y);
    return self.windowView;
}

- (void)hideControllerWithCompletionBlock:(void (^)())completionBlock deactivate:(BOOL)deactivate
{
    // iOS7 and iOS8 have different notions of screen height
    CGFloat landscapeScreenHeight = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.pianoKeyboard.view setFrameY:landscapeScreenHeight]; // landscape
    } completion:^(BOOL finished) {
        UIView *windowView = [self.pianoKeyboard.view superview];
        [self.pianoKeyboard.view removeFromSuperview];
        if (deactivate) {
            [windowView removeFromSuperview];
            self.windowView = nil;
        }
        if (completionBlock) completionBlock();
    }];
}

// What is the purpose of this?
- (void)removeImmediately
{
    [self.windowView removeFromSuperview];
    self.windowView = nil;
}

@end
