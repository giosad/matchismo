//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Gennadi Iosad on 06/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
NS_ASSUME_NONNULL_BEGIN
@interface CardMatchingGame : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDeck:(Deck*)deck NS_DESIGNATED_INITIALIZER;

-(void)chooseCardWithId:(id)carId;
-(Card*)cardWithId:(id)cardId;
-(NSArray<Card*>*) dealCards:(NSUInteger)count;
@property (nonatomic) NSUInteger matchNumRule;

@property (nonatomic, readonly) NSInteger score;

@end
NS_ASSUME_NONNULL_END