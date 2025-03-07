	#define WM_COMMAND	0x0111

	; メニューアイテムIDを定義
	#define CMD_OPENBBS1	   1	  ;「BBS を開く」アイテムのID
	;#define CMD_OPENBBS2	   5
	#define CMD_MINI	   2	  ;「最小化」アイテムのID
	#define CMD_QUIT	   3	  ;「終了」アイテムのID
	;#define CMD_MESSAGE	4	  ;「メッセージ表示」アイテムのID

	;---------------「ファイル」メニューの作成-------------------
	dllproc "CreatePopupMenu", pm, 0, D_USER
	hmenufile = dllret			; 「ファイル」メニューハンドル

	mesbuf = "BBS を開く(&O)"
	pm = hmenufile, 0, CMD_OPENBBS1
	getptr pm.3, mesbuf
	dllproc "AppendMenuA", pm, 4, D_USER

	;mesbuf = "BBS(8000) を開く(&0)"
	;pm = hmenufile, 0, CMD_OPENBBS2
	;getptr pm.3, mesbuf
	;dllproc "AppendMenuA", pm, 4, D_USER

	mesbuf = "最小化(&N)"
	pm = hmenufile, 0, CMD_MINI
	getptr pm.3, mesbuf
	dllproc "AppendMenuA", pm, 4, D_USER

	pm = hmenufile, $800, 0, 0	; 区切り線を指定
	dllproc "AppendMenuA", pm, 4, D_USER

	mesbuf = "終了(&Q)"
	pm = hmenufile, 0, CMD_QUIT
	getptr pm.3, mesbuf
	dllproc "AppendMenuA", pm, 4, D_USER

	;----------------「ヘルプ」メニューの作成--------------------
	;dllproc "CreatePopupMenu", pm, 0, D_USER
	;hmenuhelp = dllret			; 「ヘルプ」メニューハンドル

	;mesbuf = "メッセージ表示(&M)"
	;pm = hmenuhelp, 0, CMD_MESSAGE
	;getptr pm.3, mesbuf
	;dllproc "AppendMenuA", pm, 4, D_USER

	;-------------------メニューバーの作成-----------------------
	dllproc "CreateMenu", pm, 0, D_USER
	hmenu = dllret				; メニューハンドル

	mesbuf = "ファイル(&F)"
	pm = hmenu, $10, hmenufile	; 「ファイル」メニュー追加
	getptr pm.3, mesbuf
	dllproc "AppendMenuA", pm, 4, D_USER

	;mesbuf = "ヘルプ(&H)"
	;pm = hmenu, $10, hmenuhelp	; 「ヘルプ」メニュー追加
	;getptr pm.3, mesbuf
	;dllproc "AppendMenuA", pm, 4, D_USER

	; ウィンドウのサブクラス化
	set_subclass
	hwnd = stat				   ; HSPウィンドウのハンドル
	set_message WM_COMMAND		; 取得メッセージ設定

	; メニューをウィンドウに割り当てる
	pm.0 = hwnd				   ; ウィンドウハンドル
	pm.1 = hmenu				  ; メニューハンドル
	dllproc "SetMenu", pm, 2, D_USER

	; メニューを再描画
	pm.0 = hwnd				   ; メニューハンドル
	dllproc "DrawMenuBar", pm, 1, D_USER

	; メッセージパラメータ用変数
	dup msg,  msgval.1			; メッセージが格納される変数
	dup wprm, msgval.2			; wParamパラメータが格納される変数
	dup lprm, msgval.3			; lParamパラメータが格納される変数

