//
//  LPDataBaseutil.m
//  FreeBao
//
//  Created by freebao on 13-5-5.
//
//

#import "LPDataBaseutil.h"
#import "FMDatabaseAdditions.h"

//创建一个全局的数据库对象 不能再.h中声明这个属性
//static FMDatabase *db = nil;
static FMDatabaseQueue *dbQueen = nil;

@implementation LPDataBaseutil

//返回数据库在沙盒中的路径
+(NSString *)dbFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"dataNew.sqlite"];
    
    return filePath;
}

//在指定路径下创建数据库
+(void)createDB
{
//    db = [FMDatabase databaseWithPath:[self dbFilePath]];
    dbQueen = [FMDatabaseQueue databaseQueueWithPath:[self dbFilePath]];
}

//创建表
-(void)createTableNotice:(FMDatabase*)db
{
    if (![db tableExists:@"notice"]) {
        
        [db executeUpdate:@"create table notice (notice_id integer primary key autoincrement , message text ,type integer, isread text, nickname text,facepath text,createtime text,userid text)"];
    }
}

//-(void)createTableMessage:(FMDatabase *)db {
//    if(![db tableExists:[NSString stringWithFormat:@"%@MessageLast", userId]]) {
//        NSString *createMessageSql = @"CREATE TABLE IF NOT EXISTS MessageLast (ID INTEGER PRIMARY KEY,FROM_USERID TEXT, NICK_NAME TEXT,IS_SELF TEXT NOT NULL DEFAULT 0,DATE TEXT NOT NULL DEFAULT 0,FACE_PATH TEXT NOT NULL DEFAULT 0 ,VOICE_TIME TEXT NOT NULL DEFAULT 0,FAIL TEXT NOT NULL DEFAULT 0,BODY TEXT NOT NULL DEFAULT 0, TYPE TEXT NOT NULL DEFAULT 0,LANGUAGE TEXT NOT NULL DEFAULT 0,POST_TYPE TEXT NOT NULL DEFAULT 0, B_DATA DATA);";
//        
//        [db executeUpdate:createMessageSql];
//    }
//}

-(void)createTableBadge:(FMDatabase *)db {
    if (![db tableExists:@"badge"]) {
        NSString *createBadgeSql = @"CREATE TABLE IF NOT EXISTS badge (ID INTEGER PRIMARY KEY,atValue TEXT,commentValue TEXT,messageValue TEXT ,noticeValue TEXT);";
        
        [db executeUpdate:createBadgeSql];
    }
}

-(void)createTableLocalWeibo:(FMDatabase*)db {
    if (![db tableExists:@"weibo"]) {
        NSString *createMessageSql = @"CREATE TABLE IF NOT EXISTS weibo (ID INTEGER PRIMARY KEY,share_type TEXT,file_type TEXT,media_body TEXT ,song_url TEXT,allow_comment TEXT,allow_share TEXT,content_body TEXT,circle_id TEXT,media_type TEXT,location TEXT, latitude TEXT, longgitude TEXT);";
        
        [db executeUpdate:createMessageSql];
    }
}

//插入微博到表中
+(NSInteger)saveWeibo:(NSString *)shareType FileType:(NSString *)fileType MediaBody:(NSString *)mediaBody SongUrl:(NSString *)songUrl AllowComment:(NSString *)allowComment AllowShare:(NSString *)allowShare ContentBody:(NSString *)contentBody CircleId:(NSString *)circleId MediaType:(NSString *)mediaType Location:(NSString *)location Latitude:(NSString *)latitude Longgitude:(NSString *)longgitude{
    if (!dbQueen)
    {
        [self createDB];
    }
    __block int count = 0;
    
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if(![db tableExists:@"weibo"])
            {
                NSString *createMessageSql = @"CREATE TABLE IF NOT EXISTS weibo (ID INTEGER PRIMARY KEY,share_type TEXT,file_type TEXT,media_body TEXT ,song_url TEXT,allow_comment TEXT,allow_share TEXT,content_body TEXT,circle_id TEXT,media_type TEXT,location TEXT, latitude TEXT, longgitude TEXT);";
                
                [db executeUpdate:createMessageSql];
            }
            
            count = [db executeUpdate:@"insert into weibo (share_type,file_type,media_body,song_url,allow_comment,allow_share,content_body,circle_id,media_type,location,latitude,longgitude ) values ( ? , ?, ? ,? ,? ,? ,? ,? ,? ,? ,? ,?)",shareType, fileType,
                     mediaBody, songUrl, allowComment, allowShare, contentBody, circleId, mediaType, location, latitude, longgitude];
        }
        [db close];
    }];
    return count;
}

