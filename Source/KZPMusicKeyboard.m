//
//  KZPMusicKeyboard.m
//  KZPMusicKeyboard
//
//  Created by Matt Rankin on 1/07/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import "KZPMusicKeyboard.h"
#import "UIView+frameOperations.h"
#import "KZPKeyboardSuperview.h"
#import "KZPMusicKeyboardMapViewController.h"

static KZPMusicKeyboard *keyboardInstance;


@interface KZPMusicKeyboard () <KZPMusicKeyboardControlDelegate>

@property (strong, nonatomic) KZPMusicKeyboardViewController *keyboardViewController;
@property (strong, nonatomic) KZPKeyboardSuperview *windowView;

@end


@implementation KZPMusicKeyboard


+ (KZPMusicKeyboard *)keyboard
{
    if (!keyboardInstance) keyboardInstance = [[KZPMusicKeyboard alloc] init];
    return keyboardInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.keyboardViewController = [[KZPMusicKeyboardViewController alloc] initWithNibName:@"KZPMusicKeyboardView" bundle:nil];
        [self.keyboardViewController.view setFrameY:[[UIScreen mainScreen] bounds].size.width - [self.keyboardViewController height]];
    }
    return self;
}

- (void)setDelegate:(id<KZPMusicKeyboardDelegate, KZPMusicKeyboardControlDelegate>)delegate
{
    [self.keyboardViewController registerMusicDelegate:delegate controlDelegate:self];
    _delegate = delegate;
}


#pragma mark - KZPMusicKeyboardControlDelegate -


- (void)keyboardWasDismissed
{
    [self hideWithCompletion:^{
        if ([self.delegate respondsToSelector:@selector(keyboardWasDismissed)]) {
            [self.delegate keyboardWasDismissed];
        }
    }];
}

- (void)keyboardDidSendBackspace
{
    if ([self.delegate respondsToSelector:@selector(keyboardDidSendBackspace)]) {
        [self.delegate keyboardDidSendBackspace];
    }
}


#pragma mark - Interface -


- (void)show
{
    [self showWithCompletion:^{}];
}

// Make sure settings are passed to VC by this point?
- (void)showWithCompletion:(void (^)())completionBlock
{
    [self.keyboardViewController reconfigureForSettings];
    
    if (self.windowView == nil) {
        self.windowView = [[KZPKeyboardSuperview alloc] initAndAddToKeyWindow];
        self.windowView.supportedInterfaceOrientations = AGInterfaceOrientationMaskLandscape;
    }
    
    [self.keyboardViewController.view setFrameY:[self screenHeight]];
    [self.windowView addSubview:self.keyboardViewController.view];
    
    if ([self shouldAnimate]) {
        [UIView animateWithDuration:0.3 animations:^{
            [self moveKeyboardViewOnscreen];
        } completion:^(BOOL finished) {
            completionBlock();
        }];
    } else {
        [self moveKeyboardViewOnscreen];
        completionBlock();
    }
    
    
    CGFloat landscapeScreenWidth = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.windowView.passThroughFrame = CGRectMake(0, 0, landscapeScreenWidth, self.keyboardViewController.view.frame.origin.y);
}

- (void)hide
{
    [self hideWithCompletion:^{}];
}

- (void)hideWithCompletion:(void (^)())completionBlock
{
    if ([self shouldAnimate]) {
        [UIView animateWithDuration:0.3 animations:^{
            [self moveKeyboardViewOffscreen];
        } completion:^(BOOL finished) {
            [self destroyWindowView];
            completionBlock();
        }];
    } else {
        [self destroyWindowView];
        completionBlock();
    }
}

- (CGFloat)screenHeight
{
    return MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

- (void)moveKeyboardViewOnscreen
{
    [self.keyboardViewController.view setFrameY:[self screenHeight] - [self.keyboardViewController height]];
}

- (void)moveKeyboardViewOffscreen
{
    [self.keyboardViewController.view setFrameY:[self screenHeight]];
}

- (void)destroyWindowView
{
//    self.windowView = [self.keyboardViewController.view superview];
    [self.keyboardViewController.view removeFromSuperview];
    
    // TODO: This is to do with switching between text fields without dismissing?
    //        if (deactivate) {
    [self.windowView removeFromSuperview];
    self.windowView = nil;
}



// What is the purpose of this?
//- (void)removeImmediately
//{
//    [self.windowView removeFromSuperview];
//    self.windowView = nil;
//}


#pragma mark - Developer Settings -


- (void)enableSpelling:(BOOL)setting { [self.keyboardViewController enableSpelling:setting]; }
- (void)enablePitchControl:(BOOL)setting { [self.keyboardViewController enablePitchControl:setting]; }
- (void)enableChordDetection:(BOOL)setting { [self.keyboardViewController enableChordDetection:setting]; }
- (void)enableDurationControls:(BOOL)setting { [self.keyboardViewController enableDurationControls:setting]; }
- (void)durationControlsActive:(BOOL)setting { [self.keyboardViewController durationControlsActive:setting]; }
- (void)enableLocalAudio:(BOOL)setting { [self.keyboardViewController enableLocalAudio:setting]; }
- (void)enableManualDismiss:(BOOL)setting { [self.keyboardViewController enableManualDismiss:setting]; }
- (void)enableBackspaceControl:(BOOL)setting { [self.keyboardViewController enableBackspaceControl:setting]; }
- (void)chordSensitivity:(NSUInteger)setting { [self.keyboardViewController chordSensitivity:setting]; }

@end
