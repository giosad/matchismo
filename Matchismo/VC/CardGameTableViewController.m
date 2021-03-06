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
@property (strong, nonatomic) UIDynamicAnimator* animator;
@property (nonatomic) CGPoint snapPoint;
@property (nonatomic) BOOL stacked;
@end
@implementation CardGameTableViewController


#pragma mark - Lazy initializers


-(UIDynamicAnimator *)animator
{
  if (!_animator) {
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
  }
  return _animator;
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


- (NSMutableArray<CardView*> *)cardViewsInternal
{
  if (!_cardViewsInternal) {
    _cardViewsInternal = [[NSMutableArray<CardView*> alloc] init];
  }
  return _cardViewsInternal;
}


#pragma mark - CardView management


- (NSUInteger)maxNumOfCardViews
{
  return 20;
}

- (void) updateCardView:(CardView*)cardView chosen:(BOOL)chosen;
{
  [self.viewAnimationQueue transitionWithView:cardView
                                     duration:self.cardChooseAnimationTime
                                      options:self.cardChooseAnimation
                          animationConditions:^BOOL{
                            return chosen != cardView.chosen;
                          }
                                   animations:^{
                                     cardView.chosen = !cardView.chosen;
                                   }
                                   completion:NULL];
  
}




- (void) addCardView:(CardView*)cardView
{
  [self.cardViewsInternal addObject:cardView];
  [self updateGridSizeIfNeeded];

  CGRect fr = CGRectMake(-300, -300, self.grid.cellSize.width, self.grid.cellSize.height);
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
  self.stacked = NO;
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


- (void) positionCardView:(CardView *)cardView atPosition:(NSUInteger)position
{
  [self.viewAnimationQueue animateWithDuration:0.2f
                                         delay:0.0
                                       options:UIViewAnimationOptionCurveEaseInOut
                                    animations:^{
                                      [self updateGridSizeIfNeeded];
                                      NSUInteger row = position / self.grid.columnCount;
                                      NSUInteger col = position % self.grid.columnCount;
                                      cardView.frame = [self.grid frameOfCellAtRow:row inColumn:col];
                                    }
                                    completion:^(BOOL finished) {
                                      //redraw card, since its image may be garbled due to card size changes
                                      [cardView setNeedsDisplay]; //Todo(gena) consider moving to animateWithDuration implementation
                                    }];
}


- (void) updateGridSizeIfNeeded
{
  CGSize newSize = CGRectStandardize(self.view.bounds).size;
  if (CGSizeEqualToSize(self.grid.size, newSize)) {
    return;
  }

  self.grid.cellAspectRatio = 0.7;
  self.grid.minimumNumberOfCells = 20;
  self.grid.size = newSize;
  NSLog(@"grid.resolved %d", self.grid.inputsAreValid);
  NSLog(@"grid: %@", [self.grid description]);
}


- (void) alignCardsToViewSize
{
  NSLog(@"CardGameTableViewController::alignCardsToViewSize realigning cards...");
  self.stacked = NO; //since reset layout, we exit out the "stacked" mode
  [self updateGridSizeIfNeeded];
  
  [UIView animateWithDuration:0.6f
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     int position = 0;
                     for (CardView *cardView in self.cardViewsInternal) {
                       NSUInteger row = position / self.grid.columnCount;
                       NSUInteger col = position % self.grid.columnCount;
                       cardView.frame = [self.grid frameOfCellAtRow:row inColumn:col];
                       position++;
                     }
                   }
                   completion:^(BOOL finished) {
                     for (CardView *cardView in self.cardViewsInternal) {
                       //redraw card, since its image may be garbled due to card size changes
                       [cardView setNeedsDisplay];
                     }
                     
                   }];
}


#pragma mark - Gestures recognizer callbacks

- (void) handlePinch:(UIPinchGestureRecognizer *)sender
{
  if (sender.state == UIGestureRecognizerStateEnded)
  {
    NSLog(@"pinch scale %f", sender.scale);
    if (sender.scale < 1) {

      self.stacked = YES;
      NSArray<CardView*> *cardViews = [self.cardViewsInternal copy];
      __weak CardGameTableViewController *weakSelf = self;
      [self.viewAnimationQueue animateWithDuration:0.6
                                             delay:0.0
                                           options:UIViewAnimationOptionCurveEaseIn
                                        animations:^{

                                          for (CardView *cardView in cardViews) {
                                            CGFloat cx = self.view.bounds.size.width/2 - cardView.frame.size.width/2;
                                            CGFloat cy = self.view.bounds.size.height/2 - cardView.frame.size.height/2;
                                            cardView.frame = CGRectMake(cx, cy, cardView.frame.size.width, cardView.frame.size.height);
                                          }
                                        }
                                        completion:^(BOOL finished) {
                                          int i = 0;
                                          for (CardView *cardView in cardViews) {
                                            UISnapBehavior *ab = [[UISnapBehavior alloc] initWithItem:cardView snapToPoint:cardView.center];
                                            ab.damping = 0.5 - 0.02*(++i);
                                            [weakSelf.animator addBehavior:ab];
                                            weakSelf.snapPoint = cardView.center;
                                          }
                                          
                                        }];
    } else {
      [self alignCardsToViewSize];
      self.stacked = NO;
      [self.animator removeAllBehaviors];
    }
  }
}


- (void) handlePan:(UIPanGestureRecognizer *)sender
{
  if (!self.stacked) {
    return;
  }
  
  if (sender.state == UIGestureRecognizerStateChanged)
  {
    CGPoint p = [sender translationInView:self.view];
    for (UIDynamicBehavior *beh in self.animator.behaviors) {
      UISnapBehavior *sbeh = (UISnapBehavior *)beh;
      //update behavior snapPoint
      CGPoint sp = self.snapPoint;
      sp.x += p.x;
      sp.y += p.y;
      sbeh.snapPoint = sp;
    }
  }
  
  if (sender.state == UIGestureRecognizerStateEnded) {
    CGPoint p = [sender translationInView:self.view];
    //update self.snapPoint
    CGPoint sp = self.snapPoint;
    sp.x += p.x;
    sp.y += p.y;
    self.snapPoint = sp;
  }

}


- (void)handleCardTap:(UITapGestureRecognizer *)sender
{
  if (sender.state == UIGestureRecognizerStateEnded)
  {
    if (!self.stacked) {
      self.cardTapEventHandler((CardView*)sender.view);
    }
  }
}


#pragma mark - View layout change callbacks


-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    NSLog(@"CardGameTableViewController::viewWillTransitionToSize self.bounds.size.w %0.1f size.h %0.1f", self.view.bounds.size.width, self.view.bounds.size.height);
    [self alignCardsToViewSize];
  } completion:nil];
}

-(void) viewDidLoad
{
  [super viewDidLoad];
  UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
  [self.view addGestureRecognizer:pinchRecognizer];
  UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
  [self.view addGestureRecognizer:panRecognizer];
}

@end

NS_ASSUME_NONNULL_END
