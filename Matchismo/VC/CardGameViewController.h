//
//  ViewController.h
//  Matchismo
//
//  Created by Gennadi Iosad on 04/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
@interface CardGameViewController : UIViewController

//abstract, should return a deck of card that follow a certain match rule
- (Deck *)createDeck;

//abstract, returns the string of the value of /c card
-(NSAttributedString *)titleForCard:(Card *)card;

//abstract, returns title for /c card in its current state
-(NSAttributedString *)titleForCardInCurrentState:(Card *)card;

//abstract, returns an image for /c card current state
-(UIImage *)backgroundImageForCardInCurrentState:(Card *)card;


@end