+(NSInteger)saveOrUpdateBadge:(NSString *)atValue CommentValue:(NSString *)commentValue MessageValue:(NSString *)messageValue NoticeValue:(NSString *)noticeValue {
    if (!dbQueen)
    {
        [self createDB];
    }
    __block int count = 0;

    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if(![db tableExists:@"badge"])
            {
                NSString *createBadgeSql = @"CREATE TABLE IF NOT EXISTS badge (ID INTEGER PRIMARY KEY,atValue TEXT,commentValue TEXT,messageValue TEXT ,noticeValue TEXT);";
                
                [db executeUpdate:createBadgeSql];
            }
            
            FMResultSet *resultSet = [db executeQuery:@"select * from badge"];
            if ([resultSet next]) {
                //有记录，更新数据
                NSString *preAtValue = [resultSet objectForColumnIndex:1];
                NSString *preCommentValue = [resultSet objectForColumnIndex:2];
                count = [db executeUpdate:@"update badge set atValue = ?, commentValue = ?, messageValue = ?, noticeValue = ? ",
                         [NSString stringWithFormat:@"%d", [atValue integerValue] + [preAtValue integerValue]] ,
                         [NSString stringWithFormat:@"%d", [commentValue integerValue] + [preCommentValue integerValue]],
                         messageValue ,
                         noticeValue];
            } else {
                //无记录，插入数据
                count = [db executeUpdate:@"insert into badge (atValue,commentValue,messageValue,noticeValue) values ( ? , ?, ? ,? )",atValue, commentValue, messageValue, noticeValue];
            }
            [resultSet close];
        }
        [db close];
    }];
    return count;
}

+(NSInteger)insertMessageLast:(NSString *)fromId nickName:(NSString *)nickname date:(NSString *)date face_path:(NSString *)facepath voicetime:(NSString *)voicetime body:(NSString *)body postType:(NSString *)postType isSelf:(NSString *)isSelf language:(NSString *)language fail:(NSString *)fail userId:(NSString *)userId bData:(NSData *)data{
    if (!dbQueen)
    {
        [self createDB];
    }
    
    __block int count = 0;
    [dbQueen inDatabase:^(FMDatabase *db){
        
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if(![db tableExists:[NSString stringWithFormat:@"%@MessageLast", userId]]) {
                NSString *createMessageSql = @"CREATE TABLE IF NOT EXISTS MessageLast (ID INTEGER PRIMARY KEY,FROM_USERID TEXT, NICK_NAME TEXT,IS_SELF TEXT NOT NULL DEFAULT 0,DATE TEXT NOT NULL DEFAULT 0,FACE_PATH TEXT NOT NULL DEFAULT 0 ,VOICE_TIME TEXT NOT NULL DEFAULT 0,FAIL TEXT NOT NULL DEFAULT 0,BODY TEXT NOT NULL DEFAULT 0,LANGUAGE TEXT NOT NULL DEFAULT 0,POST_TYPE TEXT NOT NULL DEFAULT 0, B_DATA DATA);";
                
                [db executeUpdate:createMessageSql];
            }
            count = [db executeUpdate:@"INSERT OR REPLACE INTO MessageLast (FROM_USERID,NICK_NAME,IS_SELF,DATE,FACE_PATH,VOICE_TIME,FAIL,BODY,LANGUAGE,POST_TYPE,B_DATA) VALUES(?,?,?,?,?,?,?,?,?,?,?)",fromId,nickname,isSelf,date,facepath,voicetime,fail,body,language,postType, data];
        }
        [db close];
    }];
    return count;
}

