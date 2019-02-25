//
//  ViewController.m
//  FMDBDataDemo
//
//  Created by MacOS on 2019/2/25.
//  Copyright © 2019 MacOS. All rights reserved.
//

#import "ViewController.h"
#import <FMDB.h>

@interface ViewController ()

@property(nonatomic,strong)FMDatabase *db;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //1.获得数据库文件的路径
   NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
   NSString *fileName=[doc stringByAppendingPathComponent:@"student.sqlite"];

    NSLog(@"--file---%@-----",doc);
   //2.获得数据库
   FMDatabase *db=[FMDatabase databaseWithPath:fileName];

   //3.打开数据库
   if ([db open]) {
             //4.创表
             BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
             if (result) {
                 
              }else{
                   NSLog(@"创表失败");
                }
    }
    self.db=db;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
     [self delete];
     [self insert];
     [self query];
}

 //插入数据
 -(void)insert {
     for (int i = 0; i<10; i++) {
             NSString *name = [NSString stringWithFormat:@"jack-%d", arc4random_uniform(100)];
             // executeUpdate : 不确定的参数用?来占位
             [self.db executeUpdate:@"INSERT INTO t_student (name, age) VALUES (?, ?);", name, @(arc4random_uniform(40))];
             //        [self.db executeUpdate:@"INSERT INTO t_student (name, age) VALUES (?, ?);" withArgumentsInArray:@[name, @(arc4random_uniform(40))]];
    
             // executeUpdateWithFormat : 不确定的参数用%@、%d等来占位
             //        [self.db executeUpdateWithFormat:@"INSERT INTO t_student (name, age) VALUES (%@, %d);", name, arc4random_uniform(40)];
         }
}

 //删除数据
 -(void)delete {
     //    [self.db executeUpdate:@"DELETE FROM t_student;"];
     [self.db executeUpdate:@"DROP TABLE IF EXISTS t_student;"];
     [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
}

 //查询
 - (void)query {
     // 1.执行查询语句
     FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_student"];

     // 2.遍历结果
     while ([resultSet next]) {
             int ID = [resultSet intForColumn:@"id"];
             NSString *name = [resultSet stringForColumn:@"name"];
             int age = [resultSet intForColumn:@"age"];
             NSLog(@"%d %@ %d", ID, name, age);
         }
}

@end
