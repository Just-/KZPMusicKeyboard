//
//  KZPMusicKeyboardManager.m
//  KZPMusicKeyboard
//
//  Created by Matt Rankin on 1/07/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import "KZPMusicKeyboardManager.h"
#import "UIView+frameOperations.h"
#import "AGWindowView.h"
#import "KZPMusicTextField.h"

@interface KZPMusicKeyboardManager ()

@property (strong, nonatomic) KZPMusicKeyboardViewController *pianoKeyboard;
@property (strong, nonatomic) AGWindowView *windowView;

@end

@implementation KZPMusicKeyboardManager

static KZPMusicKeyboardManager *defaultManager;

+ (KZPMusicKeyboardManager *)defaultManager
{
    if (!defaultManager) defaultManager = [[KZPMusicKeyboardManager alloc] init];
    return defaultManager;
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

- (UIView *)showControllerWithRhythmControls:(BOOL)needsRhythmControls
{
    if (self.windowView == nil) {
        self.windowView = [[AGWindowView alloc] initAndAddToKeyWindow];
        self.windowView.supportedInterfaceOrientations = AGInterfaceOrientationMaskLandscape;
    }
    self.pianoKeyboard.rhythmControlsEnabled = needsRhythmControls;
    
    // iOS7 and iOS8 have different notions of screen height
    CGFloat landscapeScreenHeight = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [self.pianoKeyboard.view setFrameY:landscapeScreenHeight]; // landscape
    [self.windowView addSubview:self.pianoKeyboard.view];
    [UIView animateWithDuration:0.3 animations:^{
        [self.pianoKeyboard.view setFrameY:landscapeScreenHeight - self.pianoKeyboard.view.frame.size.height];
    }];
    return self.windowView;
}

- (void)hideControllerWithCompletionBlock:(void (^)())completionBlock
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.pianoKeyboard.view setFrameY:[UIScreen mainScreen].bounds.size.width]; // landscape
    } completion:^(BOOL finished) {
        UIView *windowView = [self.pianoKeyboard.view superview];
        [self.pianoKeyboard.view removeFromSuperview];
        if (completionBlock == NULL) {
            [windowView removeFromSuperview];
            self.windowView = nil;
        } else {
            completionBlock();
        }
    }];
}

- (void)removeImmediately
{
    [self.windowView removeFromSuperview];
    self.windowView = nil;
}

@end
