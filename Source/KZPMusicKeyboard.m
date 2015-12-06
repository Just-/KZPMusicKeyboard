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

@interface KZPMusicKeyboard ()

@property (strong, nonatomic) KZPMusicKeyboardViewController *keyboardViewController;
@property (strong, nonatomic) AGWindowView *windowView;

@end

@implementation KZPMusicKeyboard

static KZPMusicKeyboard *keyboardInstance;

+ (KZPMusicKeyboard *)keyboard
{
    if (!keyboardInstance) keyboardInstance = [[KZPMusicKeyboard alloc] init];
    return keyboardInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.keyboardViewController = [[KZPMusicKeyboardViewController alloc] initWithNibName:@"KZPMusicKeyboardView" bundle:nil];
        [self.keyboardViewController.view setFrameY:[[UIScreen mainScreen] bounds].size.width - self.keyboardViewController.view.frame.size.height];

    }
    return self;
}

- (void)setDelegate:(id<KZPMusicKeyboardDelegate>)delegate
{
    self.keyboardViewController.delegate = delegate;
}


#pragma mark - Interface -

- (void)show
{
    [self showWithCompletion:^{}];
}

// Make sure settings are passed to VC by this point?
- (void)showWithCompletion:(void (^)())completionBlock
{
    if (self.windowView == nil) {
        self.windowView = [[AGWindowView alloc] initAndAddToKeyWindow];
        self.windowView.supportedInterfaceOrientations = AGInterfaceOrientationMaskLandscape;
    }
    // iOS7 and iOS8+ have different notions of screen height
    CGFloat landscapeScreenHeight = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    CGFloat landscapeScreenWidth = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.keyboardViewController.view setFrameY:landscapeScreenHeight];
    [self.windowView addSubview:self.keyboardViewController.view];
    
    [UIView animateWithDuration:self.shouldAnimate ? 0.3 : 0.0 animations:^{
        [self.keyboardViewController.view setFrameY:landscapeScreenHeight -
         self.keyboardViewController.view.frame.size.height];
    }];
//    self.windowView.passThroughFrame = CGRectMake(0, 0, landscapeScreenWidth, self.keyboardViewController.view.frame.origin.y);    
}

- (void)hide
{
    [self hideWithCompletion:^{}];
}

- (void)hideWithCompletion:(void (^)())completionBlock
{
    // iOS7 and iOS8+ have different notions of screen height
    CGFloat landscapeScreenHeight = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [UIView animateWithDuration:self.shouldAnimate ? 0.3 : 0.0 animations:^{
        [self.keyboardViewController.view setFrameY:landscapeScreenHeight];
    } completion:^(BOOL finished) {
        UIView *windowView = [self.keyboardViewController.view superview];
        [self.keyboardViewController.view removeFromSuperview];
        
        // TODO: This is to do with switching between text fields without dismissing?
//        if (deactivate) {
            [windowView removeFromSuperview];
            self.windowView = nil;
//        }
        completionBlock();
    }];
}

// What is the purpose of this?
//- (void)removeImmediately
//{
//    [self.windowView removeFromSuperview];
//    self.windowView = nil;
//}

@end
