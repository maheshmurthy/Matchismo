//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Mahesh Murthy on 2/2/13.
//  Copyright (c) 2013 Mahesh Murthy. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@end

@implementation CardGameViewController

- (void) setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.flipCount++;
}

@end
