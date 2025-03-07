    ;===========================================================================
    ; モジュール  hsgetmsg.as                        ( 2003/02/04 最終更新 )
    ;
    ;   hsgetmsg.dllを使用して Windows から HSP ウィンドウに送られるメッセージ
    ;   を取得します。
    ;
    ;   このモジュールは HSP ver2.5 以降を対象にしています。
    ;   このモジュールを使用するには llmod.as が必要です。
    ;===========================================================================


    ;===========================================================================
    ; set_subclass
    ;===========================================================================
    ;
    ; 描画中のウィンドウをサブクラス化して、メッセージ取得可能状態にします。
    ; サブクラス化をすることで、ウィンドウに送られるメッセージを取得することが
    ; できるようになります。
    ;
    ; 実行後の stat の値
    ;   成功した場合はウィンドウハンドルが格納されます。
    ;   失敗した場合（初期化されていないなど）は 0 になります。
    ;


    ;===========================================================================
    ; get_message
    ;===========================================================================
    ;
    ; この命令を実行すると、取得したメッセージが実際にグローバル変数 msgval に
    ; 格納されます。（この命令が実行されるまでは DLL 内部で保持されています。）
    ; メッセージがない場合は msgval.0 に 0 が代入されます。
    ; メインループ中でメッセージに応じた処理をする前に実行してください。
    ;
    ; msgval には次のように代入されます。
    ;   msgval.0 : メッセージを受け取ったウィンドウのハンドル
    ;   msgval.1 : メッセージコード
    ;   msgval.2 : wParam パラメータ
    ;   msgval.3 : lParam パラメータ
    ;
    ; 実行後の stat の値
    ;   メッセージが格納されると、メッセージを受け取った HSP ウィンドウの ID が
    ;   格納されます。
    ;


    ;===========================================================================
    ; set_message   n1
    ;
    ;   n1 : 設定するメッセージ
    ;===========================================================================
    ;
    ; 描画中のウィンドウが取得するメッセージを設定します。
    ; この命令で設定されたメッセージがウィンドウに送られると、メッセージが
    ; DLL 内部で保持されます。実際にメッセージを取得するには get_message 命令を
    ; 実行します。
    ;
    ; 実行後のstatの値
    ;   成功した場合は 0 になります
    ;   失敗した場合は 1 になります
    ;   ウィンドウがサブクラス化されていない場合は 2 になります
    ;


    ;===========================================================================
    ; set_notify   n1, n2
    ;
    ;   n1 : 設定する通知メッセージ
    ;   n2 : 追加取得する情報量
    ;===========================================================================
    ;
    ; 描画中ウィンドウが子ウィンドウ（コントロール）から WM_NOTIFY メッセージ
    ; （メッセージコード：$4E）を受け取った際に、どの通知メッセージを取得する
    ; かを設定します。
    ;
    ; この命令で設定された通知メッセージが WM_NOTIFY メッセージ形式で送られ
    ; たとき、通知メッセージも含めて取得されます。
    ;
    ; get_message 実行後、メッセージ変数 msgval には以下のように代入されます。
    ;   msgval.0 : メッセージを受け取ったウィンドウのハンドル
    ;   msgval.1 : $4E (WM_NOTIFYメッセージ)
    ;   msgval.2 : (wParam : コントロールＩＤ)
    ;   msgval.3 : (lParam : NMHDR構造体のアドレス)
    ;   (これ以降 lParamの指すNMHDR構造体)
    ;   msgval.4 : コントロールのウィンドウハンドル
    ;   msgval.5 : コントロール ID
    ;   msgval.6 : コントロールからの通知メッセージ
    ;
    ; ※通知メッセージによってはNMHDR構造体の後に情報が含まれるものがあります
    ;   これらを取得するには n2 に取得する情報の量を指定します。
    ;   get_message 実行後、(n4×4)バイト分の情報が msgval.7 以降に代入されます。
    ;
    ; 実行後のstatの値
    ;   成功した場合は 0 になります
    ;   失敗した場合は 1 になります
    ;   ウィンドウがサブクラス化されていない場合は 2 になります
    ;


    ;---------------------------------------------------------------------------
    #uselib "hsgetmsg.dll"
    #func gm_setret      gm_setret      1
    #func gm_setwndproc  gm_setwndproc  0
    #func gm_setoption   gm_setoption   0
    #func gm_setmessage  gm_setmessage  0
    #func gm_setnotify   gm_setnotify   0
    #func gm_getmessage  gm_getmessage  0
    #func gm_switch      gm_switch      0
    #func gm_delmessage  gm_delmessage  0


    #define GM_DATANUM_MAX     32       ; １つのメッセージの情報量
    dim msgval, GM_DATANUM_MAX          ; 場合によっては大きな領域が必要なので
    gm_setret msgval,, GM_DATANUM_MAX   ; メッセージの情報を受け取る変数の設定

    #define global MOSETM_WPARAMLOW    1
    #define global MOSETM_WPARAMHIGH   2
    #define global MOSETM_WPARAM       3   ; MOSETM_WPARAMLOW | MOSETM_WPARAMHIGH
    #define global MOSETM_LPARAMLOW    4
    #define global MOSETM_LPARAMHIGH   8
    #define global MOSETM_LPARAM      $C   ; MOSETM_LPARAMLOW | MOSETM_LPARAMHIGH
    #define global MOSETM_RETVALUE   $10

    #module "hsgetmsg" ;--------------------------------------------------------

    ;---------------------------------------------------------------------------
    ; set_subclass
    ;---------------------------------------------------------------------------
    #deffunc set_subclass int
    mref p1             ; reset flag (サブクラス化の解除はしない)
    mref stt, 64
    mref bmscr, 67
    gm_setwndproc@ bmscr.13, bmscr.18 + 1, p1
    if stat : stt = 0 : else : stt = bmscr.13
    return

    ;---------------------------------------------------------------------------
    ; set_message
    ;---------------------------------------------------------------------------
    #deffunc set_message int
    mref p1             ; message code
    mref bmscr, 67
    gm_setmessage@ bmscr.13, p1
    return

    ;---------------------------------------------------------------------------
    ; set_notify
    ;---------------------------------------------------------------------------
    #deffunc set_notify int, int
    mref p1             ; notify code
    mref p2, 1          ; extra size
    mref bmscr, 67
    gm_setnotify@ bmscr.13, p1, p2
    return

    ;---------------------------------------------------------------------------
    ; get_message
    ;---------------------------------------------------------------------------
    #deffunc get_message
    gm_getmessage@
    stt--
    return


    ;---------------------------------------------------------------------------
    ; get_wndrect
    ;---------------------------------------------------------------------------
    #deffunc get_wndrect val, int
    mref p1, 16         ; RECT structure
    mref p2, 1          ; window handle
    pm = p2
    getptr pm.1, p1
    dllproc "GetWindowRect", pm, 2, D_USER@
    return


    ;---------------------------------------------------------------------------
    ; set_forwnd
    ;---------------------------------------------------------------------------
    #deffunc set_forwnd int
    mref p1             ; window handle
    if p1 == 0 : mref bmscr, 67 : p1 = bmscr.13
    pm = $2000, 0, 0, 0         ; SPI_GETFOREGROUNDLOCKTIMEOUT
    getptr pm.2, p2
    gosub *@f
    pm = $2001, 0, 0, 0         ; SPI_SETFOREGROUNDLOCKTIMEOUT
    gosub *@f
    pm = p1
    dllproc "SetForegroundWindow", pm, 1, D_USER@
    pm = $2001, 0, p2, 0
    gosub *@f
    return
*@
    dllproc "SystemParametersInfoA", pm, 4, D_USER@
    return


    ;---------------------------------------------------------------------------
    ; enable_wnd
    ;---------------------------------------------------------------------------
    #deffunc enable_wnd int, int, int
    mref p1             ; 0:無効  1:有効
    mref p2, 1          ; window handle (or HSP Object ID)
    mref p3, 2          ; 0:window  1:HSP Object
    if p3 {
        _hspobjhandle p2 : p2 = stat
    } else {
        if p2 == 0 : mref bmscr, 67 : p2 = bmscr.13
    }
    pm = p2, p1
    dllproc "EnableWindow", pm, 2, D_USER@
    return


    #global ;-------------------------------------------------------------------

    mref stt@hsgetmsg, 64

    ;===========================================================================
    ;                    Copyright (C) 2000-2003  ちょくと
    ;                          EOF  [hsgetmsg.as]
    ;===========================================================================
