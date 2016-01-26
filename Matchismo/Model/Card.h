//
//  Card.h
//  Matchismo
//
//  Created by Gennadi Iosad on 05/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import <Foundation/Foundation.h>


/// Abstract Card object representation, to be subclassed to implement a specific card attributes
/// and matching logic
@interface Card : NSObject

/// Text summary of the card face markings, can be nil
@property (strong, nonatomic, readonly) NSString *contents;

/// Card attribute tells whether the card was chosen by a user
@property (nonatomic, getter=isChosen) BOOL chosen;

/// Tells if the card was matched during the game and shouldn't be played anymore
@property (nonatomic, getter=isMatched) BOOL matched;

/// Returns a score for the match of the card with \c otherCards
- (int)match:(NSArray *) otherCards;

/// Returns an opaque handle to VC, should be unique for a card
@property (nonatomic, readonly) id cardId;

@end
