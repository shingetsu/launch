	;###################################################################
	; 拡張エラー情報取得モジュール  apierr.as
	;###################################################################

	#module "apierr"

	; apierr モジュール初期化ルーチン
	#deffunc _init_apierr
	mref stt, 64		  ; stat
	mref rfst, 65		 ; refstr
	; refstr のアドレスを取得
	getptr pstr, rfst
	; pfn.0 に GetLastError  関数のアドレスを取得
	dll_getfunc  pfn.0, "GetLastError", D_KERNEL@
	; pfn.1 に FormatMessage 関数のアドレスを取得
	dll_getfunc  pfn.1, "FormatMessageA", D_KERNEL@
	return

	;===================================================================
	; geterrcode
	; スレッドエラーコード取得し stat に格納
	;===================================================================
	#deffunc geterrcode
	ll_callfnv@  pfn.0
	stt = dllret@		  ; 戻り値を stat に格納
	return

	;===================================================================
	; geterrtext  n1
	;	n1 : エラーコード
	; エラーコードからエラーテキストを取得し refstr に格納
	; stat は取得文字列サイズ(stat=0 の時エラー)
	;===================================================================
	#deffunc geterrtext int
	mref code			  ; エラーコード
	pm = 0x00001000, 0, code, 0, pstr, 4096, 0
	ll_callfunc@  pm, 7, pfn.1
	stt = dllret@		  ; 戻り値を stat に格納
	return

	#global

	_init_apierr		   ; モジュールの初期化