//
//  LPDataBaseutil.h
//  FreeBao
//
//  Created by freebao on 13-5-5.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "NoticeTool.h"
#import "BadgeValue.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "Status.h"

@interface LPDataBaseutil : NSObject

- (void)createTableNotice:(FMDatabase *)db;
+ (void)saveNotice:(NoticeTool *)aNoticeTool;
+ (NSArray *)getAllNotice;
+ (void)deleteNoticeByID:(int)aID;
+ (void)changeIsReadByUerid:(int )aid;

- (void)createTableChat:(FMDatabase *)db;
- (void)createTableMessage:(FMDatabase *)db;

+ (NSInteger)insertChatLast:(NSString *)fromId ToId:(NSString *)toId Type:(NSString *)type nickName:(NSString *)nickname last_date:(NSString *)last_date face_path:(NSString *)facepath body:(NSString *)body postType:(NSString *)postType disTance:(NSString *)distance UserId:(NSString *)userid;
+ (NSInteger)insertMessageLast:(NSString *)fromId ToId:(NSString *)toId Type:(NSString *)type nickName:(NSString *)nickname last_date:(NSString *)last_date face_path:(NSString *)facepath voicetime:(NSString *)voicetime body:(NSString *)body postType:(NSString *)postType isSelf:(NSString *)isSelf language:(NSString*)language;

+ (NSInteger)insertBothLast:(NSString *)fromId ToId:(NSString *)toId Type:(NSString *)type nickName:(NSString *)nickname last_date:(NSString *)last_date face_path:(NSString *)facepath voicetime:(NSString *)voicetime body:(NSString *)body postType:(NSString *)postType isSelf:(NSString *)isSelf language:(NSString*)language disTance:(NSString *)distance;

- (void)createTableLocalWeibo:(FMDatabase *)db;
+ (NSInteger)saveWeibo:(NSString *)shareType FileType:(NSString *)fileType MediaBody:(NSString *)mediaBody SongUrl:(NSString *)songUrl AllowComment:(NSString *)allowComment
AllowShare:(NSString *)allowShare ContentBody:(NSString *)contentBody CircleId:(NSString *)circleId MediaType:(NSString *)mediaType Location:(NSString *)location Latitude:(NSString *) latitude Longgitude:(NSString *)longgitude;
+ (void)queryTableWeibo;
+ (NSMutableArray*)queryFakeWeiboItem;
+ (NSInteger)deleteLocalWeibo;

- (void)createTableBadge:(FMDatabase *)db;

+ (NSInteger)saveOrUpdateBadge:(NSString *)atValue CommentValue:(NSString*)commentValue MessageValue:(NSString*)messageValue NoticeValue:(NSString*)noticeValue;
+ (BadgeValue*)queryBadgeValue;
+ (NSInteger)deleteBadgeItem;
+ (void)queryTableBadge;

+ (NSMutableArray*)readMessagelast:(NSString *)fromeId toid:(NSString *)toId;
+ (NSInteger)updateMessageLast:(NSString *)fromId ToId:(NSString *)toId AtId:(NSString *)atId;
+ (NSInteger)updateMessageLast:(NSString *)fromId ToId:(NSString *)toId;
+ (NSInteger)updateMessage:(NSString *)fromId ToId:(NSString *)toId;
+ (NSInteger)updatemessageDidNotSuccess:(NSString *)rowid;

+ (NSInteger)updateChatLast:(NSString *)fromId ToId:(NSString *)toId AtId:(NSString *)atId;
+ (NSString*)readMessage:(NSString *)fromeId toid:(NSString *)toId UserId:(NSString *)userid;
+ (NSInteger)updateMessage:(NSString *)fromId ToId:(NSString *)toId language:(NSString *)language;
+ (NSInteger)deleteMessageLastAtId:(NSString *)atId;

+ (NSMutableArray*)readChatLastByOrder:(NSString *)fromeId toid:(NSString *)toId UserId:(NSString *)userid;
+ (NSInteger)deleteChat:(NSString *)clothId;

+ (NSInteger)deleteMessageByChat:(NSString *)fromId toid:(NSString *)toId;
+ (NSInteger)deleteChatByMessage:(NSString *)fromId toid:(NSString *)toId;

+ (void)queryMessageTable;
+ (void)queryChatTable;
@end