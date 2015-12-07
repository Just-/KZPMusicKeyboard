//
//  KZPMusicKeyboardRibbonViewController.h
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import "ViewController.h"
#import "KZPMusicKeyboardDelegate.h"
#import "KZPMusicSciNotation.h"
#import "KZPMusicKeyboardDataAggregator.h"


@protocol KZPMusicKeyboardRibbonControlDelegate <NSObject>

- (void)deferToManualSpelling;

@end


@interface KZPMusicKeyboardRibbonViewController : UIViewController

@property (weak, nonatomic) id<KZPMusicKeyboardControlDelegate> controlDelegate;
@property (weak, nonatomic) id<KZPMusicKeyboardRibbonControlDelegate> delegate;

@property (weak, nonatomic) KZPMusicKeyboardDataAggregator *musicDataAggregator;

@property (nonatomic, setter=enableSpelling:) BOOL spellingEnabled;
@property (nonatomic, setter=enableDurationControls:) BOOL durationControlsEnabled;
@property (nonatomic, setter=enableDismiss:) BOOL dismissEnabled;
@property (nonatomic, setter=enableBackspace:) BOOL backspaceEnabled;
@property (nonatomic) BOOL durationControlsActive;

- (MusicSpelling)selectedAccidental;
- (void)resetSpelling;

- (NSString *)selectedPatch;

- (void)resetDuration;

- (void)sendDurationAndSpelling;

@end
