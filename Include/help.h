#define COMSCOPE_HELP_TABLE       30000
#define SUBTABLE_COMSCOPE         30001

#define HLPP_KEYS                 30003
#define HLPP_GENERAL              30004
#define HLPP_HELP                 30005
#define HLPP_HELPINDEX            30006
#define HLPP_HELPFORHELP          30007
#define HLPP_HELPEXTEND           30008

#define HLPP_DEVICE_SETUP_DLG     30011
//#define HLPP_HDW_SETUP_DLG        30010
#define HLPP_BUFFER_SETUP_DLG     30012
#define HLPP_LINE_PROTOCOL_DLG    30013
#define HLPP_BAUD_DLG             30014
#define HLPP_DEF_BAUD_DLG             30015
#define HLPP_DEF_LINE_PROTOCOL_DLG    30016
#define HLPP_DEF_TIMEOUT_DLG          30017
#define HLPP_DEF_FILTER_DLG           30018
#define HLPP_DEF_FIFO_DLG         30019
#define HLPP_DEF_HANDSHAKE_DLG        30020
#define HLPP_FILE_OPEN            30021
#define HLPP_INI_OPEN             30022
#define HLPP_INSTALL_DLG          30023
#define HLPP_UPDATE_FREQ_DLG      30024
#define HLPP_SHOW_ALL_DLG         30025
#define HLPP_BUFFER_SIZE_DLG      30026
#define HLPP_MONITOR_UPDATE_DLG   30027
#define HLPP_EXT_DLG              30028
#define HLPP_OEM_DLG              30029
#define HLPP_16550_FIFO_DLG       30030
#define HLPP_16650_FIFO_DLG       30031
#define HLPP_16750_FIFO_DLG       30032
#define HLPP_16654_FIFO_DLG       30033
#define HLPP_DEF_THRESHOLD_DLG        30034
#define HLPP_PACKET_QUEUE_DLG     30035
#define HLPP_TIMEOUT_DLG          30036
#define HLPP_FILTER_DLG           30037
#define HLPP_FIFO_DLG             30038
#define HLPP_HANDSHAKE_DLG        30039
#define HLPP_THRESHOLD_DLG        30040

#define HLPP_SIMPLE_CFG_DLG       30100
#define HLPP_OEM_SETUP            30101
#define HLPP_CONFIG_DEVICE_NAME   30102
#define HLPP_DEVICE_NAME          30103
#define HLPP_ADD_LOAD             30104
#define HLPP_REMOVE_LOAD          30105
#define HLPP_VERBOSE              30106
#define HLPP_KEY_WAIT             30107
#define HLPP_DEVICE_LIST          30108
#define HLPP_EDIT_DEVICE          30109
#define HLPP_ADD_DEVICE           30110
#define HLPP_REMOVE_DEVICE        30111
#define HLPP_CANCEL               30112
#define HLPP_OK                   30113

#define HLPP_COUNTS_DLG           30117
#define HLPP_DISPLAY_DLG          30118
#define HLPP_DISPLAY_CFG          30119
#define HLPP_COLOR_CFG            30120
#define HLPP_COLOR_DLG            30121

#define HLPP_DEF_PROTOCOL_DLG     30123
#define HLPP_EXTENSION            30125
#define HLPP_MB_NO_COMSCOPE_LEFT  30126
#define HLPP_MB_NO_COMSCOPE_AVAIL 30127
#define HLPP_MB_NO_COMSCOPE       30128
#define HLPP_MB_NO_TESTCFG        30129
#define HLPP_MB_NO_INI_FILENAME   30130
#define HLPP_MB_COMSCOPE_PORT_NOT_AVAIL 30131

#define HLPP_OPTION_DLG           30133
#define HLPP_UNINSTALL_DLG        30134
#define HLPP_MB_UNINSTALL         30135
#define HLPP_MB_CONFIG_OK         30136
#define HLPP_MB_CONFIG_BAD        30137
#define HLPP_MB_LIBRARY_BAD       30138

#define HLPP_TIME_DISP_DLG        30201
#define HLPP_EVENTS_DLG           30202
#define HLPP_FIND_DLG             30203

#define HLPP_DCB_DLG              30204

#define HLPP_COM_EVENT_BITS       30400
#define HLPP_COM_STATUS_BITS      30401
#define HLPP_COM_ERROR_BITS       30402
#define HLPP_XMIT_STATUS_BITS     30403

