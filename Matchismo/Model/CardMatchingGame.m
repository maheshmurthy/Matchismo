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
@property (nonatomic, readwrite) BOOL hasBegun;

@end


@implementation CardMatchingGame

- (void) markCardsUnplayable: (NSMutableArray*) cards {
    for (Card *c in cards) {
        c.unplayable = YES;
    }
}

- (void) flipCardsFaceDown: (NSMutableArray*) cards {
    for (Card *c in cards) {
        c.faceUp = NO;
    }
}

- (NSMutableArray*)cards {
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void) flipCardAtIndex:(NSUInteger)index {
    self.hasBegun = true;
    Card *card = [self cardAtIndex:index];
    self.flippedCards = [[NSMutableArray alloc] init];
    if (card && !card.isUnplayable) {
        //card is playable
        if (!card.isFaceUp) {
            //card was face down
            self.flipScore = 0;

            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [self.flippedCards addObject:otherCard];
                }
            }
            if (self.flippedCards.count == self.gameMode - 1) {
                // For 2 point game, you should have one card
                // already faceup to match. For 3 point game,
                // there should be 2 other cards facing up.
                int matchScore = [card match:self.flippedCards];
                
                if (matchScore) {
                    [self markCardsUnplayable: self.flippedCards];
                    self.flipScore = matchScore * MATCH_BONUS;
                    card.unplayable = YES;
                    self.score += self.flipScore;
                } else {
                    [self flipCardsFaceDown: self.flippedCards];
                    self.flipScore = -MISMATCH_PENALTY;
                    self.score -= MISMATCH_PENALTY;
                }
            }
            
            [self.flippedCards addObject:card];
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
    self.hasBegun = false;
    return self;
}
@end
