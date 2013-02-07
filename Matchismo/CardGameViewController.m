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

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) PlayingCardDeck *deck;
@end

@implementation CardGameViewController

- (void) setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    
    if (!sender.isSelected) {
        PlayingCard *card = (PlayingCard*)[self.deck drawRandomCard];
        [sender setTitle:[NSString stringWithFormat:@"%@", card.contents] forState: UIControlStateSelected];
    }
    sender.selected = !sender.isSelected;
    self.flipCount++;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.deck = [[PlayingCardDeck alloc] init];
}

@end