// Install
#define HLPP_MB_OLD_FILE          30501
#define HLPP_MB_FILE_INUSE        30502
#define HLPP_MB_DELETE_DENIED     30503
#define HLPP_MB_DELETE_FOLDER     30504

// profile help
#define HLPP_PROFILE              40000
#define HLPP_PROFILE_DLG          40001 // this item and the next six items (HLPP_MB_PROFILE_) must be ordered as is
#define HLPP_MB_PROFILE_SAVE      40002
#define HLPP_MB_PROFILE_DEL       40003
#define HLPP_MB_PROFILE_NAME      40004
#define HLPP_MB_PROFILE_NEW       40005
#define HLPP_MB_PROFILE_DONE      40006
#define HLPP_MB_PROFILE_LOAD      40007

#define HLPP_MB_NO_COMI           40100
#define HLPP_MB_CONFIGSYS         40101 // this and the next MUST be numbered in this order
#define HLPP_MB_CONFIGSYS_BAD     40102
#define HLPP_MB_BAD_DEVICE        40103
#define HLPP_MB_BUFF_SIZE         40104
#define HLPP_MB_OVERWRT_CAP_FILE  40105
#define HLPP_MB_OVERWRT_FILE      40106
#define HLPP_MB_SHARE_ACCESS      40107
#define HLPP_MB_NONEXCLUSIVE_ACCESS 40108
#define HLPP_SPOOL_DLG            40109
#define HLPP_MB_REQUIRE_RESTART   40110
#define HLPP_MB_COMSCOPE_ENABLE   40111
#define HLPP_MB_COMSCOPE_SHARE_ERROR 40112

#define HLPP_MENUS                50000
#define HLPP_FILE                 50100
#define HLPP_FILE_LOAD            50110
#define HLPP_FILE_SAVE            50120
#define HLPP_FILE_SAVEAS          50130
#define HLPP_FILE_EXIT            50140
#define HLPP_ACTION               50200
#define HLPP_ACT_CAPTURE          50210
#define HLPP_ACT_DISPLAY          50220
#define HLPP_ACT_EXAMINE          50230
#define HLPP_OPTIONS              50300
#define HLPP_OPT_CAP_BUFF         50310
#define HLPP_OPT_CAP_UPDATE       50320
#define HLPP_OPT_FORMAT           50330
#define HLPP_OPT_FORMAT_LEX       50331
#define HLPP_OPT_FORMAT_TIME      50332
#define HLPP_OPT_STICK            50340
#define HLPP_OPT_PROFILE          50350
#define HLPP_DEVICE               50400
#define HLPP_DEV_SELECT           50410
#define HLPP_DEV_INSTALL          50420
#define HLPP_DEV_STATUS           50430
#define HLPP_DEV_STATUS_DD        50431
#define HLPP_DEV_STATUS_IM        50432
#define HLPP_DEV_STATUS_OM        50433
#define HLPP_DEV_STATUS_RB        50434
#define HLPP_DEV_STATUS_TB        50435
#define HLPP_DEV_STATUS_COUNTS    50436
#define HLPP_DEV_STATUS_UPDATE    50437
#define HLPP_DEV_STATUS_ALL       50438
#define HLPP_DEV_CONTROL          50440
#define HLPP_DEV_CONTROL_KEY      50441
#define HLPP_DEV_CONTROL_FX       50442
#define HLPP_DEV_CONTROL_TX       50443
#define HLPP_DEV_CONTROL_BRK      50444
#define HLPP_DEV_CONTROL_FLUSH    50445
#define HLPP_DEV_CONTROL_OUT1     50446
#define HLPP_DEV_PROTOCOL         50450
#define HLPP_DEV_PROTOCOL_BAUD    50451
#define HLPP_DEV_PROTOCOL_LINE    50452
#define HLPP_DEV_PROTOCOL_TO      50453
#define HLPP_DEV_PROTOCOL_HS      50454
#define HLPP_DEV_PROTOCOL_FILT    50455
#define HLPP_DEV_PROTOCOL_FIFO    50456
#define HLPP_OEM_ALGO_DLG         50457
#define HLPP_MODEM_SIG_DLG        50458

#define HLPP_UNKNOWN              60000
#define HLPP_UNKNOWNDLG           60001



