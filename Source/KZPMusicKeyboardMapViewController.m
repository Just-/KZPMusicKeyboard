//
//  KZPMusicKeyboardMapViewController.m
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import "KZPMusicKeyboardMapViewController.h"
#import "UIView+frameOperations.h"

@interface KZPMusicKeyboardMapViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *keyboardMap;
@property (weak, nonatomic) IBOutlet UIView *mapRegionLeftShadow;
@property (weak, nonatomic) IBOutlet UIView *mapRegionRightShadow;
@property (weak, nonatomic) IBOutlet UIView *mapRegionVisible;

@end

@implementation KZPMusicKeyboardMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)updateMapRegionWindow:(CGFloat)leftX
{
    [self.mapRegionVisible setFrameX:leftX];
    [self.mapRegionLeftShadow setFrameX:0];
    [self.mapRegionLeftShadow setFrameWidth:leftX < 0 ? 0 : leftX];
    [self.mapRegionRightShadow setFrameX:leftX + self.mapRegionVisible.frame.size.width];
}


#define KEYBOARD_MAP_OVERHANG   25

#pragma mark - Keyboard Map -

- (void)panToRangeWithCenterNote:(NSUInteger)noteID animated:(BOOL)animated
{
    CGFloat positionX = (double)(noteID - 21) / 88 * self.keyboardMap.frame.size.width;
    [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
        [self panToXPosition:positionX];
    }];
}

- (void)panToXPosition:(float)x
{
    CGFloat relativePosition = x / self.keyboardMap.frame.size.width;
    [self.keyboardMainView setFrameX:-( (self.keyboardMainView.frame.size.width - self.view.frame.size.width) * relativePosition )];
    
    [self updateMapRegionWindow:-KEYBOARD_MAP_OVERHANG + relativePosition * (self.keyboardMap.frame.size.width + KEYBOARD_MAP_OVERHANG * 2 - self.mapRegionVisible.frame.size.width)];
}

- (IBAction)keyboardMapTapped:(id)sender {
    CGPoint position = [(UITapGestureRecognizer *)sender locationInView:self.keyboardMap];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self panToXPosition:position.x];
    }];
    
}



- (IBAction)keyboardMapPanned:(id)sender {
    CGPoint position = [(UIPanGestureRecognizer *)sender locationInView:self.keyboardMap];
    [self panToXPosition:position.x];
}

@end
