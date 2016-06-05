//
//  EditNoteViewController.h
//  zhiwenNotificaition
//
//  Created by boyancao on 16/6/4.
//  Copyright © 2016年 boyancao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditNoteViewController : UIViewController

@property (nonatomic, copy) void (^finishWrite)(NSString *,NSString *);

@property (nonatomic ,strong) UITextView * textView;

-(instancetype)initWithContent:(NSString *)content;

@end
