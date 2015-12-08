//
//  KZPMusicKeyboardSpellingButton.m
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 8/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import "KZPMusicKeyboardSpellingButton.h"
#import "KZPMusicSciNotation.h"

#define EBONY_DIM       31
#define IVORY_DIM       34
#define EBONY_INSET_H    8
#define IVORY_INSET_H   22
#define EBONY_INSET_V   18
#define IVORY_INSET_V   12
#define EBONY_OFFSET    36
#define IVORY_OFFSET    40

@implementation KZPMusicKeyboardSpellingButton

- (instancetype)initWithPianoKey:(UIButton *)pianoKey
             existingButtonCount:(NSUInteger)existingButtonCount
                        modifier:(int)modifier
{
    if (!pianoKey) return nil;
    
    CGRect spellingButtonFrame = [KZPMusicKeyboardSpellingButton frameForPianoKey:pianoKey
                                                              existingButtonCount:existingButtonCount];
    
    self = [super initWithFrame:spellingButtonFrame];
    if (self) {
        NSUInteger noteID = pianoKey.tag;
        self.white = [KZPMusicSciNotation noteIsWhite:(int)noteID];
        self.noteID = noteID;
        self.tag = noteID;
        self.modifier = modifier;
        [self style];
        [self applyImage];
    }
    return self;
}

- (void)setDelegate:(id<KZPMusicKeyboardSpellingButtonDelegate>)delegate
{
    _delegate = delegate;
    [self addTarget:delegate action:@selector(spellingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

+ (CGRect)frameForPianoKey:(UIButton *)pianoKey existingButtonCount:(NSUInteger)existingButtonCount
{
    BOOL isWhite = [KZPMusicSciNotation noteIsWhite:(int)pianoKey.tag];
    int offset = isWhite ? IVORY_OFFSET : EBONY_OFFSET;
    int insetHorizontal = isWhite ? IVORY_INSET_H : EBONY_INSET_H;
    int insetVertical = isWhite ? IVORY_INSET_V : EBONY_INSET_V;
    int dimension = isWhite ? IVORY_DIM : EBONY_DIM;
    return CGRectMake(pianoKey.frame.origin.x + insetHorizontal,
                      pianoKey.frame.size.height - (existingButtonCount * offset) - insetVertical - dimension,
                      dimension,
                      dimension);
}

+ (NSArray *)imageTypes
{
    return @[@"double-flat", @"flat", @"natural", @"sharp", @"double-sharp"];
}

- (void)style
{
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 5.0;
    self.clipsToBounds = YES;
    self.alpha = 0.0;
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderColor = [self isWhite] ? [UIColor lightGrayColor].CGColor : [UIColor darkGrayColor].CGColor;
    
    self.titleLabel.text = [KZPMusicKeyboardSpellingButton imageTypes][[self modifier] + 2];
}

- (void)applyImage
{
    NSString *imageName = @"music-";
    NSArray *imageTypes = [KZPMusicKeyboardSpellingButton imageTypes];
    imageName = [imageName stringByAppendingString:imageTypes[[self modifier] + 2]];
    if ([self isWhite]) {
        imageName = [imageName stringByAppendingString:@"-inverted"];
    }
    UIImage *image = [UIImage imageNamed:imageName];
    [self setImage:image forState:UIControlStateNormal];
}

- (void)show
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
