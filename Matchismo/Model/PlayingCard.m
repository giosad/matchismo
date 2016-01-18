//
//  PlayingCard.m
//  Matchismo
//
//  Created by Gennadi Iosad on 05/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "PlayingCard.h"
@interface PlayingCard()
@property (strong, nonatomic, readwrite) NSString *suit;
@property (nonatomic, readwrite) NSUInteger rank;
- (int)matchOtherCard:(PlayingCard *) otherCard;
@end
@implementation PlayingCard
#pragma mark initializers
- (instancetype) init
{
  return nil;
}

- (instancetype) initWithRank:(NSUInteger)rank suit:(NSString *)suit
{
  if (self = [super init]) {
    if ([[PlayingCard validSuits] containsObject:suit]) {
      self.suit = suit;
    }
    if (rank <= [PlayingCard maxRank]) {
      self.rank = rank;
    }
  }
  return self;
}

#pragma mark -

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


+ (NSArray *)validSuits
{
  return @[@"♣︎", @"♠︎", @"♦︎", @"♥︎"];
}


+ (NSUInteger)maxRank
{
  return 12;
}



@end
