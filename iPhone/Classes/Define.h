//
//  Define.h
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/06/28.
//  Copyright 2010 3di. All rights reserved.
//

#import <UIKit/UIKit.h>

// Flag
#define USE_WEBKIT false
#define PAGING_BY_TAP true
#define PAGING_BY_BUTTON true
#define TOP_ALIGN_ON_ZOOM true

// Page size
#define WINDOW_AW 320
#define WINDOW_AH 460
#define WINDOW_BW 1024
#define WINDOW_BH 768

// Page Margin
#define PAGE_MARGIN_TOP 0
#define PAGE_MARGIN_BOTTOM 0
#define PAGE_MARGIN_LEFT 0
#define PAGE_MARGIN_RIGHT 0

// Button Size
#define PAGING_BUTTON_WIDTH 40
#define PAGING_BUTTON_HEIGHT 40
#define PAGING_BUTTON_MARGIN 5

#define SHADOW_RED 1.0f
#define SHADOW_GREEN 1.0f
#define SHADOW_BLUE 1.0f

#define SHADOW_ALPHA 0.5f
#define TOP_SHADOW_ALPHA 0.2f
#define TOP_OVERLAY_ALPHA 0.6f

#define FACE_PAGE_SHADOW_ALPHA 0.4f

// Set speed of curling page
#define CURL_BOOST 1.25f

// Max scale
#define MAX_ZOOM_SCALE 3.0f
#define MIN_ZOOM_SCALE 1.0f

#define REVERSE_PAGE_OPACITY 0.5f

#define PAGING_WAIT_TIME 0.003f

#define CURL_SPAN 0.01f

#define PAGE_CHANGE_TRIGGER_MARGIN 20.0f

#define CENTER_SHADOW_WIDTH 32
#define TOP_SHADOW_WIDTH 30
#define BOTTOM_SHADOW_WIDTH 100

// URL
#define TOP_URL @"http://wepublish.jp/"
#define UPDATE_URL @"https://wepublish.jp/mypage/login_check.php"
#define NEW_ACCOUNT_URL @"https://wepublish.jp/"

// Event
#define APP_FINISH_EVENT @"app_finish_event"
#define LOGO_END_EVENT @"logo_end_event"
#define AUTHENTICATION_EVENT @"autheantication_event"
#define LOGIN_FINISH_END_EVENT @"login_finish_event"
#define LOGIN_FINISHED_AND_XML_CHECK_EVENT @"login_finished_and_xml_check_event"
#define PARSE_END_EVENT @"parse_end_event"               // XML解析完了
#define DLBOOK_SUCCESS_EVENT @"dlbook_success_event"     // DL成功
#define DLBOOK_ERROR_EVENT @"dlbook_error_event"         // DL失敗
#define PAGE_CHANGE_EVENT @"page_change_event"           // ページの切り替わり
#define BOOKMARK_SAVE_EVENT @"bookmark_save_event"       // しおり保存
#define READ_TO_SELECT_EVENT @"read_to_select_event"     // 読む画面から選択画面へ
#define LIST_TO_DETAIL_EVENT @"list_to_detail_event"     // 詳細画面から選択画面へ
#define DETAIL_DISAPPEAR_EVENT @"detail_disappear_event" // 詳細画面を消すアニメーション開始
#define DETAIL_TO_READ_EVENT @"detail_to_read_event"     // 詳細画面から読む画面へ

// TagID
#define TRASH_ALERT_TAG 100
#define RELOAD_DATA_ALERT_TAG 101
#define BOOKMARK_ALERT_TAG 102
#define BOOK_ACTIVITY_INDICATOR 200

// Auth
#define UPDATE_RETRY_COUNT 2
#define AUTH_USERNAME @"wpauth"
#define AUTH_PASSWORD @"ka08tbj3hZfa"

// Message
#define STATUS_START_TO_UPDATE @"本棚を更新しています。"
#define STATUS_DOWNLOADING_BOOKS @"本をダウンロード中..."
#define WARNING_TITLE @"警告"
#define BOOKMARK_MESSAGE @"続きから読みますか？"
#define TRASH_WARNING_MESSAGE @"アプリに保存された本をすべて削除します。アカウントを再設定して、本を再ダウンロードできます。\nよろしいですか？"
#define RELOAD_DATA_WARNING_MESSAGE @"ログイン画面に戻ります。"
#define AUTHENTICATION_ERROR_MESSAGE @"認証に失敗しました。"
#define NETWORK_ERROR_MESSAGE @"ネットワークに接続されていません。"
#define NETWORK_ERROR_LOGO_MESSAGE @"情報が取得できません\nアプリケーションを終了して下さい。"

#define XML_DIRECTORY @"xml"
#define BOOK_DIRECTORY @"xml/book"
#define BOOK_EXTENSION @"jpg"
#define LIST_FILENAME @"list.xml"
#define USER_FILENAME @"user.xml"
#define BOOKMARK_FILENAME @"bookmark.xml"
#define USER_NAME @"name"
#define USER_PASS @"pass"
#define USER_ADMITTED @"admitted"
#define BOOKMARK_UUID @"uuid"
#define BOOKMARK_PAGE @"page"