+(void)queryTableWeibo {
    if (!dbQueen)
    {
        [self createDB];
    }
    
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            FMResultSet *resultSet;
            if ([db tableExists:@"weibo"]) {
                resultSet = [db executeQuery:@"select * from weibo"];
                while ([resultSet next]) {
                    NSLog(@"[levi]shareType: %@ ,fileType: %@ ,mediaBody: %@ ,songUrl: %@ ,allowComment: %@ ,allowShare: %@ ,contentBody: %@ ,circleId: %@ ,mediaType: %@ ,location: %@ ,latitude: %@ ,longgitude: %@",
                          [resultSet objectForColumnIndex:1],
                          [resultSet objectForColumnIndex:2],
                          [resultSet objectForColumnIndex:3],
                          [resultSet objectForColumnIndex:4],
                          [resultSet objectForColumnIndex:5],
                          [resultSet objectForColumnIndex:6],
                          [resultSet objectForColumnIndex:7],
                          [resultSet objectForColumnIndex:8],
                          [resultSet objectForColumnIndex:9],
                          [resultSet objectForColumnIndex:10],
                          [resultSet objectForColumnIndex:11],
                          [resultSet objectForColumnIndex:12]);
                }
                [resultSet close];
            }
        }
        [db close];
    }];
}

+(void)queryTableBadge {
    if (!dbQueen)
    {
        [self createDB];
    }
    
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            FMResultSet *resultSet;
            if ([db tableExists:@"badge"]) {
                resultSet = [db executeQuery:@"select atValue,commentValue,messageValue,noticeValue from badge"];
                while ([resultSet next]) {
                    NSLog(@"[levi]atValue: %@ ,commentValue: %@ ,messageValue: %@ ,noticeValue: %@",
                          [resultSet objectForColumnIndex:1],
                          [resultSet objectForColumnIndex:2],
                          [resultSet objectForColumnIndex:3],
                          [resultSet objectForColumnIndex:4]);
                }
                [resultSet close];
            }
        }
        [db close];
    }];
}

+(NSMutableArray*)queryFakeWeiboItem {
    if (!dbQueen)
    {
        [self createDB];
    }
    __block NSMutableArray *statusArray= [[NSMutableArray alloc] init];
    
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            FMResultSet *resultSet;
            if ([db tableExists:@"weibo"]) {
                resultSet = [db executeQuery:@"select * from weibo where share_type = 1"];
                while ([resultSet next]) {
                    Status *tmpStatus = [[Status alloc] init];
                    //NEED UISERID
//                    tmpStatus.contentBody = [resultSet objectForColumnIndex:7];
                    if ([[resultSet objectForColumnIndex:5] integerValue] == 1) {
//                        tmpStatus.allowComment = YES;
                    } else {
//                        tmpStatus.allowComment = NO;
                    }
                    if ([[resultSet objectForColumnIndex:6] integerValue] == 1) {
//                        tmpStatus.allowShare = YES;
                    } else {
//                        tmpStatus.allowShare = NO;
                    }
//                    tmpStatus.location = [resultSet objectForColumnIndex:10];
//                    tmpStatus.latitude = [resultSet objectForColumnIndex:11];
//                    tmpStatus.longgitude = [resultSet objectForColumnIndex:12];
//                    tmpStatus.songUrl = [resultSet objectForColumnIndex:4];
//                    tmpStatus.mediaBody = [resultSet objectForColumnIndex:3];
//                    tmpStatus.submitCircleId = [resultSet objectForColumnIndex:8];
//                    NSLog(@"[levi]body : %@ allowcomment :%d allowshare :%d", tmpStatus.contentBody, tmpStatus.allowComment, tmpStatus.allowShare);
                    [statusArray addObject:tmpStatus];
                }
                [resultSet close];
            }
        }
        [db close];
    }];
    return statusArray;
}

