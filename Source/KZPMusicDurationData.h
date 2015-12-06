//
//  KZPMusicDurationData.h
//  KZPMusicKeyboard
//
//  Created by Matthew Rankin on 6/12/2015.
//  Copyright © 2015 Sudoseng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KZPMusicDurationData : NSObject

@property (nonatomic, readonly, getter=isRest) BOOL rest;
@property (nonatomic, readonly, getter=isTiedForward) BOOL tiedForward;
@property (nonatomic, readonly, getter=isDotted) BOOL dotted;

@end
