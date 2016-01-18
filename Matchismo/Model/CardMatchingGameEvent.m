//
//  CardMatchingGameEvent.m
//  Matchismo
//
//  Created by Gennadi Iosad on 06/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "CardMatchingGameEvent.h"

@interface CardMatchingGameEvent()
@property (nonatomic,readwrite) NSInteger score;
@property (strong, nonatomic, readwrite) NSArray<Card* > *cardsReported;
@end


@implementation CardMatchingGameEvent


- (instancetype) init
{
  return nil;
}


- (instancetype) initWithScore:(NSInteger)score cardsToReport:(NSArray<Card*>*)cards
{
  if (self = [super init]) {
    self.score = score;
    self.cardsReported = cards;
  }
  return self;
}

@end
