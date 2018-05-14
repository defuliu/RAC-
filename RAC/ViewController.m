//
//  ViewController.m
//  RAC
//
//  Created by 刘德福 on 2018/5/14.
//  Copyright © 2018年 ZGW. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveObjC.h"
#import "Person.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, strong)Person *p;
@property (weak, nonatomic) IBOutlet UITextField *testTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    _p = [Person new];
    NSLog(@"p=======:%@",_p.name);

    _p.name = [NSString stringWithFormat:@"Mac %d5",arc4random_uniform(10000)];
    //RAC 入门写法
    //创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"test Project");
        //发送信号
        //        NSString *s = [NSString stringWithFormat:@"Mac%u",arc4random()];
             [subscriber sendNext:@"this is test"];
        return nil;
    }];
    
    //订阅信号
    [signal subscribeNext:^(id  _Nullable x) {
        //x  信号的内容
        NSLog(@"%@",x);
    }];
    
    //合并写法
    [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送信号
        [subscriber sendNext:@"This is RAC"];
        return nil;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"x");
    }] ;
    
}

-(void)demo4{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (IBAction)btnAction:(UIButton *)sender {
    [[self.button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

-(void)demo2 {
    
    @weakify(self);
    [[self.testTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        
        NSLog(@"%@",x);
        @strongify(self);
        self.testTextField.text = @"Hello";
    }];
}
    
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    

}



@end
