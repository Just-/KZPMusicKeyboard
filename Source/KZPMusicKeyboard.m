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
#import "KZPMusicKeyboardViewController.h"

static KZPMusicKeyboard *keyboardInstance;


@interface KZPMusicKeyboard () <KZPMusicKeyboardControlDelegate>

@property (strong, nonatomic) KZPMusicKeyboardViewController *keyboardViewController;
@property (strong, nonatomic) KZPKeyboardSuperview *windowView;
@property (nonatomic, copy) void (^completionBlock) ();

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
        [self applyDefaultSettings];
    }
    return self;
}

- (void)setDelegate:(id<KZPMusicKeyboardDelegate, KZPMusicKeyboardControlDelegate>)delegate
{
    [self.keyboardViewController registerMusicDelegate:delegate controlDelegate:self];
    _delegate = delegate;
}

- (void)applyDefaultSettings
{
    [self shouldAnimate:YES];
    [self enablePitchControl:YES];
    [self enableChordDetection:YES];
    [self enableSpelling:YES];
    [self enableDurationControls:YES];
    [self durationControlsActive:NO];
    [self enableLocalAudio:YES];
    [self enableBackspaceControl:NO];
    [self enableManualDismiss:YES];
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


#pragma mark - Public Interface -


- (void)show
{
    [self showWithCompletion:^{}];
}

- (void)showWithCompletion:(void (^)())completionBlock
{
    self.completionBlock = completionBlock;
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(deferredShowWithCompletion) userInfo:nil repeats:NO];
}

- (void)deferredShowWithCompletion
{
    [[UIApplication sharedApplication] keyWindow];
    [self.keyboardViewController reconfigureForSettings];
    [self.keyboardViewController.view setFrameY:[self screenHeight]];
    
    [self prepareSuperview];
    [self.windowView addSubview:self.keyboardViewController.view];
    
    if ([self shouldAnimate]) {
        [UIView animateWithDuration:0.3 animations:^{
            [self moveKeyboardViewOnscreen];
        } completion:^(BOOL finished) {
            self.completionBlock();
        }];
    } else {
        [self moveKeyboardViewOnscreen];
        self.completionBlock();
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
            [self destroySuperview];
            completionBlock();
        }];
    } else {
        [self destroySuperview];
        completionBlock();
    }
}


#pragma mark - Configuration -


- (void)enableSpelling:(BOOL)setting { [self.keyboardViewController enableSpelling:setting]; }
- (void)enablePitchControl:(BOOL)setting { [self.keyboardViewController enablePitchControl:setting]; }
- (void)enableChordDetection:(BOOL)setting { [self.keyboardViewController enableChordDetection:setting]; }
- (void)enableDurationControls:(BOOL)setting { [self.keyboardViewController enableDurationControls:setting]; }
- (void)durationControlsActive:(BOOL)setting { [self.keyboardViewController durationControlsActive:setting]; }
- (void)enableLocalAudio:(BOOL)setting { [self.keyboardViewController enableLocalAudio:setting]; }
- (void)enableManualDismiss:(BOOL)setting { [self.keyboardViewController enableManualDismiss:setting]; }
- (void)enableBackspaceControl:(BOOL)setting { [self.keyboardViewController enableBackspaceControl:setting]; }
- (void)chordSensitivity:(NSUInteger)setting { [self.keyboardViewController chordSensitivity:setting]; }


#pragma mark -


- (void)prepareSuperview
{
    if (self.windowView == nil) {
        self.windowView = [[KZPKeyboardSuperview alloc] initAndAddToKeyWindow];
        self.windowView.supportedInterfaceOrientations = AGInterfaceOrientationMaskLandscape;
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

- (void)destroySuperview
{
    [self.keyboardViewController.view removeFromSuperview];
    [self.windowView removeFromSuperview];
    self.windowView = nil;
}

@end
