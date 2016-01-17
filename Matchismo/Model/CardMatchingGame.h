//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Gennadi Iosad on 06/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "CardMatchingGameEvent.h"

@interface CardMatchingGame : NSObject

//designated initializer
- (instancetype)initWithDeck:(Deck*)deck;
-(void)chooseCardWithId:(id)carId;
-(Card*)cardWithId:(id)cardId;
-(NSArray<Card*>*) drawNewCards:(NSUInteger)count;
@property (nonatomic) NSUInteger matchNumRule;
@property (strong, nonatomic) CardMatchingGameEvent* lastEvent;
@property (nonatomic, readonly) NSInteger score;

@end
