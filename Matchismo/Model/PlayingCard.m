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
    // /2 since we counted each match twice, / count for score normalization.
    return totalScore / 2 / [allCards count];
}


- (NSString *) contents
{
    NSArray *rankStrings =[PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}


@synthesize suit = _suit; // because we provide setter AND getter

+ (NSArray *)validSuits
{
    return @[@"♥️", @"♦️", @"♠️", @"♣️"];
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
    return [[self rankStrings] count]-1;
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

-(void)setRank:(NSUInteger) rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
