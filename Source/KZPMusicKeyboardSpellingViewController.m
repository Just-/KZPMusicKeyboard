//
//  KZPMusicKeyboardSpellingViewController.m
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import "KZPMusicKeyboardSpellingViewController.h"
#import "KZPMusicSciNotation.h"

@interface KZPMusicKeyboardSpellingViewController ()


// Spelling
@property (strong, nonatomic) NSArray *imageNames;
@property (strong, nonatomic) NSDictionary *imageNameMap;
@property (strong, nonatomic) NSMutableDictionary *spellingButtons;
@property (strong, nonatomic) NSMutableDictionary *spellingChoices;

@end

@implementation KZPMusicKeyboardSpellingViewController

//- (NSMutableDictionary *)spellingButtons
//{
//    if (!_spellingButtons) _spellingButtons = [NSMutableDictionary dictionary];
//    return _spellingButtons;
//}
//

//
//- (NSMutableArray *)spellings
//{
//    if (!_spellings) _spellings = [NSMutableArray array];
//    return _spellings;
//}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageNames = @[@"double-flat", @"flat", @"natural", @"sharp", @"double-sharp"];
    self.imageNameMap = @{@"double-flat": @(-2),
                          @"flat": @(-1),
                          @"natural": @(0),
                          @"sharp": @(1),
                          @"double-sharp": @(2)};
    
}



#pragma mark - Manual Spelling -

#define EBONY_DIM       31
#define IVORY_DIM       34
#define EBONY_INSET_H    8
#define IVORY_INSET_H   22
#define EBONY_INSET_V   18
#define IVORY_INSET_V   12
#define EBONY_OFFSET    36
#define IVORY_OFFSET    40

- (void)displayAccidentalOptionsForNoteID:(int)noteID
{
    self.spellingSurface.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.spellingSurface.alpha = 0.3;
    }];
    
    int order[5] = {-2, 2, -1, 1, 0};
    
    BOOL isWhite;
    int offset, inset_h, inset_v, dim, buttonCount = 0;
    
    if ([KZPMusicSciNotation noteIsWhite:noteID]) {
        offset = IVORY_OFFSET;
        inset_h = IVORY_INSET_H;
        inset_v = IVORY_INSET_V;
        dim = IVORY_DIM;
        isWhite = YES;
    } else {
        offset = EBONY_OFFSET;
        inset_h = EBONY_INSET_H;
        inset_v = EBONY_INSET_V;
        dim = EBONY_DIM;
        isWhite = NO;
    }
    
    UIButton *key;
//    for (UIButton *k in self.keyButtons) {
//        if ([k tag] == noteID) key = k;
//    }
    
    CGRect keyFrame = [key frame];
    NSMutableArray *spellingButtons = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++) {
        int modifier = order[i];
        if ([KZPMusicSciNotation modifier:modifier isLegalForPitch:noteID]) {
            CGRect accidentalFrame = CGRectMake(keyFrame.origin.x + inset_h,
                                                keyFrame.size.height - (buttonCount * offset) - inset_v - dim,
                                                dim, dim);
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"music-%@%@", self.imageNames[modifier + 2], isWhite ? @"" : @"-inverted"]];
            UIButton *button = [[UIButton alloc] initWithFrame:accidentalFrame];
            button.tag = noteID;
            [button setImage:image forState:UIControlStateNormal];
            button.clipsToBounds = YES;
            [button addTarget:self action:@selector(spellingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.borderWidth = 1.0;
            button.layer.cornerRadius = 5.0;
            button.layer.borderColor = isWhite ? [UIColor lightGrayColor].CGColor : [UIColor darkGrayColor].CGColor;
            button.alpha = 0.0;
            button.backgroundColor = [UIColor clearColor];
            button.titleLabel.text = self.imageNames[modifier + 2];
            [UIView animateWithDuration:0.3 animations:^{
                button.alpha = 1.0;
            }];
            buttonCount++;
            [spellingButtons addObject:button];
            [self.spellingSurface addSubview:button];
            [self.spellingSurface bringSubviewToFront:button];
        }
    }
    
    [self.spellingButtons setObject:spellingButtons forKey:[NSNumber numberWithInt:noteID]];
}

- (void)spellingButtonPressed:(UIButton *)sender
{
    NSNumber *key = [NSNumber numberWithInt:[sender tag]];
    NSArray *buttonSet = [self.spellingButtons objectForKey:key];
    [self.spellingButtons removeObjectForKey:key];
    [UIView animateWithDuration:0.3 animations:^{
        for (UIButton *button in buttonSet) {
            button.alpha = 0.0;
        }
    } completion:^(BOOL finished) {
        for (UIButton *button in buttonSet) {
            [button removeFromSuperview];
        }
    }];
    [self.spellingChoices setObject:[self.imageNameMap valueForKey:sender.titleLabel.text] forKey:key];
    
    // Check if all accidentals are picked
    for (NSNumber *k in [self.spellingChoices allKeys]) {
        if ([[self.spellingChoices objectForKey:k] isEqual:[NSNull null]]) {
            return;
        }
    }
    
    // Reflush note info with chosen accidentals
    self.spellingButtons = nil;
//    self.manualSpellButton.selected = NO;
//    self.manualSpellButton.layer.opacity = 0.5;
//    self.noteIDs = [NSMutableArray arrayWithArray:[self.spellingChoices allKeys]];
//    self.spellings = [NSMutableArray arrayWithArray:[self.spellingChoices allValues]];
//    [self flushAggregatedNoteInformation];
//    
//    [UIView animateWithDuration:0.2 animations:^{
//        self.keyboardDefocusView.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        self.keyboardDefocusView.hidden = YES;
//    }];
}

- (void)dismissWithCompletion:(void (^)())completionBlock
{
    [UIView animateWithDuration:0.2 animations:^{
        self.spellingSurface.alpha = 0.0;
        for (NSArray *buttonSet in [self.spellingButtons allValues]) {
            for (UIButton *button in buttonSet) {
                button.alpha = 0.0;
            }
        }
        
    } completion:^(BOOL finished) {
        for (NSArray *buttonSet in [self.spellingButtons allValues]) {
            for (UIButton *button in buttonSet) {
                [button removeFromSuperview];
            }
        }
        self.spellingButtons = nil;
        completionBlock();
    }];
}

@end
