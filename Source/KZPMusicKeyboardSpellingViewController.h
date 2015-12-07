//
//  KZPMusicKeyboardSpellingViewController.h
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import "ViewController.h"
#import "KZPMusicKeyboardDelegate.h"
#import "KZPMusicKeyboardDataAggregator.h"

@protocol KZPMusicKeyboardSpellingDelegate <NSObject>

- (void)manualSpellingComplete;

@end

@interface KZPMusicKeyboardSpellingViewController : UIViewController

@property (weak, nonatomic) id<KZPMusicKeyboardSpellingDelegate> delegate;
@property (weak, nonatomic) KZPMusicKeyboardDataAggregator *musicDataAggregator;

@property (weak, nonatomic) UIView *spellingSurface;

@property (strong, nonatomic) NSDictionary *keyButtonsByNoteID;

- (void)dismissWithCompletion:(void (^)())completionBlock;

@end
