//
//  ViewController.m
//  NSOperationDemo
//
//  Created by 王辉平 on 16/8/10.
//  Copyright © 2016年 王辉平. All rights reserved.
//

#import "ViewController.h"
#import "HPOperation.h"

@interface ViewController ()
{
    UIImageView* showImg1;
    UIImageView* showImg2;
    UIImageView* showImg3;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.监听属性变化  operation本身是不会创建线程的,能够执行main函数的task是在主线程执行
//    HPOperation* opera = [[HPOperation alloc]init];
//    [opera addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:nil];
//    [opera start];
//    NSLog(@"主线程tread==%@",[NSThread currentThread]);
    //2.执行一个task  在subClass中复写main
//    HPOperation* opera = [[HPOperation alloc]init];
//    [opera start];

    //3. NSBlockOperation 的操作  增加一个执行block 对应增加一条线程
    //只要NSBlockOperation封装的操作数 > 1,就会异步执行操作 开启多个线程
//    NSBlockOperation* blockOperation = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"tread--1==%@",[NSThread currentThread]);
//    }];
//    //添加操作
//    [blockOperation addExecutionBlock:^{
//        NSLog(@"tread--2==%@",[NSThread currentThread]);
//    }];
//    [blockOperation addExecutionBlock:^{
//        NSLog(@"tread--3==%@",[NSThread currentThread]);
//    }];
//    [blockOperation addExecutionBlock:^{
//        NSLog(@"tread--4==%@",[NSThread currentThread]);
//    }];
//    [blockOperation start];
    
    //4. NSInvocationOperation
//    NSInvocationOperation* opre = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(handleOperation) object:nil];
//    [opre start];
    
    //5. NSOperationQueue
    NSInvocationOperation* operation1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(handleOperation) object:nil];
    NSBlockOperation* operation2 = [NSBlockOperation blockOperationWithBlock:^{
         NSLog(@"operation2==tread--1==%@",[NSThread currentThread]);
    }];
    [operation2 addExecutionBlock:^{
        for(int i = 0;i<5;i++){
            NSLog(@"operation2==tread--2==%@==%d",[NSThread currentThread],i);
        }
    }];
//    HPOperation* operation3 = [[HPOperation alloc]init];
    NSBlockOperation* operation3 = [NSBlockOperation blockOperationWithBlock:^{
//        [operation2 waitUntilFinished]; //阻塞当前线程 等operation2执行完后 才执行下面的  与依赖类似
        NSLog(@"operation3==tread--1==%@",[NSThread currentThread]);
    }];
    //系统自动从queue中取出任务 加载到相应线程
    //queue对添加进去的operation进行管理、创建线程等；添加到queue里的operation，queue默认会调用operation的start函数来执行任务，而start函数默认又是调用main函数的
    NSOperationQueue* queue = [[NSOperationQueue alloc]init];
    [operation3 addDependency:operation2];//依赖关系
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
    [queue addOperationWithBlock:^{
        NSLog(@"operation4==tread--1==%@",[NSThread currentThread]);
    }];
    [queue waitUntilAllOperationsAreFinished];// 阻塞当前线程，等待queue的所有操作执行完毕
    NSLog(@"queue==%@",queue);
    
    //6. 下载异步图片
    showImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 200, 200)];
    [self.view addSubview:showImg1];
    
    showImg2 = [[UIImageView alloc]initWithFrame:CGRectMake(220, 20, 50, 50)];
    [self.view addSubview:showImg2];
    
    showImg3 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 250, 200, 200)];
    [self.view addSubview:showImg3];
    
    /*NSOperationQueue* queue = [[NSOperationQueue alloc]init];
    __weak typeof(self) weakSelf = self;
    [queue addOperationWithBlock:^{
        //下载图片1
        NSString* urlStr = @"http://hiphotos.baidu.com/%D0%DC%C4%AA%C4%AA%B5%C4%CD%B7/pic/item/bb454427ba287a364d088d06.jpg";
        UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
        [weakSelf performSelectorOnMainThread:@selector(updateUIImg1:) withObject:img waitUntilDone:YES];
//        showImg1.image = img; //在主线程设置 才能够立刻显示。在异步线程可能不能显示出来
    }];
    [queue addOperationWithBlock:^{
        //下载图片2
        NSString* urlStr = @"http://img3.redocn.com/tupian/20150403/shengdanjielvsesongzhibiankuangshiliangbeijing_4038920.jpg";
        UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
        [weakSelf performSelectorOnMainThread:@selector(updateUIImg2:) withObject:img waitUntilDone:YES];
    }];
    [queue addOperationWithBlock:^{
        //下载图片3
        NSString* urlStr = @"http://image.tianjimedia.com/uploadImages/2012/233/25/I8I09B0R83J2.jpg";
        UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
        [weakSelf performSelectorOnMainThread:@selector(updateUIImg3:) withObject:img waitUntilDone:YES];
    }];*/
}

-(void)updateUIImg1:(UIImage*)img1
{
    showImg1.image = img1;
}
-(void)updateUIImg2:(UIImage*)img2
{
    showImg2.image = img2;
}
-(void)updateUIImg3:(UIImage*)img3
{
    showImg3.image = img3;
}
-(void)handleOperation
{
    NSLog(@"执行NSInvocationOperation===curThread==%@",[NSThread currentThread]);
}
//KVO 监听属性isFinished变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"KeyPath==%@",keyPath);
}

@end
