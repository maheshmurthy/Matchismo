//
//  Card.m
//  Matchismo
//
//  Created by Mahesh Murthy on 2/3/13.
//  Copyright (c) 2013 Mahesh Murthy. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards {
    int score = 0;
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    return score;
}

@end
