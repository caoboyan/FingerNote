//
//  ViewController.m
//  zhiwenNotificaition
//
//  Created by boyancao on 16/6/4.
//  Copyright © 2016年 boyancao. All rights reserved.
//

#import "ViewController.h"
#import "NoteDetailModel.h"
#import "NoteDetailCell.h"
#import "EditNoteViewController.h"
#import <FMDB/FMDatabase.h>

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataList;

@end

@implementation ViewController

-(NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createDataBase];
    
    [self setupNavigationBar];
    
    [self customTableView];

    [self searchData];
}


- (void)createDataBase{
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:@"note.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    if (![db open]) {
        return;
    }
   BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS note (note_id text PRIMARY KEY, content text NOT NULL, time text NOT NULL);"];
    if (result) {
        NSLog(@"建表成功");
    }else{
        NSLog(@"建表失败");
    }
}

- (void)insertData:(NoteDetailModel *)model{
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:@"note.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    if (![db open]) {
        return;
    }
    NSString * insertSQL = @"INSERT INTO note VALUES (?, ?, ?)";
    [db executeUpdate:insertSQL,model.time,model.content,model.time];
    [db close];
}

- (void)searchData{
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:@"note.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    if (![db open]) {
        return;
    }
    FMResultSet *rs = [db executeQuery:@"select * from note"];
    while ([rs next]) {
        NoteDetailModel * model = [[NoteDetailModel alloc]init];
        model.note_id = [rs stringForColumn:@"note_id"];
        model.content =  [rs stringForColumn:@"content"];
        model.time = [rs stringForColumn:@"time"];
        [self.dataList addObject:model];
    }
    
    [db close];
    
    [self.tableView reloadData];
}

- (void)deleteNote:(NoteDetailModel *)model{
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:@"note.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    if (![db open]) {
        return;
    }
    NSString * deleteSQL = [NSString stringWithFormat:@"DELETE FROM  note WHERE  time = ?"];
    [db executeUpdate:deleteSQL,model.time];
    [db close];
}

- (void)updateNote:(NoteDetailModel *)model beforeTime:(NSString *)beforeTime{
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:@"note.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    [db open];
    if (![db open]) {
        return;
    }
    NSString * updateSQL = [NSString stringWithFormat:@"UPDATE note SET content = ? WHERE time = ?"];
    [db executeUpdate:updateSQL,model.content,beforeTime];
    [db close];
}

- (void)customTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height )];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[NoteDetailCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteDetailCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[NoteDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NoteDetailModel * model = [self.dataList objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteDetailModel * model = [self.dataList objectAtIndex:indexPath.row];
    EditNoteViewController * controller = [[EditNoteViewController alloc]initWithContent:model.content];
    controller.finishWrite = ^(NSString * content,NSString * time){
        NSString * beforeTime = model.time;
        model.content = content;
        model.time = time;
        if ([content isEqualToString:@""]) {
            [self deleteNote:model];
        }else{
            [self updateNote:model beforeTime:beforeTime];
        }
        [tableView reloadData];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 从数据源中删除
    [self deleteNote:[self.dataList objectAtIndex:indexPath.row]];
    [self.dataList removeObjectAtIndex:indexPath.row];

    // 从列表中删除
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteDetailModel * model = [self.dataList objectAtIndex:indexPath.row];
    return [NoteDetailCell heightForCell:model];
}

- (void)setupNavigationBar
{


    self.navigationItem.title = @"懒人笔记";
    
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"新建", @"")
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(createTask)];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [saveItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:saveItem, nil];
    
}

- (void)createTask{
    EditNoteViewController * controller = [[EditNoteViewController alloc]initWithContent:@""];
    controller.finishWrite = ^(NSString * content,NSString * localTime){
        NoteDetailModel * model = [[NoteDetailModel alloc]init];
        model.content = content;
        model.time = localTime;
        [self insertData:model];
        [self.dataList addObject:model];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:controller animated:YES];
}


@end
