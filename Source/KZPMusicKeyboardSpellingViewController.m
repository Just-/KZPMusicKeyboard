//
//  KZPMusicKeyboardSpellingViewController.m
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import "KZPMusicKeyboardSpellingViewController.h"
#import "KZPMusicSciNotation.h"

@interface KZPMusicKeyboardSpellingViewController () <KZPMusicDataAggregatorDelegate>

@property (strong, nonatomic) NSArray *imageNames;
@property (strong, nonatomic) NSDictionary *imageNameMap;
@property (strong, nonatomic) NSMutableDictionary *spellingButtons;
@property (strong, nonatomic) NSMutableDictionary *spellingChoices;

@end

@implementation KZPMusicKeyboardSpellingViewController

- (NSMutableDictionary *)spellingButtons
{
    if (!_spellingButtons) _spellingButtons = [NSMutableDictionary dictionary];
    return _spellingButtons;
}



//- (NSMutableArray *)spellings
//{
//    if (!_spellings) _spellings = [NSMutableArray array];
//    return _spellings;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"loaded");

    self.imageNames = @[@"double-flat", @"flat", @"natural", @"sharp", @"double-sharp"];
    self.imageNameMap = @{@"double-flat": @(-2),
                          @"flat": @(-1),
                          @"natural": @(0),
                          @"sharp": @(1),
                          @"double-sharp": @(2)};
}

- (void)setSpellingSurface:(UIView *)spellingSurface
{
    _spellingSurface = spellingSurface;
    UITapGestureRecognizer *refocusGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelManualSpelling)];
    [_spellingSurface addGestureRecognizer:refocusGesture];
}

- (void)cancelManualSpelling
{
    [self.delegate hideSpellingSurface];
}

- (void)setMusicDataAggregator:(id<KZPMusicKeyboardDelegate>)musicDataAggregator
{
    _musicDataAggregator = musicDataAggregator;
    _musicDataAggregator.delegate = self;
}


#pragma mark - KZPMusicDataAggregatorDelegate -


- (void)provideManualSpellingForNoteValues:(NSArray *)noteValues
{
    [self.delegate showSpellingSurface];
    self.spellingChoices = [NSMutableDictionary dictionary];
    for (NSNumber *noteID in noteValues) {
        [self displayAccidentalOptionsForNoteID:[noteID intValue]];
        [self.spellingChoices setObject:[NSNull null] forKey:noteID];
    }
}


#pragma mark -


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
    
    
    UIButton *keyButton = [self.keyButtonsByNoteID objectForKey:[NSString stringWithFormat:@"%d", noteID]];
    CGRect keyButtonFrame = [keyButton frame];
    NSMutableArray *spellingButtons = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++) {
        int modifier = order[i];
        if ([KZPMusicSciNotation modifier:modifier isLegalForPitch:noteID]) {
            CGRect spellingFrame = CGRectMake(keyButtonFrame.origin.x + inset_h,
                                                keyButtonFrame.size.height - (buttonCount * offset) - inset_v - dim,
                                                dim, dim);
            UIImage *image = [self spellingButtonImageForModifier:modifier isWhite:isWhite];
            UIButton *spellingButton = [[UIButton alloc] initWithFrame:spellingFrame];
            spellingButton.tag = noteID;
            [spellingButton setImage:image forState:UIControlStateNormal];
            [self styleSpellingButton:spellingButton isWhite:isWhite];
            
            


            [spellingButton addTarget:self action:@selector(spellingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];



            spellingButton.titleLabel.text = self.imageNames[modifier + 2];
            [UIView animateWithDuration:0.3 animations:^{
                spellingButton.alpha = 1.0;
            }];
            buttonCount++;
            [spellingButtons addObject:spellingButton];
            [self.spellingSurface addSubview:spellingButton];
            [self.spellingSurface bringSubviewToFront:spellingButton];
        }
    }
    
    [self.spellingButtons setObject:spellingButtons forKey:[NSNumber numberWithInt:noteID]];
}

- (void)styleSpellingButton:(UIButton *)spellingButton isWhite:(BOOL)isWhite
{
    spellingButton.layer.borderWidth = 1.0;
    spellingButton.layer.cornerRadius = 5.0;
    spellingButton.clipsToBounds = YES;
    spellingButton.alpha = 0.0;
    spellingButton.backgroundColor = [UIColor clearColor];
    spellingButton.layer.borderColor = isWhite ? [UIColor lightGrayColor].CGColor : [UIColor darkGrayColor].CGColor;
}

- (UIImage *)spellingButtonImageForModifier:(int)modifier isWhite:(BOOL)isWhite
{
    NSString *imageName = @"music-";
    NSLog(@"%@", self.imageNames);
    imageName = [imageName stringByAppendingString:self.imageNames[modifier + 2]];
    if (isWhite) {
        imageName = [imageName stringByAppendingString:@"-inverted"];
    }
    NSLog(@"image name: %@", imageName);
    return [UIImage imageNamed:imageName];
}

- (void)spellingButtonPressed:(UIButton *)sender
{
    NSNumber *key = [NSNumber numberWithLong:[sender tag]];
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
    
    if ([self spellingSelectionsComplete]) {
        [self sendPitchAndSpellingData];
        self.spellingButtons = nil;
//        [self.delegate manualSpellingComplete];
        [UIView animateWithDuration:0.2 animations:^{
            self.spellingSurface.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.spellingSurface.hidden = YES;
        }];
    }
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

- (BOOL)spellingSelectionsComplete
{
    for (NSNumber *k in [self.spellingChoices allKeys]) {
        if ([[self.spellingChoices objectForKey:k] isEqual:[NSNull null]]) {
            return NO;
        }
    }
    return YES;
}

- (void)sendPitchAndSpellingData
{
    [self.musicDataAggregator resetPitchData];
    [self.musicDataAggregator receivePitchArray:[self.spellingChoices allKeys]];
    [self.musicDataAggregator receiveSpellingArray:[self.spellingChoices allValues]];
    [self.musicDataAggregator flush];
}

@end
