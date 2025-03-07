;ちょくと様の『HSPの裏技？？』(http://yokohama.cool.ne.jp/chokuto/) より、サンプルコード等を頂いております。

	#include "llmod.as"
	#include "apierr.as"
	#include "doubleexe.as"
	#include "hsgetmsg.as"
	#include "menu.as"
	#include "trayicon.as"

	screen 0,280,150
	;screen 1,280,160,1
	;width 280,150
	cls 1
	title "新月 ランチャー"
	onexit *gotray

	GetDoubleExe ;二重起動防止
	if stat {
		dialog "すでに起動しています。"
		end
	}

	exec "WScript start-shingetsu.vbs",1
	;exec "mount-shingetsu.bat",1
	;exec "start-shingetsu.bat",1

*mainloop
	get_message
	if msgval {
		if msg == WM_COMMAND {
			gosub *lb_on_command
		} else if msg == MYWM_TRAYICON {
			gosub *lb_tray
		}
	} else {
		wait 10
	}
	goto *mainloop

*lb_on_command
	; メニュー以外から送られた場合は何もしない
	if lprm != 0 : return

	; 選択されたメニューアイテムID
	itemid = wprm & $FFFF

	if itemid == CMD_OPENBBS {
		exec "http://localhost:8000",16
	}
	if itemid == CMD_MINI {
		gsel 0, -1
	}
	if itemid == CMD_QUIT {
		exec "Wscript stop-shingetsu.vbs",1
		;exec "stop-shingetsu.bat",1
		goto *lb_quit
		;end
	}
	;if itemid == CMD_MESSAGE {
	;	dialog "メニュー作成のテストです", 0, "メッセージ表示"
	;}
	return

*lb_tray
	; タスクトレイからメッセージが送られた場合の処理
	;   wParam パラメータはタスクトレイのアイコンID
	;   lParam パラメータはマウスメッセージ(WM_LBUTTONDOWNなど)
	if lprm == 0x0202 {		 ; WM_LBUTTONUP
		gsel 0, 1
	}
	if lprm == 0x0205 {		 ; WM_RBUTTONUP
		gsel 0, -1
	}
	return

*lb_quit
	; 終了時の処理(トレイアイコンの削除、アイコンの破棄)
	; NOTIFYICONDATA 構造体(cbSize, uID のみセット)
	dim  nid, 22
	nid.0 = 88				  ; 構造体サイズ(=88)
	nid.1 = hwnd				; ウィンドウハンドル
	nid.2 = 1				   ; アイコンID(1に固定)

	; タスクトレイからアイコンを削除
	pm.0 = 2					; NIM_DELETE
	getptr pm.1, nid			; NOTIFYICONDATA 構造体アドレス
	dllproc "Shell_NotifyIconA", pm, 2, D_SHELL

	; アイコンの破棄
	dllproc "DestroyIcon", hicon, 1, D_USER

	end

*gotray
	gsel 0, -1
	goto *mainloop

;*stopshingetsu
;	screen 2,140,75
;	cls 1
;	mes "　終了作業中です。"
	end