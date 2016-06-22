//
//  ViewController.m
//  Slide_Button_Demo
//
//  Created by bioongroup on 15/11/9.
//  Copyright © 2015年 ylk. All rights reserved.
//

#import "ViewController.h"
#import "model_View.h"
#import "model_button.h"

@interface ViewController (){
    NSMutableArray *_place_array;
    NSMutableArray *_button_array;
    model_button *_currentButton;//当前的按钮
    model_View   *_currentView;
    CGPoint point;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self create_place];
    [self create_button];
}

//create_place
-(void)create_place{
    _place_array = [[NSMutableArray alloc]init];
    for(int i = 0 ; i<20 ;i++){
        model_View *view = [[model_View alloc]initWithFrame:CGRectMake((self.view.frame.size.width/3)*(i%3)+15, 90*(i/3)+35, 100, 60)];
        view.orSelect = YES;//设置这个位置是否可以用
        view.backgroundColor = [UIColor redColor];
        view.tag = i;
        [_place_array addObject:view];
    }
}
//create_button
-(void)create_button{
    _button_array = [[NSMutableArray alloc]init];//初始化放按钮的数组
    for(model_View *view in _place_array){
        model_button *btn = [model_button buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[NSString stringWithFormat:@"单身狗%ld号",(long)view.tag] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 7;
        btn.backgroundColor = [UIColor blackColor];
        btn.frame = view.frame;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        btn.orSelect = YES;//设置btn是否可选
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
        [_button_array addObject:btn];
        [self.view addSubview:btn];
    }
}
-(void)click:(model_button*)sender{
    _currentButton.orSelect = YES;
    _currentButton = sender;
    _currentButton.orSelect = NO;//设置当前的按钮不可用
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer* )gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            //开始
            NSLog(@"开始");
        }break;
        case UIGestureRecognizerStateChanged:{
            //移动
            point = [gesture locationInView:self.view];
            _currentButton.center = point;
            [self judgmentInterect];
        }break;
        case UIGestureRecognizerStateEnded:{
            //完成
            [UIView animateWithDuration:0.3 animations:^{
                _currentButton.frame = _currentView.frame;
            }];
            //进行删除插入
            [_button_array removeObject:_currentButton];
            [_button_array insertObject:_currentButton atIndex:_currentView.tag];
        }break;
        default:
            break;
    }
}

-(void)judgmentInterect{
    for(model_View *view in _place_array){
        if(CGRectContainsPoint(view.frame, point)&&view.orSelect){
            _currentView.orSelect = YES;
            _currentView = view;
            _currentView.orSelect = NO;//设置当前这个位置不可以用
            [self refresh];
        }}
}

-(void)refresh{//刷新位置
    [UIView animateWithDuration:0.3 animations:^{
        for(model_button *btn in _button_array){
            if(btn.orSelect){
                for(model_View *view in _place_array){
                    if(view.orSelect){
                        btn.frame = view.frame;
                        view.orSelect = NO;
                        break;
                    }
                }
            }
        }for(model_View *view in _place_array){view.orSelect = YES;}
        _currentView.orSelect = NO;
    }];
}
//不支持多点触控
- (BOOL) isMultipleTouchEnabled
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
