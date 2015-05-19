//
//  ViewController.m
//  NavigationTest
//
//  Created by luck-mac on 15/5/19.
//  Copyright (c) 2015年 com.nju.luckymore. All rights reserved.
//

#import "ViewController.h"
#import "HWNavigationViewDelegate.h"
@interface ViewController ()
@property (nonatomic,strong) HWNavigationViewDelegate* navigationDelegate;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.title isEqualToString:@"1"]) {
        self.navigationController.delegate = self.navigationDelegate;
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (HWNavigationViewDelegate *)navigationDelegate {
    if (!_navigationDelegate) {
        _navigationDelegate = [[HWNavigationViewDelegate alloc] initWithNavigationController:self.navigationController];
    }
    return _navigationDelegate;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"willAppear %@",self.title );
    
    [self.navigationController setNavigationBarHidden:[self.title isEqualToString:@"3"]];
    NSLog(@"currentViewController %@",self.navigationController.topViewController.title);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"willDisappear %@",self.title );
    [self.navigationController setNavigationBarHidden:![self.title isEqualToString:@"3"]];
    NSLog(@"currentViewController %@",self.navigationController.topViewController.title);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear %@",self.title );
    NSLog(@"currentViewController %@",self.navigationController.topViewController.title);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear %@",self.title );
    NSLog(@"currentViewController %@",self.navigationController.topViewController.title);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
