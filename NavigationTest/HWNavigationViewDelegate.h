//
//  HWNavigationViewDelegate.h
//  DuDuChat
//
//  Created by HandWin on 15/3/5.
//  Copyright (c) 2015年 PalmWin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HWNavigationViewDelegate : NSObject<UINavigationControllerDelegate>
@property (weak, readonly, nonatomic) UIPanGestureRecognizer *panRecognizer;
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;
@end
