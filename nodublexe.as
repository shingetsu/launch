	#include "llmod.as"
	#include "apierr.as"		 ; エラーコード取得モジュール

	#module ;--------すでに起動されているかどうかを取得するモジュール---------

	; ミューテックスオブジェクトの名前の定義
	; (アプリケーション固有の名前にする必要があります)
	#define  MUTEX_NAME  "ShinGETsu_Launcher"

	; すでに起動されているかどうかを取得する命令
	#deffunc GetDoubleExe
	mref stt, 64				 ; システム変数 stat

	sdim mutexname, 256
	mutexname = MUTEX_NAME	   ; いったん別の変数に格納する

	; ミューテックスオブジェクトの作成
	pm.0 = 0					 ; セキュリティ指定(デフォルト指定)
	pm.1 = 0					 ; 所有権指定フラグ
	getptr pm.2, mutexname	   ; 名前を表す文字列のポインタ
	dllproc "CreateMutexA", pm, 3, D_KERNEL@
	hMutex = stat				; オブジェクトハンドル

	; オブジェクトが作成されていたかどうかの判別
	geterrcode				   ; GetLastError関数によるエラーコード取得
	if stat == 183 {			 ; ERROR_ALREADY_EXISTS
		stt = 1				  ; すでに同じ名前のオブジェクトが存在する
	} else {
		stt = 0				  ; オブジェクトが新しく作成された
	}
	return

	; オブジェクトハンドルのクローズ(終了時に自動実行)
	#deffunc QuitDoubleExe  onexit
	if hMutex {
		dllproc "CloseHandle", hMutex, 1, D_KERNEL@
	}
	return

	#global ;------------------------モジュール終わり-------------------------

	GetDoubleExe
	if stat {
		dialog "すでに起動されています。"
		end
	}
	stop