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

@end