+(BadgeValue*)queryBadgeValue {
    if (!dbQueen)
    {
        [self createDB];
    }
    __block BadgeValue *tmpBadge;
    
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            FMResultSet *resultSet;
            if ([db tableExists:@"badge"]) {
                resultSet = [db executeQuery:@"select atValue,commentValue,messageValue,noticeValue from badge"];
                while ([resultSet next]) {
                    tmpBadge = [[BadgeValue alloc] init];
                    tmpBadge.atValue = [resultSet objectForColumnIndex:0];
                    tmpBadge.commentValue = [resultSet objectForColumnIndex:1];
                    tmpBadge.messageValue = [resultSet objectForColumnIndex:2];
                    tmpBadge.noticeValue = [resultSet objectForColumnIndex:3];
                }
                [resultSet close];
            }
        }
        [db close];
    }];
    return tmpBadge;
}

+(NSInteger)deleteLocalWeibo {
    if (!dbQueen)
    {
        [self createDB];
    }
    __block int count = 0;
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            if ([db tableExists:@"weibo"]) {
                count = [db executeUpdate:@"delete from weibo"];
            }
        }
        [db close];
    }];
    return count;
}

+(NSMutableArray*)readMessagelast:(NSString *)fromeId toid:(NSString *)toId {
    if (!dbQueen)
    {
        [self createDB];
    }
    
    __block NSMutableArray *messageListArray = [[NSMutableArray alloc] init];
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            FMResultSet *resultSet;
            //NEED UISERID
//            NSString *userId=[NSString stringWithFormat:@"%d",[[RunInfo sharedInstance] userId]];
            NSString *userId;
            if ([db tableExists:@"MessageLast"]) {
                resultSet = [db executeQuery:@"SELECT ID,BRAND,TO_ID,Type ,NICKNAME,LASTDATA ,FACEPATH,BODY,IS_SELF,VOICETIME,POSTTYPE  FROM MessageLast WHERE (BRAND=? AND TO_ID = ? AND USERID = ?) OR (BRAND = ? AND TO_ID = ? AND USERID = ?)", fromeId,toId,userId,toId,fromeId,userId];
                while ([resultSet next]) {
                    NSString *rowid = [resultSet objectForColumnIndex:0];
                    NSString *FromId = [resultSet objectForColumnIndex:1];
                    NSString *TO_ID = [resultSet objectForColumnIndex:2];
                    NSString *Type = [resultSet objectForColumnIndex:3];
                    NSString *Nickname = [resultSet objectForColumnIndex:4];
                    NSString *Last_data = [resultSet objectForColumnIndex:5];
                    NSString *FacePath = [resultSet objectForColumnIndex:6];
                    NSString *body = [resultSet objectForColumnIndex:7];
                    NSString *isself = [resultSet objectForColumnIndex:8];
                    NSString *voicetime = [resultSet objectForColumnIndex:9];
                    NSString *posttype = [resultSet objectForColumnIndex:10];
                    NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:Last_data,@"Last_data",
                                            Type,@"type",
                                            Nickname,@"nickname",
                                            FacePath, @"heardImage_",
                                            FromId,@"fromid",
                                            TO_ID,@"toid",
                                            rowid,@"rowid",
                                            body,@"text",
                                            isself,@"self",
                                            voicetime,@"voicelong",
                                            posttype,@"posttype", nil];
                    [messageListArray addObject:tmpDic];
                }
                [resultSet close];
            }
        }
        [db close];
    }];
    return messageListArray;
}

+(NSInteger)updateMessageLast:(NSString *)fromId ToId:(NSString *)toId AtId:(NSString *)atId {
    if (!dbQueen)
    {
        [self createDB];
    }
    __block int count = 0;
    [dbQueen inDatabase:^(FMDatabase *db){
        
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if([db tableExists:@"MessageLast"])
            {
                count = [db executeUpdate:@"UPDATE MessageLast SET POSTTYPE=2 WHERE (BRAND=? AND TO_ID = ? AND POSTTYPE !=3)", toId, fromId];
            }
        }
        [db close];
    }];
    return count;
}

