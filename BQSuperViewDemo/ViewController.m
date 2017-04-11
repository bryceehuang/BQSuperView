//
//  ViewController.m
//  BQSuperViewDemo
//
//  Created by huangbq on 2017/4/4.
//  Copyright © 2017年 huangbq. All rights reserved.
//

#import "ViewController.h"
#import "BQSuperView.h"

#import "ProgressHUD.h"

@interface ViewController () <BQSuperViewDelegate>
{
    BOOL _superViewIsShowing;
}


@property (nonatomic, strong) BQSuperView *superView;

@property (nonatomic, strong) UIButton *indicatorButton;

@property (nonatomic, strong) UITextField *textfield;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.textfield];
    [self.view addSubview:self.indicatorButton];
    
    // show super view
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.superView show];
}








#pragma mark -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - BQSuperViewDelegate
- (void)superViewClicked:(BQSuperView *)superView {
    NSLog(@"superViewClicked");
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"test" message:@"test message" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];

}

#pragma mark - Getters

- (UITextField *)textfield {
    if (_textfield == nil) {
        _textfield = [[UITextField alloc] initWithFrame:CGRectMake(30, 40, 200, 44)];
        _textfield.placeholder = @"call the keyboard";
        _textfield.borderStyle = UITextBorderStyleRoundedRect;
        [_textfield resignFirstResponder];
    }
    return _textfield;
}




- (BQSuperView *)superView {
    
    if (_superView == nil) {
        CGRect frame = CGRectMake(
                                  ([UIScreen mainScreen].bounds.size.width - 80)/2 ,
                                  ([UIScreen mainScreen].bounds.size.height - 80)/2, 80, 80);
        _superView = [[BQSuperView alloc] initWithFrame:frame delegate:self];
        [_superView setTitle:@"Click" forState:UIControlStateNormal];
    }
    return _superView;
}

- (UIButton *)indicatorButton {
    if (_indicatorButton == nil) {
        _indicatorButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 130, 100, 40)];
        _indicatorButton.backgroundColor = [UIColor yellowColor];
        [_indicatorButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_indicatorButton setTitle:@"indicator" forState:UIControlStateNormal];
        [_indicatorButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _indicatorButton;
}

- (void)buttonClick:(UIButton *)sender {
    
    [ProgressHUD show:@"loading..."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ProgressHUD dismiss];
    });
}






@end
