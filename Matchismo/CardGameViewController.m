//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Mahesh Murthy on 2/2/13.
//  Copyright (c) 2013 Mahesh Murthy. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation CardGameViewController

- (CardMatchingGame *) game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck: [[PlayingCardDeck alloc]init]];
    }
    return _game;
}

- (void) setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (void) setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void) updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex: [self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    if (self.game.flippedCards.count == 0) {
        self.resultLabel.text = nil;
    } else if (self.game.flippedCards.count == 1) {
        Card *card = self.game.flippedCards[0];
        self.resultLabel.text = [NSString stringWithFormat:@"Flipped up %@", card.contents];
    } else if (self.game.flippedCards.count == 2) {
        Card *card1 = self.game.flippedCards[0];
        Card *card2 = self.game.flippedCards[1];

        if (self.game.flipScore < 0) {
            [self.resultLabel setNumberOfLines:0];
            self.resultLabel.text = [NSString stringWithFormat:@"%@ and %@ don't match! %d point penalty!", card1.contents, card2.contents, abs(self.game.flipScore)];
        } else {
            self.resultLabel.text = [NSString stringWithFormat:@"Matched %@ and %@ for %d points!", card1.contents, card2.contents, self.game.flipScore];
        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex: [self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}

@end
