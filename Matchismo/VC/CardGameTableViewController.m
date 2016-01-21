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
    
//    
//    [UIView animateWithDuration:1.5
//                          delay:0.0
//                        options: UIViewAnimationOptionTransitionFlipFromLeft
//                     animations:^{
//                       cardView.alpha = 0;
//                     }
//                     completion:nil];
    

//    cardView.choosen = !cardView.choosen;
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
  CGRect fr = CGRectMake(-100, -100, 30, 100);
  cardView.frame = fr;
  
  [self.view addSubview:cardView];
  UITapGestureRecognizer *singleFingerTap =
  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCardTap:)];
  [cardView addGestureRecognizer:singleFingerTap];
 // [cardView setNeedsDisplay];
  //[self alignCardsToViewSize:self.view.bounds.size];
  [self positionCardView:cardView atPosition:[self.cardViewsInternal count] - 1];
  //todo animation
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
  [self.viewAnimationQueue animateWithDuration:0.1
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
//                     [cardView setNeedsDisplay];
                     cardView.frame = CGRectMake(-100, -100, 0, 0);
                     
                   }
                   completion:^(BOOL finished) {
                     [cardView removeFromSuperview];
                     int pos = 0;
                     if ([self closeCardGapsWhenRemoved] ) {
                       for (CardView *cardView in self.cardViewsInternal) {
                         [self positionCardView:cardView atPosition:pos++];
                       }
                     }

                   }];

}

- (void) removeAllCardViews
{
  [self.viewAnimationQueue animateWithDuration:0.1
                                         delay:0.0
                                       options:UIViewAnimationOptionCurveEaseIn
                                    animations:^{
                                      for (CardView *cardView in self.cardViews) {
                                        cardView.frame = CGRectMake(-100, -100, 0, 0);
                                      }
                                    }
                                    completion:^(BOOL finished) {                                      
                                      for (CardView *cardView in self.cardViews) {
                                        [cardView removeFromSuperview];
                                        
                                        [self.cardViewsInternal removeObject:cardView];
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
    //    cardView.frame = [self.grid frameOfCellAtRow:row inColumn:col];
    
    [self.viewAnimationQueue animateWithDuration:(0.0 + 0.2f) animations:^{

      cardView.frame = [self.grid frameOfCellAtRow:row inColumn:col];
      [cardView setNeedsDisplay];
    }];
//  NSLog(@"cardView newPos %0.1f, %0.1f", cardView.frame.origin.x, cardView.frame.origin.y);
  
    // [cardView setNeedsDisplay];
}

- (void) alignCardsToViewSize:(CGSize)newSize
{
  NSLog(@"CardGameTableViewController::alignCardsToViewSize newSize %.1fx%.1f ", newSize.height, newSize.width);
  if (CGSizeEqualToSize(self.grid.size, newSize)) {
      NSLog(@"CardGameTableViewController::alignCardsToViewSize nothing to do");
      return; //nothing to do
  }
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
  [self alignCardsToViewSize:self.view.bounds.size];
  NSLog(@"CardGameTableViewController::viewDidLayoutSubviews %p", self);
}

- (void)traitCollectionDidChange:(UITraitCollection * _Nullable)previousTraitCollection
{
  [super traitCollectionDidChange: previousTraitCollection];
  NSLog(@"CardGameTableViewController::traitCollectionDidChange");
//  [self alignCardsToViewSize:self.view.bounds.size];
}

-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  NSLog(@"CardGameTableViewController::viewWillTransitionToSize size.w %0.1f size.h %0.1f", size.width, size.height);
  [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    NSLog(@"CardGameTableViewController::viewWillTransitionToSize animateAlongsideTransition completed");
  }];
//  [self alignCardsToViewSize:size];
}

-(void) viewDidLoad
{
  [super viewDidLoad];
  self.view.clipsToBounds = NO;
  NSLog(@"CardGameTableViewController::viewDidLoad ");
  //  [self alignCardsToViewSize:self.view.bounds.size];
  
}
-(void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  NSLog(@"CardGameTableViewController::viewDidAppear animated=%d", animated);
//  [self alignCardsToViewSize:self.view.bounds.size];
  
}

-(void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  NSLog(@"CardGameTableViewController::viewWillAppear");
}
@end

NS_ASSUME_NONNULL_END
