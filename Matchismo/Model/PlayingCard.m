//
//  PlayingCard.m
//  Matchismo
//
//  Created by Mahesh Murthy on 2/3/13.
//  Copyright (c) 2013 Mahesh Murthy. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;


+ (NSArray *) validSuits {
    return @[@"♥", @"♦", @"♠", @"♣"];
}

- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

+ (NSArray *) rankStrings {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger) maxRank { return [self rankStrings].count - 1;}


- (void) setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (int) match:(NSArray *)otherCards {
    int score = 0;
    BOOL rankMatch = true;
    BOOL suitMatch = true;
    for (PlayingCard *card in otherCards) {
        if (self.rank != card.rank) {
            rankMatch = false;
        }
        if (![self.suit isEqualToString:card.suit]) {
            suitMatch = false;
        }
        
        if (self.rank == card.rank) {
            score+= 4;
        } else if ([self.suit isEqualToString:card.suit]) {
            score+= 1;
        }
    }
    if (!rankMatch && !suitMatch) score = 0;
    return score;
}


@end