+(NSInteger)updateMessageLast:(NSString *)fromId ToId:(NSString *)toId {
    if (!dbQueen)
    {
        [self createDB];
    }
    __block int count = 0;
    [dbQueen inDatabase:^(FMDatabase *db){
        
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if([db tableExists:@"MessageLast"])
            {
                count = [db executeUpdate:@"UPDATE MessageLast SET POSTTYPE=2 WHERE (BRAND=%@ AND TO_ID = %@ AND POSTTYPE !=3)", toId, fromId];
            }
        }
        [db close];
    }];
    return count;
}

+(NSInteger)updateMessage:(NSString *)fromId ToId:(NSString *)toId {
    if (!dbQueen)
    {
        [self createDB];
    }
    __block int count = 0;
    [dbQueen inDatabase:^(FMDatabase *db){
        
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if([db tableExists:@"MessageLast"])
            {
                count = [db executeUpdate:@"UPDATE MessageLast SET BODY=? WHERE ID = ?",toId,fromId];
            }
        }
        [db close];
    }];
    return count;
}

+(NSInteger)updatemessageDidNotSuccess:(NSString *)rowid {
    if (!dbQueen)
    {
        [self createDB];
    }
    
    __block int count = 0;
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if([db tableExists:@"MessageLast"])
            {
                count = [db executeUpdate:@"UPDATE MessageLast SET POSTTYPE=1 WHERE (ID=?AND POSTTYPE =3)",rowid];
            }
        }
        [db close];
    }];
    return count;
}

+(NSInteger)updateChatLast:(NSString *)fromId ToId:(NSString *)toId AtId:(NSString *)atId {
    if (!dbQueen)
    {
        [self createDB];
    }
    
    __block int count = 0;
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if([db tableExists:@"ChatLast"])
            {
                if ([atId isEqualToString:@"1"]) {
                    count = [db executeUpdate:@"UPDATE ChatLast SET POSTTYPE=2 WHERE (BRAND=? AND TO_ID = ?) OR (BRAND=? AND TO_ID = ?)", toId,fromId,fromId,toId];
                } else if ([atId isEqualToString:@"2"]) {
                    count = [db executeUpdate:@"UPDATE ChatLast SET POSTTYPE=1 WHERE (BRAND=? AND TO_ID = ?) OR (BRAND=? AND TO_ID = ?)",toId,fromId,fromId,toId];
                } else if ([atId isEqualToString:@"0"]) {
                    count = [db executeUpdate:@"UPDATE ChatLast SET POSTTYPE=1 WHERE (BRAND=? AND TO_ID = ?) OR (BRAND=? AND TO_ID = ?)",toId,fromId,fromId,toId];
                }
            }
        }
        [db close];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Refreshlest" object:nil];
    return count;
}

+(NSString*)readMessage:(NSString *)fromeId toid:(NSString *)toId UserId:(NSString *)userid {
    if (!dbQueen)
    {
        [self createDB];
    }
    
    __block NSString *tmpLanguage = @"0";
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if([db tableExists:@"MessageLast"])
            {
                FMResultSet *resultSet = [db executeQuery:@"SELECT LANGUAGE  FROM MessageLast WHERE (BRAND=? AND TO_ID = ?) OR (BRAND=? AND TO_ID = ?)",fromeId, toId, toId, fromeId];
                while ([resultSet next]) {
                    tmpLanguage = [resultSet objectForColumnIndex:0];
                    break;
                }
                [resultSet close];
            }
        }
        [db close];
    }];
    return tmpLanguage;
}

