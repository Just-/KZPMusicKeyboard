//
//  KZPMusicKeyboardSpellingButton.h
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 8/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KZPMusicKeyboardSpellingButton;

@protocol KZPMusicKeyboardSpellingButtonDelegate <NSObject>

- (void)spellingButtonPressed:(KZPMusicKeyboardSpellingButton *)sender;

@end

@interface KZPMusicKeyboardSpellingButton : UIButton

- (instancetype)initWithPianoKey:(UIButton *)pianoKey
             existingButtonCount:(NSUInteger)existingButtonCount
                        modifier:(int)modifier;

@property (weak, nonatomic) id<KZPMusicKeyboardSpellingButtonDelegate> delegate;

@property (nonatomic) NSNumber *noteID;
@property (nonatomic, getter=isWhite) BOOL white;
@property (nonatomic) int modifier;

- (void)style;
- (void)show;
- (void)hide;

@end
