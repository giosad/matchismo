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


@interface SetCard : Card
@property (nonatomic) NSUInteger shape;
@property (nonatomic) NSUInteger shading;
@property (nonatomic) NSUInteger color;
@property (nonatomic) NSUInteger count;

@end