+(NSMutableArray*)readChatLastByOrder:(NSString *)fromeId toid:(NSString *)toId UserId:(NSString *)userid {
    if (!dbQueen)
    {
        [self createDB];
    }
    __block NSMutableArray *tmpArray=[[NSMutableArray alloc]init];
    
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if([db tableExists:@"ChatLast"])
            {
                FMResultSet *resultSet = [db executeQuery:@"SELECT	ID,BRAND,TO_ID,Type ,NICKNAME,LASTDATA ,FACEPATH,BODY,POSTTYPE,USERID,DISTANCE ,LANGUAGE  FROM ChatLast WHERE USERID=?  ORDER BY LASTDATA asc", userid];
                while ([resultSet next]) {
                    NSString *rowid = [resultSet objectForColumnIndex:0];
                    NSString *FromId = [resultSet objectForColumnIndex:1];
                    NSString *TO_ID = [resultSet objectForColumnIndex:2];
                    NSString *Type = [resultSet objectForColumnIndex:3];
                    NSString *Nickname = [resultSet objectForColumnIndex:4];
                    NSString *Last_data = [resultSet objectForColumnIndex:5];
                    NSString *FacePath = [resultSet objectForColumnIndex:6];
                    NSString *body = [resultSet objectForColumnIndex:7];
                    NSString *posttype = [resultSet objectForColumnIndex:8];
                    //        NSString *userid = [resultSet objectForColumnIndex:9];
                    NSString *distance = [resultSet objectForColumnIndex:10];
                    NSString *Language = [resultSet objectForColumnIndex:11];
                    NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:Last_data,@"Last_data",Type,@"type",Nickname,@"nickname",FacePath, @"facepath",FromId,@"fromid",TO_ID,@"toid",rowid,@"rowid",posttype,@"posttype",body,@"text",distance,@"distance",Language,@"language", nil];
                    [tmpArray addObject:tmpDic];
                }
                [resultSet close];
            }
        }
        [db close];
    }];
    return tmpArray;
}

+(NSInteger)deleteChat:(NSString *)clothId {
    if (!dbQueen)
    {
        [self createDB];
    }
    __block int count = 0;
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if([db tableExists:@"ChatLast"])
            {
                count = [db executeUpdate:@"DELETE FROM ChatLast WHERE ID=?", clothId];
            }
        }
        [db close];
    }];
    return count;
}

+(NSInteger)deleteMessageByChat:(NSString *)fromId toid:(NSString *)toId {
    if (!dbQueen)
    {
        [self createDB];
    }
    __block int count = 0;
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if([db tableExists:@"MessageLast"])
            {
                count = [db executeUpdate:@"DELETE FROM MessageLast WHERE (BRAND=? AND TO_ID = ?) OR (BRAND=? AND TO_ID = ?)",fromId, toId, toId, fromId];
            }
        }
        [db close];
    }];
    return count;
}

+(NSInteger)deleteChatByMessage:(NSString *)fromId toid:(NSString *)toId {
    if (!dbQueen)
    {
        [self createDB];
    }
    __block int count = 0;
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if([db tableExists:@"ChatLast"])
            {
                count = [db executeUpdate:@"DELETE FROM ChatLast WHERE (BRAND=? AND TO_ID = ?) OR (BRAND=? AND TO_ID = ?)",fromId, toId, toId, fromId];
            }
        }
        [db close];
    }];
    return count;
}

+(NSInteger)updateMessage:(NSString *)fromId ToId:(NSString *)toId language:(NSString *)language {
    if (!dbQueen)
    {
        [self createDB];
    }
    
    __block int count = 0;
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if([db tableExists:@"MessageLast"])
            {
                count = [db executeUpdate:@"UPDATE MessageLast SET LANGUAGE=? WHERE (BRAND=? AND TO_ID = ?) OR (BRAND=? AND TO_ID = ?)", language, fromId, toId, toId, fromId];
            }
        }
        [db close];
    }];
    return count;
}

