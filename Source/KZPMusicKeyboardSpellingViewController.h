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

#define EBONY_DIM       31
#define IVORY_DIM       34
#define EBONY_INSET_H    8
#define IVORY_INSET_H   22
#define EBONY_INSET_V   18
#define IVORY_INSET_V   12
#define EBONY_OFFSET    36
#define IVORY_OFFSET    40

@protocol KZPMusicKeyboardSpellingDelegate <NSObject>

- (void)showSpellingSurface;
- (void)hideSpellingSurface;

@end

@interface KZPMusicKeyboardSpellingViewController : UIViewController

@property (weak, nonatomic) id<KZPMusicKeyboardSpellingDelegate> delegate;
@property (weak, nonatomic) KZPMusicKeyboardDataAggregator *musicDataAggregator;

@property (weak, nonatomic) UIView *spellingSurface;

@property (strong, nonatomic) NSDictionary *keyButtonsByNoteID;

- (void)dismissWithCompletion:(void (^)())completionBlock;

@end
