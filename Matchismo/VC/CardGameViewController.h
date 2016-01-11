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
- (Deck *)createDeck; //abstract, should return a deck of card that follow a certain match rule
-(NSAttributedString *)titleForCard:(Card *)card; //abstract, returns title for /c card in its current state
-(NSAttributedString *)cardInfo:(Card *)card; //abstract, returns the string of the value of /c card
-(UIImage *)backgroundImageForCard:(Card *)card; //abstract, returns an image for /c card current state


@end