+(NSInteger)deleteMessageLastAtId:(NSString *)atId {
    if (!dbQueen)
    {
        [self createDB];
    }
    
    __block int count = 0;
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if([db tableExists:@"MessageLast"])
            {
                count = [db executeUpdate:@"DELETE FROM MessageLast WHERE ID=?", atId];
            }
        }
        [db close];
    }];
    return count;
}

+(void)queryChatTable {
    if (!dbQueen)
    {
        [self createDB];
    }
    
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if([db tableExists:@"ChatLast"])
            {
                FMResultSet *resultSet = [db executeQuery:@"SELECT BRAND,TO_ID,Type,NICKNAME,LASTDATA,FACEPATH, BODY,POSTTYPE,USERID,DISTANCE,LANGUAGE FROM ChatLast"];
                while ([resultSet next]) {
                    NSString *str1 = [resultSet objectForColumnIndex:0];
                    NSString *str2 = [resultSet objectForColumnIndex:1];
                    NSString *str3 = [resultSet objectForColumnIndex:2];
                    NSString *str4 = [resultSet objectForColumnIndex:3];
                    NSString *str5 = [resultSet objectForColumnIndex:4];
                    NSString *str6 = [resultSet objectForColumnIndex:5];
                    NSString *str7 = [resultSet objectForColumnIndex:6];
                    NSString *str8 = [resultSet objectForColumnIndex:7];
                    NSString *str9 = [resultSet objectForColumnIndex:8];
                    NSString *str10 = [resultSet objectForColumnIndex:9];
                    NSString *str11 = [resultSet objectForColumnIndex:10];
                    NSLog(@"[levi] ChatTable brand %@ to_id %@ type %@ nickname %@ lastdata %@ facepath %@ body %@ posttype %@ userid %@ distance %@ language %@",
                          str1,
                          str2,
                          str3,
                          str4,
                          str5,
                          str6,
                          str7,
                          str8,
                          str9,
                          str10,
                          str11);
                }
                [resultSet close];
            }
        }
        [db close];
    }];
}

+(void)queryMessageTable {
    if (!dbQueen)
    {
        [self createDB];
    }
    
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if([db tableExists:@"MessageLast"])
            {
                FMResultSet *resultSet = [db executeQuery:@" SELECT BRAND,TO_ID,Type,NICKNAME,LASTDATA,FACEPATH,BODY,IS_SELF,VOICETIME,POSTTYPE,USERID FROM MessageLast"];
                while ([resultSet next]) {
                    NSString *str1 = [resultSet objectForColumnIndex:0];
                    NSString *str2 = [resultSet objectForColumnIndex:1];
                    NSString *str3 = [resultSet objectForColumnIndex:2];
                    NSString *str4 = [resultSet objectForColumnIndex:3];
                    NSString *str5 = [resultSet objectForColumnIndex:4];
                    NSString *str6 = [resultSet objectForColumnIndex:5];
                    NSString *str7 = [resultSet objectForColumnIndex:6];
                    NSString *str8 = [resultSet objectForColumnIndex:7];
                    NSString *str9 = [resultSet objectForColumnIndex:8];
                    NSString *str10 = [resultSet objectForColumnIndex:9];
                    NSString *str11 = [resultSet objectForColumnIndex:10];
                    NSLog(@"[levi]query Message table brand %@ to_id %@ type %@ nickname %@ lastdata %@ facepath %@ body %@ isSelf %@ voicetime %@ posttype %@ userid %@",
                          str1,
                          str2,
                          str3,
                          str4,
                          str5,
                          str6,
                          str7,
                          str8,
                          str9,
                          str10,
                          str11);
                }
                [resultSet close];
            }
        }
        [db close];
    }];
}

