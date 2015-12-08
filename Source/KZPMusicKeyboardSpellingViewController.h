//
//  KZPMusicKeyboardSpellingViewController.h
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPMusicKeyboardDelegate.h"
#import "KZPMusicKeyboardDataAggregator.h"

@protocol KZPMusicKeyboardSpellingDelegate <NSObject>

- (void)showSpellingSurface;
- (void)hideSpellingSurface;

@end

@interface KZPMusicKeyboardSpellingViewController : NSObject

@property (weak, nonatomic) id<KZPMusicKeyboardSpellingDelegate> delegate;
@property (weak, nonatomic) KZPMusicKeyboardDataAggregator *musicDataAggregator;

@property (weak, nonatomic) UIView *spellingSurface;
@property (strong, nonatomic) NSDictionary *keyButtonsByNoteID;

@end
