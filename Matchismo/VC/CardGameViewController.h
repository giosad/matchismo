//
//  ViewController.h
//  Matchismo
//
//  Created by Gennadi Iosad on 04/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardView.h"

NS_ASSUME_NONNULL_BEGIN
@interface CardGameViewController : UIViewController

//abstract, should return a deck of card that follow a certain match rule
- (Deck *)createDeck;

-(CardView*) newCardViewForCard:(Card*)card; //abstract


-(void)startNewGame;
@end
NS_ASSUME_NONNULL_END
