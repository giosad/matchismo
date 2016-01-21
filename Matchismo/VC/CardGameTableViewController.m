// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "CardGameTableViewController.h"
#import "ViewAnimationQueue.h"
#import "Grid.h"
NS_ASSUME_NONNULL_BEGIN
@interface CardGameTableViewController()
@property (strong, nonatomic) NSMutableArray<CardView*> *cardViewsInternal;
@property (strong, nonatomic) Grid *grid;
@property (strong, nonatomic) ViewAnimationQueue *viewAnimationQueue;
@end
@implementation CardGameTableViewController


- (void) updateCardView:(CardView*)cardView choosen:(BOOL)chosen;
{
//  NSLog(@"updateCardView");
  if (chosen != cardView.choosen) {
    
  //UIViewAnimationOptionTransitionCrossDissolve
  [self.viewAnimationQueue transitionWithView:cardView
                    duration:0.5
                     options:UIViewAnimationOptionTransitionFlipFromLeft
                  animations:^{
                    cardView.choosen = !cardView.choosen;
                  }
                  completion:NULL];
  }
}


- (Grid*) grid
{
  if (!_grid) {
    _grid = [[Grid alloc] init];
  }
  return _grid;
}


- (ViewAnimationQueue*) viewAnimationQueue
{
  if (!_viewAnimationQueue) {
    _viewAnimationQueue = [[ViewAnimationQueue alloc] init];
  }
  return _viewAnimationQueue;
}


- (void) addCardView:(CardView*)cardView
{
  [self.cardViewsInternal addObject:cardView];
  CGRect fr = CGRectMake(-300, -300, self.grid.cellSize.width*2, self.grid.cellSize.height*2);
  cardView.frame = fr;
  
  [self.view addSubview:cardView];
  UITapGestureRecognizer *singleFingerTap =
  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCardTap:)];
  [cardView addGestureRecognizer:singleFingerTap];
  [self positionCardView:cardView atPosition:[self.cardViewsInternal count] - 1];
}


- (void) removeCardView:(CardView*)cardView
{

  NSUInteger i = [self.cardViewsInternal indexOfObject:cardView];
  if(i == NSNotFound) {
    return;
  }

  CardView *lastView = [self.cardViewsInternal lastObject];
  if (lastView != cardView) {
    self.cardViewsInternal[i] = [self.cardViewsInternal lastObject];
  }
  [self.cardViewsInternal removeLastObject];
  [self.viewAnimationQueue animateWithDuration:0.5
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     cardView.frame = CGRectMake(-150, -150, 10, 10);
                   }
                   completion:^(BOOL finished) {
                     [cardView removeFromSuperview];
                     int pos = 0;
                     if (self.closeGapsWhenCardsRemoved) {
                       for (CardView *cardView in self.cardViewsInternal) {
                         [self positionCardView:cardView atPosition:pos++];
                       }
                     }

                   }];

}

- (void) removeAllCardViews
{
  NSArray<CardView*> *cardViewsToRemove = [self.cardViewsInternal copy];
  [self.cardViewsInternal removeAllObjects];
  [self.viewAnimationQueue animateWithDuration:0.6
                                         delay:0.0
                                       options:UIViewAnimationOptionCurveEaseIn
                                    animations:^{
                                      for (CardView *cardView in cardViewsToRemove) {
                                        cardView.frame = CGRectMake(-150, -150, cardView.frame.size.height, cardView.frame.size.width);
                                      }
                                    }
                                    completion:^(BOOL finished) {                                      
                                      for (CardView *cardView in cardViewsToRemove) {
                                        [cardView removeFromSuperview];
                                      }
                                    }];
}


- (NSArray<CardView*> *)cardViews
{
  return [self.cardViewsInternal copy];
}


- (NSMutableArray<CardView*> *)cardViewsInternal
{
  if (!_cardViewsInternal) {
    _cardViewsInternal = [[NSMutableArray<CardView*> alloc] init];
  }
  return _cardViewsInternal;
}


- (void)handleCardTap:(UITapGestureRecognizer *)sender
{
  if (sender.state == UIGestureRecognizerStateEnded)
  {
    self.cardTapEventHandler((CardView*)sender.view);
  }
}


- (void) positionCardView:(CardView *)cardView atPosition:(NSUInteger)position
{

    NSUInteger row = position / self.grid.columnCount;
    NSUInteger col = position % self.grid.columnCount;
    [self.viewAnimationQueue animateWithDuration:(0.0 + 0.2f) animations:^{
      cardView.frame = [self.grid frameOfCellAtRow:row inColumn:col];
    }];

}

- (void) alignCardsToViewSize:(CGSize)newSize
{
  NSLog(@"CardGameTableViewController::alignCardsToViewSize newSize %.1fx%.1f ", newSize.height, newSize.width);
  if (CGSizeEqualToSize(self.grid.size, newSize)) {
      NSLog(@"CardGameTableViewController::alignCardsToViewSize nothing to do");
      return; //nothing to do
  }
  NSLog(@"CardGameTableViewController::alignCardsToViewSize realigning cards...");

	 // self.grid = nil;
  self.grid.cellAspectRatio = 0.7;
  self.grid.minimumNumberOfCells = 30;
  self.grid.size = newSize;
  NSLog(@"grid.resolved %d", self.grid.inputsAreValid);
  NSLog(@"grid: %@", [self.grid description]);
  int pos = 0;
  for (CardView *cardView in self.cardViewsInternal) {
    [self positionCardView:cardView atPosition:pos++];
  }

}

-(void) viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  NSLog(@"CardGameTableViewController::viewDidLayoutSubviews %p", self);
  [self alignCardsToViewSize:self.view.bounds.size];

}

- (void)traitCollectionDidChange:(UITraitCollection * _Nullable)previousTraitCollection
{
  [super traitCollectionDidChange: previousTraitCollection];
//  NSLog(@"CardGameTableViewController::traitCollectionDidChange");
//  [self alignCardsToViewSize:self.view.bounds.size];
}

-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//  NSLog(@"CardGameTableViewController::viewWillTransitionToSize size.w %0.1f size.h %0.1f", size.width, size.height);
//  [self alignCardsToViewSize:size];
}

-(void) viewDidLoad
{
  [super viewDidLoad];
//  self.view.clipsToBounds = NO;
//  NSLog(@"CardGameTableViewController::viewDidLoad ");
  //  [self alignCardsToViewSize:self.view.bounds.size];
  
}
-(void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
//  NSLog(@"CardGameTableViewController::viewDidAppear animated=%d", animated);
//  [self alignCardsToViewSize:self.view.bounds.size];
  
}

-(void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

//  NSLog(@"CardGameTableViewController::viewWillAppear");
}
@end

NS_ASSUME_NONNULL_END
