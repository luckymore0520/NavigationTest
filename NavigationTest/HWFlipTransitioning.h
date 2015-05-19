//
//  HWFlipTransitioning.h
//  DuDuChat
//
//  Created by HandWin on 15/3/13.
//  Copyright (c) 2015年 PalmWin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HWFlipTransitioning : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic,weak)  UINavigationController* navigationController;
@end
