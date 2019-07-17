//
//  LLPViewController.m
//  LLMPay
//
//  Created by LLPayiOSDev on 11/08/2018.
//  Copyright (c) 2018 LianLian Pay. All rights reserved.
//

#import "LLPViewController.h"
#import <LLMPay/LLMPay.h>
#import <LLMPay/LLEBankPay.h>

@interface LLPViewController ()

@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UILabel *version;

@end

@implementation LLPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"version = %@", [LLMPay getSDKVersion]);
}

- (IBAction)PayAction:(UIButton *)sender {
    [[LLMPay sharedSdk] payApply:self.field.text
                        complete:^(LLMPayResult result, NSDictionary *dic) {
                             [self alertWithMsg:dic[@"ret_msg"]];
                        }];
}

- (IBAction)signAction:(UIButton *)sender {
    [[LLMPay sharedSdk] signApply:self.field.text
                         complete:^(LLMPayResult result, NSDictionary *dic) {
                             [self alertWithMsg:dic[@"ret_msg"]];
                         }];
}

- (IBAction)bankPay:(id)sender {
    [[LLEBankPay sharedSDK] llEBankPayWithUrl:self.field.text
                                     complete:^(LLPayResult result, NSDictionary *dic) {
                                         [self alertWithMsg:dic[@"ret_msg"]];
                                     }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.field resignFirstResponder];
}

- (void)alertWithMsg:(NSString *)msg {
    UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
