//
//  SetDeck.m
//  Matchismo
//
//  Created by Gennadi Iosad on 11/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//
#import "SetCard.h"
#import "SetCardDeck.h"

@implementation SetCardDeck
- (instancetype) init
{
  if (self = [super init]) {
    for (int shape = 0; shape < kSetCardShapeTypeCount; shape++) {
      for (int color = 0; color < kSetCardColorCount; color++) {
        for (int shading = 0; shading < kSetCardShadingCount; shading++) {
          for (NSUInteger count = 1; count <= kSetCardShapeNumCount; count++) {
            SetCard *card = [[SetCard alloc] init];
            card.shape = shape;
            card.color = color;
            card.shading = shading;
            card.count = count;
            
            [self addCard:card];
          }
        }
      }
    }
  }
  return self;
}

@end
