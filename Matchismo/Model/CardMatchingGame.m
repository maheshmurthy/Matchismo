//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Mahesh Murthy on 2/9/13.
//  Copyright (c) 2013 Mahesh Murthy. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (readwrite, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *cards; //of cards
@property (readwrite, nonatomic) int flipScore;
@property (strong, nonatomic) NSMutableArray *flippedCards; //of cards
@end


@implementation CardMatchingGame

- (NSMutableArray*)cards {
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void) flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    self.flippedCards = [[NSMutableArray alloc] init];
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
            [self.flippedCards addObject:card];
            self.flipScore = 0;

            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [self.flippedCards addObject:otherCard];
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        card.unplayable = YES;
                        otherCard.unplayable = YES;
                        self.flipScore = matchScore * MATCH_BONUS;
                        self.score += self.flipScore;
                    } else {
                        otherCard.faceUp = NO;
                        self.flipScore = -MISMATCH_PENALTY;
                        self.score -= MISMATCH_PENALTY;
                    }
                    break;
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}

- (Card *) cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (id)initWithCardCount: (NSUInteger) count
              usingDeck: (Deck *) deck {
    self = [super init];
        
    if (self) {
        for (int i=0; i<count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}
@end
