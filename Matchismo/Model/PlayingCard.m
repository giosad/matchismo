//
//  PlayingCard.m
//  Matchismo
//
//  Created by Gennadi Iosad on 05/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "PlayingCard.h"
@interface PlayingCard()

- (int)matchOtherCard:(PlayingCard *) otherCard;
@end
@implementation PlayingCard



- (int)matchOtherCard:(PlayingCard *) otherCard
{
    int score = 0;
    if (otherCard.rank == self.rank) {
        score = 24; //should be divisible both by 2 and 3
    } else if ([otherCard.suit isEqualToString:self.suit]) {
        score = 6; //should be divisible both by 2 and 3
    }

    return score;
}


const static int MISMATCH_PENALTY = -2;
// Find the total score for all matches in the cards array.
-(int) match:(NSArray *)cards
{
    NSArray *allCards = [cards arrayByAddingObject:self];
    int totalScore = 0;
    //go over all card pairs (twice)
    for (PlayingCard *c1 in allCards) {
        for (PlayingCard *c2 in allCards) {
            if (c1 != c2) {
                totalScore += [c1 matchOtherCard:c2];
            }
        }
    }
    
    if (totalScore > 0) {
        // /2 since we counted each match twice, / count for score normalization.
        totalScore = totalScore / 2 / [allCards count];
    } else {
        totalScore = MISMATCH_PENALTY;
    }
    return totalScore;
}


- (NSString *) contents //unused
{
    return nil;
}


@synthesize suit = _suit; // because we provide setter AND getter

+ (NSArray *)validSuits
{
    return @[@"♣︎", @"♠︎", @"♦︎", @"♥︎"];
}
- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}
- (NSString *)suit
{
    return _suit ? _suit : @"?";
}


+ (NSUInteger)maxRank
{
    return 12;
}


-(void)setRank:(NSUInteger) rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
