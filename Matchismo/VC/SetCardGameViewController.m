//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Gennadi Iosad on 11/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardView.h"
@interface SetCardGameViewController()
@end
@implementation SetCardGameViewController


- (Deck *)createDeck //override
{
  return [[SetCardDeck alloc] init];
}

-(CardView*) newCardViewForCard:(Card*)card //override
{
  SetCard *setCard = (SetCard*)card;
  return [[SetCardView alloc] initWithShape:setCard.shape
                                    Shading:setCard.shading
                                      Color:setCard.color
                                      Count:setCard.count];
}

//-(void)viewDidLoad
//{
//  [super viewDidLoad];
//  [self startNewGame];
//}
- (void)setupGameTable
{
  [super setupGameTable];
  self.gameTableController.closeGapsWhenCardsRemoved = YES;
  self.gameTableController.cardChooseAnimation = UIViewAnimationOptionTransitionCrossDissolve;
}

@end
