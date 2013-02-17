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
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSwitcher;
@end

@implementation CardGameViewController

- (CardMatchingGame *) game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck: [[PlayingCardDeck alloc]init]];
        _game.gameMode = 2;
    }
    return _game;
}

- (IBAction)dealCards:(id)sender {
    int mode = self.game.gameMode;
    _game = NULL;
    self.flipCount = 0;
    self.game.gameMode = mode;
    [self updateUI];
}

- (IBAction)switchMode:(id)sender {
    int index = [sender selectedSegmentIndex];
    if (index == 0) {
        self.game.gameMode = 2;
    } else {
        self.game.gameMode = 3;
    }
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
    [self.modeSwitcher setEnabled:!self.game.hasBegun];
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex: [self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    
    NSMutableArray *stringCards = [[NSMutableArray alloc] init];
    
    for (Card *c in self.game.flippedCards) {
        [stringCards addObject:c.contents];
    }

    if (self.game.flippedCards.count == 0) {
        self.resultLabel.text = nil;
    } else if (self.game.flippedCards.count <= self.game.gameMode - 1) {
        self.resultLabel.text = [NSString stringWithFormat:@"Flipped up %@", [stringCards componentsJoinedByString:@ " "]];
    } else if (self.game.flippedCards.count == self.game.gameMode) {
        [self.resultLabel setNumberOfLines:0];

        if (self.game.flipScore < 0) {
            self.resultLabel.text = [NSString stringWithFormat:@"%@ don't match! %d point penalty!", [stringCards componentsJoinedByString:@ " "], abs(self.game.flipScore)];
        } else {
            self.resultLabel.text = [NSString stringWithFormat:@"Matched %@ for %d points!", [stringCards componentsJoinedByString:@ " "], self.game.flipScore];
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
