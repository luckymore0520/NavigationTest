//
//  HWNavigationViewDelegate.m
//  DuDuChat
//
//  Created by HandWin on 15/3/5.
//  Copyright (c) 2015年 PalmWin. All rights reserved.
//

#import "HWNavigationViewDelegate.h"
#import "SSWDirectionalPanGestureRecognizer.h"
#import "HWFlipTransitioning.h"
@interface HWNavigationViewDelegate()
@property (nonatomic,strong) HWFlipTransitioning            *flipTransitioning;
@property (weak, readwrite, nonatomic) UIPanGestureRecognizer *panRecognizer;
@property (weak, nonatomic)  UINavigationController *navigationController;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactionController;
/// A Boolean value that indicates whether the navigation controller is currently animating a push/pop operation.
@property (nonatomic) BOOL duringAnimation;
@property (nonatomic) BOOL withInteraction;
@end
@implementation HWNavigationViewDelegate
- (void)dealloc
{
    [_panRecognizer removeTarget:self action:@selector(pan:)];
    [_navigationController.view removeGestureRecognizer:_panRecognizer];
}

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    NSCParameterAssert(!!navigationController);
    
    self = [super init];
    if (self) {
        _navigationController = navigationController;
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [self commonInit];
}

- (void)commonInit
{
    SSWDirectionalPanGestureRecognizer *panRecognizer = [[SSWDirectionalPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    panRecognizer.direction = SSWPanDirectionRight;
    panRecognizer.maximumNumberOfTouches = 1;
    [_navigationController.view addGestureRecognizer:panRecognizer];
    _panRecognizer = panRecognizer;
    _flipTransitioning = [[HWFlipTransitioning alloc] init];
    _flipTransitioning.navigationController = self.navigationController;
    
}
//控制界面切换动画，返回nil使用默认滑动动画
#pragma mark - TransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop && _withInteraction) {
        return self.flipTransitioning;
    }
    return nil;
}

#pragma mark - UIPanGestureRecognizer

- (void)pan:(UIPanGestureRecognizer*)recognizer
{
    UIView *view = self.navigationController.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (self.navigationController.viewControllers.count > 1 && !self.duringAnimation) {
            //滑动区域限制在左半2/5处
            if ([recognizer locationInView:view].x > [[UIScreen mainScreen]bounds].size.width / 5 * 2) {
                return;
            }
            self.interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
            self.interactionController.completionCurve = UIViewAnimationCurveEaseOut;
            _withInteraction = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:view];
        // Cumulative translation.x can be less than zero because user can pan slightly to the right and then back to the left.
        CGFloat d = translation.x > 0 ? translation.x / CGRectGetWidth(view.bounds) : 0;
        [self.interactionController updateInteractiveTransition:d];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([recognizer velocityInView:view].x > 0) {
            [self.interactionController finishInteractiveTransition];
            _withInteraction = NO;

        } else {

            [self cancelTransition];
        }
        self.interactionController = nil;
    }
}

- (void)cancelTransition
{
    [self.interactionController cancelInteractiveTransition];
    _withInteraction = NO;
    // When the transition is cancelled, `navigationController:didShowViewController:animated:` isn't called, so we have to maintain `duringAnimation`'s state here too.
    self.duringAnimation = NO;
}


#pragma mark - UIGestureRecognizerDelegate
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactionController;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (animated) {
        self.duringAnimation = YES;
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.duringAnimation = NO;
    
    if (navigationController.viewControllers.count <= 1) {
        self.panRecognizer.enabled = NO;
    }
    else {
        
        self.panRecognizer.enabled = YES;
    }
}
@end
