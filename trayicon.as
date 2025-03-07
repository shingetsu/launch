	; トレイアイコン用のアイコンID
	#define ID_TRAYICON		 1

	; トレイアイコン用のメッセージコード
	#define MYWM_TRAYICON	   0x1000

	mref bmscr, 67				  ; ウィンドウのBMSCR構造体
	tooltext = "ShinGETsu Launcher" ; ツールチップテキスト

	; 自身の実行ファイル名取得
	sdim exefile, 260		   ; ファイル名を格納する変数
	pm = 0					  ; NULL
	getptr pm.1, exefile		; バッファアドレス取得
	pm.2 = 260				  ; バッファサイズ
	dllproc "GetModuleFileNameA", pm, 3, D_KERNEL

	; 実行ファイルからアイコンを取得
	getptr pm.0, exefile		; ファイル名
	pm.1 = 0					; アイコンインデックス
	pm.2 = 0					; 大きいアイコンは取得しない
	getptr pm.3, hicon		  ; 小さいアイコンのハンドルを格納する変数
	pm.4 = 1					; 取得する数
	dllproc "ExtractIconExA", pm, 5, D_SHELL

	; NOTIFYICONDATA 構造体
	dim  nid, 22
	nid.0 = 88				  ; 構造体サイズ
	nid.1 = bmscr.13			; ウィンドウハンドル
	nid.2 = ID_TRAYICON		 ; アイコンID
	nid.3 = 1 | 2 | 4		   ; NIF_MESSAGE | NIF_ICON | NIF_TIP
	nid.4 = MYWM_TRAYICON	   ; メッセージコード
	nid.5 = hicon			   ; アイコンハンドル
	poke nid, 24, tooltext	  ; ツールチップ文字列

	; タスクトレイにアイコンを追加
	pm.0 = 0					; NIM_ADD
	getptr pm.1, nid			; NOTIFYICONDATA 構造体アドレス
	dllproc "Shell_NotifyIconA", pm, 2, D_SHELL

	; トレイアイコン用メッセージを取得するようにセット
	set_subclass				; サブクラス化
	hwnd = stat				 ; メインウィンドウのハンドル
	set_message MYWM_TRAYICON   ; MYWM_TRAYICON を取得するように設定

	; メッセージパラメータ用変数
	dup msg,  msgval.1		  ; メッセージが格納される変数
	dup wprm, msgval.2		  ; wParamパラメータが格納される変数
	dup lprm, msgval.3		  ; lParamパラメータが格納される変数

