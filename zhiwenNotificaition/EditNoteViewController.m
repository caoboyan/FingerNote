//
//  EditNoteViewController.m
//  zhiwenNotificaition
//
//  Created by boyancao on 16/6/4.
//  Copyright © 2016年 boyancao. All rights reserved.
//

#import "EditNoteViewController.h"

@interface EditNoteViewController ()



@end

@implementation EditNoteViewController

-(instancetype)initWithContent:(NSString *)content{
    self=  [super init];
    if (self) {
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 500)];
        self.textView.text = content;
        [self.view addSubview:self.textView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建笔记";
    [self addRightSave];
    [self addLeftBack];
    [self.textView becomeFirstResponder];
}

- (void)addLeftBack{
    UIButton* backButton= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont systemFontOfSize:13];
    backButton.titleLabel.textColor = [UIColor whiteColor];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(5, -35, 0, 0)];
    backButton.titleLabel.textAlignment = UITextAlignmentLeft;
    [backButton addTarget:self action:@selector(doClickBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)addRightSave{
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"保存", @"")
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(save)];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [saveItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
      self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:saveItem, nil];
    

}

- (void)doClickBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save{
    if (![self.textView.text isEqualToString:@""]) {
        if (self.finishWrite) {
            self.finishWrite(self.textView.text,[self getLocalTime]);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)getLocalTime{
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * na = [df stringFromDate:currentDate];
    
    return na;
}



@end
