	;================================================================================
	;���W���[�� llmod
	;ver 1.11
	;	loadlib.dll���g�����W���[��
	;================================================================================


	;�g����
	;================================================================================
	; getptr v1,v2
	;
	;  v1 : �|�C���^������ϐ�
	;  v2 : �|�C���^���擾����ϐ�
	;================================================================================
	;
	;<>����
	; v2�Ɏw�肵���ϐ��̃|�C���^��v1�ɑ�����܂��B
	;

	;================================================================================
	; dllproc "s1",v2,n3,n4
	;
	;  s1 : �֐���
	;  v2 : �֐��ɓn�����������������l�ϐ�
	;  n3 : �����̐�
	;  n4 : ll_libload�Ń��[�h����dll�̃n���h��
	;================================================================================
	;
	;<>����
	; n4�Ɏw�肵��dll����s1�̊֐����g�p���܂��B
	; �֐��̕Ԃ�l�̓O���[�o���ϐ�dllret�ɑ������܂��B
	; llmod���ł͎�p��dll�����[�h����Ă��āA����dll���g�p����ꍇ��
	; �ȉ��̐��l���g���Ċ֐����g�p�ł��܂��B
	;	DLL��
	;	kernel32.dll	0 (D_KERNEL)
	;	user32.dll	1 (D_USER)
	;	shell32.dll	2 (D_SHELL)
	;	comctl32.dll	3 (D_COMCTL)
	;	comdlg.dll	4 (D_COMDLG)
	;	gdi32.dll	5 (D_GDI)
	;
	;<>��
	;(1)
	;	ll_libload dll,"user32"		;user32.dll�����[�h
	;	s="test"
	;	getptr p,s
	;	prm=0,p,p,0
	;	dllproc "MessageBoxA",prm,4,dll
	;	mes dllret
	;	ll_libfree dll
	;
	;(2)
	;	s="test2"
	;	getptr p,s
	;	prm=0,p,p,0
	;	dllproc "MessageBoxA",prm,4,D_USER
	;	mes dllret
	;





	;#uselib "loadlib.dll"
	;#func	ll_getptr	ll_getptr	1
	;#func	ll_peek		ll_peek		1
	;#func	ll_peek1	ll_peek1	1
	;#func	ll_peek2	ll_peek2	1
	;#func	ll_peek4	ll_peek4	1
	;#func	ll_poke		ll_poke		1
	;#func	ll_poke1	ll_poke1	0
	;#func	ll_poke2	ll_poke2	0
	;#func	ll_poke4	ll_poke4	0
	;#func	ll_libload	ll_libload	5
	;#func	ll_libfree	ll_libfree	0
	;#func	ll_getproc	ll_getproc	5
	;#func	ll_callfunc	ll_callfunc	1
	;#func	ll_callfnv	ll_callfnv	0
	;#func	ll_retset	ll_retset	1
	;#func	ll_bin		ll_bin		$87
	;#func	ll_str		ll_str		$83


	;dllproc�p
	#define	global D_KERNEL		0
	#define	global D_USER		1
	#define	global D_SHELL		2
	#define	global D_COMCTL		3
	#define	global D_COMDLG		4
	#define	global D_GDI		5


	;�O���[�o���ϐ�
	dllret=0


	;module����>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	#module "llmod"


	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;dll_getfunc
	;................................................................................
	#deffunc dll_getfunc val,str,int
	mref _v1,16		;func
	mref _v2,33		;funcname
	mref _v3,2		;dll

	if _v3 & $ffffff00 = 0 : _v3=mjrdll._v3
	ll_getproc@ _v1,_v2,_v3
	if _v1=0 : dialog "can not find '"+_v2+"'\ndll="+_v3
	return



	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;getptr
	;getptr p,var
	;�ϐ�var�̃|�C���^��p�ɑ��
	;................................................................................
	#deffunc getptr val,val
	mref _v1,16		;pointer
	mref _v2,1025		;var

	if (_v2&$ffff=2) : mref _v3,25 : else mref _v3,17
	ll_getptr@ _v3
	_v1=dllret@
	return



	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;_init_llmod
	;�悭�g��DLL�����[�h���Ă���
	;(LoadLibrary��load����DLL��HSP�I�����Ɏ����I�ɊJ�������)
	;................................................................................
	#deffunc _init_llmod

	if mjrdll : return

	sdim lcl_s,64,16
	ll_retset@ dllret@

	lcl_s.D_KERNEL	="kernel32"
	lcl_s.D_USER	="user32"
	lcl_s.D_SHELL	="shell32"
	lcl_s.D_COMCTL	="comctl32"
	lcl_s.D_COMDLG	="comdlg32"
	lcl_s.D_GDI	="gdi32"

	repeat 6
		ll_libload@ mjrdll.cnt,lcl_s.cnt
	loop

	#define F_SendMessage		0
	#define F_CreateWindowEx	1
	#define F_GetActiveWindow	2

	lcl_s="SendMessageA","CreateWindowExA","GetActiveWindow"
	repeat 3
		ll_getproc@ mjrfunc.cnt, lcl_s.cnt, mjrdll.D_USER
	loop

	alloc lcl_s,64
	mref stt,64		;�ϐ�stt�͂�����stat�����ɂ��Ă���

	gosub _init_obj_hnds		;�� _cls�p

	return


	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;dllproc
	;................................................................................
	#deffunc dllproc str,val,int,int
	mref funcname,32
	mref prms,17
	mref prm_n,2
	mref dll_no,3

	if dll_no & $ffffff00 : dllret@=dll_no : else  dllret@=mjrdll.dll_no

	ll_getproc@ func,funcname,dllret@
	if func {
		ll_callfunc@ prms,prm_n,func
		stt=dllret@
	} else {
		dialog "can not find '"+funcname+"'\ndll="+dll_no
		getkey a, 16 : if a : end
	}
	return


	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;getmjrdll
	;................................................................................
	#deffunc getmjrdll val,int
	mref v1,16
	mref v2,1
	v1=mjrdll.v2
	return

	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;getmjrfunc
	;................................................................................
	#deffunc getmjrfunc val,int
	mref v1,16
	mref v2,1
	v1=mjrfunc.v2
	return





	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;_init_obj_hnds
	;Window�n���h���̏�����(_cls�p)
	;................................................................................
*_init_obj_hnds
	alloc obj_hnds,4*64	;HSP�Ɠ���64�܂łɂ��Ă���
				;������1��1�̃E�B���h�E�ł͂Ȃ��S�ẴE�B���h�E��64��
	return

	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;_cls
	;���W���[���ō����control��HSP�̃I�u�W�F�N�g��S�ăN���A����
	;................................................................................
	#deffunc _cls int
	mref v1

	func=mjrfunc.F_SendMessage
	prm.1=16,0,0
	repeat 64
		prm=obj_hnds.cnt
		if prm : ll_callfunc@ prm,4,func
	loop
	gosub _init_obj_hnds
	cls v1

	return








	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;_get_instance
	;instance�̎擾
	;................................................................................
	#deffunc _get_instance val
	mref v1,16
	mref bmscr,67
	v1=bmscr.14
	return

	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;_get_active_window
	;active window�̎擾
	;................................................................................
	#deffunc _get_active_window val
	mref v1,16
	ll_callfnv@ mjrfunc.F_GetActiveWindow
	v1=dllret@
	return

	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;sendmsg
	;SendMessage
	;................................................................................
	#deffunc sendmsg val
	mref v1,16

	ll_callfunc@ v1,4,mjrfunc.F_SendMessage
	stt=dllret@
	return


	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;setwndlong
	;SetWindowLong
	;................................................................................
	#deffunc setwndlong val,int
	mref v1,16
	mref v2,1

	;#define GWL_WNDPROC         (-4)
	;#define GWL_HINSTANCE       (-6)
	;#define GWL_HWNDPARENT      (-8)
	;#define GWL_STYLE           (-16)
	;#define GWL_EXSTYLE         (-20)
	;#define GWL_USERDATA        (-21)
	;#define GWL_ID              (-12)

	if v2 {
		lcl_s="G" : a=2		;GetWindowLong�ɂ��� (�ߖ�)
	} else {
		lcl_s="S" : a=3		;SetWindowLong�ɂ��� (�ߖ�)
	}
	lcl_s+="etWindowLongA"
	dllproc lcl_s,v1,a,D_USER

	return


	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;_null_sep_str
	;................................................................................
	#deffunc _null_sep_str val,int
	mref v1,24
	mref v2,1
	strlen L,v1 : a=0 : prm=0
	repeat L
		peek a,v1,cnt
		if a=v2 : poke v1,cnt,0 : prm+
	loop
	stt=prm
	return


	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;_makewnd
	;CreateWindowEx
	;................................................................................
	#deffunc _makewnd val,str

	mref handle,16	;�n���h��������ϐ�
			;handle.0 x���W  handle.1 y���W
			;handle.2 ��     handle.3 ����
			;handle.4 �X�^�C��
			;handle.5 �e�E�B���h�E�̃n���h��
			;handle.6 dwExStyle
			;�������Ă���
	mref s2,33	;classname
	mref bmscr,67


	obj_hnds_n=-1
	repeat 64
		if obj_hnds.cnt=0 : obj_hnds_n=cnt : break
	loop
	if obj_hnds_n=-1 : stt=-1 : return		;�� _cls�p

	if handle.2=0 : handle.2=bmscr.29
	if handle.3=0 : handle.3=bmscr.30

	prm=handle.6	;dwExStyle
	lcl_s=s2
	getptr prm.1,lcl_s
	lcl_s2=""
	getptr prm.2,lcl_s2

	prm.3=handle.4,  handle.0 ,handle.1 ,  handle.2 ,handle.3 ,   0,0,0,0
	if handle.5 : prm.8=handle.5 : else prm.8=bmscr.13	;parent window
	_get_instance prm.10

	ll_callfunc@ prm,12,mjrfunc.F_CreateWindowEx
	handle=dllret@

	obj_hnds.obj_hnds_n=handle			;�� _cls�p

	if prm.7<bmscr.31 : a=bmscr.31 : else a=prm.7
	pos csrx, csry+a				;�J�����g�|�W�V������ݒ�

	prm=handle,-12,0x1000+obj_hnds_n
	setwndlong prm					;control ID��handle�Ɠ����l�ɂ���

	stt=0

	return


	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;_is_wnd
	;................................................................................
	#deffunc _is_wnd int
	mref v1

	dllproc "IsWindow",v1,1,D_USER

	return

	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;_hspobjhandle
	;HSP��ObjectID����n���h���𒲂ׂ�stat�ɑ��
	;................................................................................
	#deffunc _hspobjhandle int
	mref v1		;HSP�̃I�u�W�F�N�g��ID
	mref bmscr,67

	if (v1<0)|(v1>63) : stt=0 : else {
		v1 +=41
		stt=bmscr.v1
	}

	return


	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;_hspobjid
	;�n���h������HSP��ObjectID�𒲂ׂ�stat�ɑ��
	;................................................................................
	#deffunc _hspobjid int
	mref v1		;handle of window
	mref bmscr,67

	stt=-1
	repeat 64,41
		if bmscr.cnt=v1 : stt=cnt-41 : break
	loop

	return


	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;_objsel
	;................................................................................
	#deffunc _objsel int
	mref v1			;hwnd

	if v1=-1 {					;ver 1.1�`
		mref bmscr,67
		dllproc "GetFocus",a,0,D_USER
		if stat=bmscr.13 : stt=-1 : return
		a=stat
		_hspobjid a
		if stat!-1 : a=stat
		stt=a
	}else{
		a=v1
		_hspobjhandle a
		if stat : a=stat
		dllproc "SetFocus",a,1,D_USER
	}

	return



	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;_clrobj
	;................................................................................
	#deffunc _clrobj int,int
	mref v1,0		;hwnd
	mref v2,1

	a=v1
	_hspobjhandle a
	if stat : clrobj v1 : return
	;#define WM_CLOSE	16
	prm=a,16,0,0
	ll_callfunc@ prm,4,mjrfunc.F_SendMessage
	repeat 64
		if obj_hnds.cnt=a : obj_hnds.cnt=0 : break
	loop
	stt=dllret@

	return


	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;charupper
	;�ϐ����̉p����啶���ɕϊ�
	;................................................................................
	#deffunc charupper val
	mref v1,1024
	dllproc "CharUpperA",v1.7,1,D_USER
	return


	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;charlower
	;�ϐ����̉p�����������ɕϊ�
	;................................................................................
	#deffunc charlower val
	mref v1,1024
	dllproc "CharLowerA",v1.7,1,D_USER
	return


	#undef F_SendMessage
	#undef F_CreateWindowEx
	#undef F_GetActiveWindow

	;module�I���>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	#global

	_init_llmod		;139�s�@�悭�g��DLL�����[�h���Ă���
