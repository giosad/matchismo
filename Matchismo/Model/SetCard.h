//
//  SetCard.h
//  Matchismo
//
//  Created by Gennadi Iosad on 11/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "Card.h"
#import <UIKit/UIColor.h>


extern const NSUInteger kSetCardShapeNumCount;
extern const NSUInteger kSetCardShapeTypeCount;
extern const NSUInteger kSetCardColorCount;
extern const NSUInteger kSetCardShadingCount;

/// Set game card with specific card properties
@interface SetCard : Card

- (instancetype) initWithShape:(NSUInteger) shape
                       shading:(NSUInteger) shading
                         color:(NSUInteger) color
                         count:(NSUInteger) count;


@property (nonatomic, readonly) NSUInteger shape;
@property (nonatomic, readonly) NSUInteger shading;
@property (nonatomic, readonly) NSUInteger color;
@property (nonatomic, readonly) NSUInteger count;

@end
