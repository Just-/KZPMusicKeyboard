//
//  KZPMusicKeyboardDataAggregator.h
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPMusicKeyboardDelegate.h"

@interface KZPMusicKeyboardDataAggregator : NSObject

@property (weak, nonatomic) id<KZPMusicKeyboardDelegate> delegate;

@end
