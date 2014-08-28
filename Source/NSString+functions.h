//
//  NSString+functions.h
//  Schillinger
//
//  Created by Matt Rankin on 1/03/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (functions)

+ (NSString *)token;
- (BOOL)contains:(NSString *)substring;
- (BOOL)startsWith:(NSString *)substring;
- (NSString *)stringBetweenOpeningToken:(NSString *)tkOpen closingToken:(NSString *)tkClose;
- (NSString *)stringByRemovingOccurrencesOfString:(NSString *)string;
- (NSString *)stringByRemovingLastCharacter;
- (BOOL)matchedByRegex:(NSString *)pattern;
- (NSString *)trimWhiteSpace;
+ (NSString *)randomStringOfLength:(NSUInteger)length;
- (NSString *)convertToCamelCase;
- (NSString *)convertToDisplayString;
+ (NSString *)commaDelimitedListWithArray:(NSArray *)array;

@end