//插入数据到表中
+(void)saveNotice:(NoticeTool *)aNoticeTool
{
    if (!dbQueen)
    {
        [self createDB];
    }
    
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if(![db tableExists:@"notice"])
            {
                [db executeUpdate:@"create table notice (notice_id integer primary key autoincrement , message text ,type integer, isread text, nickname text,facepath text,createtime text,userid text)"];
            }
            
            FMResultSet *resultSet = [db executeQuery:@"select * from notice where notice_id = ?",[NSString stringWithFormat:@"%d",aNoticeTool.NoticeID]];
            
            //如果有记录，代表表中已经存在相同id的记录，就要更新这条记录，而不是插入
            if ([resultSet next])
            {
                [db executeUpdate:@"update notice set message = ?, type = ?, isread = ?, nickname = ?,facepath = ?,createtime = ?,userid = ? where people_id = ? ",aNoticeTool.Message,[NSString stringWithFormat:@"%d",aNoticeTool.NoticeType],aNoticeTool.IsRead,[NSString stringWithFormat:@"%d",aNoticeTool.NoticeID],aNoticeTool.NickName,aNoticeTool.FacePath,aNoticeTool.CreatTime,aNoticeTool.UserIdNotice];
            }
            //没有相同数据的话，插入一条新数据
            else
            {
                [db executeUpdate:@"insert into notice (message,type,isread,nickname,facepath,createtime,userid ) values ( ? , ?, ? ,? ,? ,? ,? )",aNoticeTool.Message,[NSString stringWithFormat:@"%d",aNoticeTool.NoticeType],aNoticeTool.IsRead,aNoticeTool.NickName,aNoticeTool.FacePath,aNoticeTool.CreatTime,aNoticeTool.UserIdNotice];
            }
            
            //使用完毕后，需要把结果集，还有数据库关闭
            [resultSet close];
        }
        [db close];
    }];
}
//获得数据库中notice表中所有的记录
+(NSArray *)getAllNotice
{
    if (!dbQueen)
    {
        [self createDB];
    }
    
    __block NSMutableArray *noticeArray = [[NSMutableArray alloc] initWithCapacity:0];
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if([db tableExists:@"notice"])
            {
                //查询notice表中所有的数据（根据id来反序查询）
                FMResultSet *resultSet = [db executeQuery:@"select * from   notice order by notice_id desc"];
                //创建一个可变数组，用于存放查询出来的对象
                
                //遍历结果集，每一次[resultSet next] 相当于取下一条数据
                while ([resultSet next])
                {
                    //创建一个新的people对象
                    NoticeTool *notice = [[NoticeTool alloc] init];
                    
                    //把当前记录的值赋给对象的属性
                    notice.NoticeID = [resultSet intForColumn:@"notice_id"];
                    notice.Message = [resultSet stringForColumn:@"message"];
                    notice.NoticeType = [resultSet intForColumn:@"type"];
                    notice.IsRead = [resultSet stringForColumn:@"isread"];
                    
                    notice.NickName = [resultSet stringForColumn:@"nickname"];
                    notice.FacePath = [resultSet stringForColumn:@"facepath"];
                    notice.CreatTime = [resultSet stringForColumn:@"createtime"];
                    notice.UserIdNotice = [resultSet stringForColumn:@"userid"];
                    
                    //把当前这条记录所对应的people数据放到数组里
                    [noticeArray addObject:notice];
                }
                
                [resultSet close];
            }
        }
        [db close];
    }];
    
    return noticeArray;
}


//删除表中对应的id的记录
+(void)deleteNoticeByID:(int)aID
{
    if (!dbQueen)
    {
        [self createDB];
    }
    
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if([db tableExists:@"notice"])
            {
                //delete from 表名 where  判断条件
                [db executeUpdate:@"delete from notice where notice_id = ?",[NSString stringWithFormat:@"%d",aID]];
            }
        }
        [db close];
    }];
}


+ (void)changeIsReadByUerid:(int )aid
{
    if (!dbQueen)
    {
        [self createDB];
    }
    [dbQueen inDatabase:^(FMDatabase *db){
        if ([db open]) {
            [db setShouldCacheStatements:YES];
            
            if ([db tableExists:@"notice"])
            {
                [db executeUpdate:@"update notice set isread = 1 where notice_id = ? ", [NSString stringWithFormat:@"%d",aid]];
            }
        }
        [db close];
    }];
}

@end
