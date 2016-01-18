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
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self startNewGame];
}

@end
