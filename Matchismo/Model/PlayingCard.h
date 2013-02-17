//
//  PlayingCard.h
//  Matchismo
//
//  Created by Mahesh Murthy on 2/3/13.
//  Copyright (c) 2013 Mahesh Murthy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"


@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSUInteger) maxRank;

+ (NSArray *) validSuits;


@end
