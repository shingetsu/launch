    ;===========================================================================
    ; ���W���[��  hsgetmsg.as                        ( 2003/02/04 �ŏI�X�V )
    ;
    ;   hsgetmsg.dll���g�p���� Windows ���� HSP �E�B���h�E�ɑ����郁�b�Z�[�W
    ;   ���擾���܂��B
    ;
    ;   ���̃��W���[���� HSP ver2.5 �ȍ~��Ώۂɂ��Ă��܂��B
    ;   ���̃��W���[�����g�p����ɂ� llmod.as ���K�v�ł��B
    ;===========================================================================


    ;===========================================================================
    ; set_subclass
    ;===========================================================================
    ;
    ; �`�撆�̃E�B���h�E���T�u�N���X�����āA���b�Z�[�W�擾�\��Ԃɂ��܂��B
    ; �T�u�N���X�������邱�ƂŁA�E�B���h�E�ɑ����郁�b�Z�[�W���擾���邱�Ƃ�
    ; �ł���悤�ɂȂ�܂��B
    ;
    ; ���s��� stat �̒l
    ;   ���������ꍇ�̓E�B���h�E�n���h�����i�[����܂��B
    ;   ���s�����ꍇ�i����������Ă��Ȃ��Ȃǁj�� 0 �ɂȂ�܂��B
    ;


    ;===========================================================================
    ; get_message
    ;===========================================================================
    ;
    ; ���̖��߂����s����ƁA�擾�������b�Z�[�W�����ۂɃO���[�o���ϐ� msgval ��
    ; �i�[����܂��B�i���̖��߂����s�����܂ł� DLL �����ŕێ�����Ă��܂��B�j
    ; ���b�Z�[�W���Ȃ��ꍇ�� msgval.0 �� 0 ���������܂��B
    ; ���C�����[�v���Ń��b�Z�[�W�ɉ���������������O�Ɏ��s���Ă��������B
    ;
    ; msgval �ɂ͎��̂悤�ɑ������܂��B
    ;   msgval.0 : ���b�Z�[�W���󂯎�����E�B���h�E�̃n���h��
    ;   msgval.1 : ���b�Z�[�W�R�[�h
    ;   msgval.2 : wParam �p�����[�^
    ;   msgval.3 : lParam �p�����[�^
    ;
    ; ���s��� stat �̒l
    ;   ���b�Z�[�W���i�[�����ƁA���b�Z�[�W���󂯎���� HSP �E�B���h�E�� ID ��
    ;   �i�[����܂��B
    ;


    ;===========================================================================
    ; set_message   n1
    ;
    ;   n1 : �ݒ肷�郁�b�Z�[�W
    ;===========================================================================
    ;
    ; �`�撆�̃E�B���h�E���擾���郁�b�Z�[�W��ݒ肵�܂��B
    ; ���̖��߂Őݒ肳�ꂽ���b�Z�[�W���E�B���h�E�ɑ�����ƁA���b�Z�[�W��
    ; DLL �����ŕێ�����܂��B���ۂɃ��b�Z�[�W���擾����ɂ� get_message ���߂�
    ; ���s���܂��B
    ;
    ; ���s���stat�̒l
    ;   ���������ꍇ�� 0 �ɂȂ�܂�
    ;   ���s�����ꍇ�� 1 �ɂȂ�܂�
    ;   �E�B���h�E���T�u�N���X������Ă��Ȃ��ꍇ�� 2 �ɂȂ�܂�
    ;


    ;===========================================================================
    ; set_notify   n1, n2
    ;
    ;   n1 : �ݒ肷��ʒm���b�Z�[�W
    ;   n2 : �ǉ��擾�������
    ;===========================================================================
    ;
    ; �`�撆�E�B���h�E���q�E�B���h�E�i�R���g���[���j���� WM_NOTIFY ���b�Z�[�W
    ; �i���b�Z�[�W�R�[�h�F$4E�j���󂯎�����ۂɁA�ǂ̒ʒm���b�Z�[�W���擾����
    ; ����ݒ肵�܂��B
    ;
    ; ���̖��߂Őݒ肳�ꂽ�ʒm���b�Z�[�W�� WM_NOTIFY ���b�Z�[�W�`���ő����
    ; ���Ƃ��A�ʒm���b�Z�[�W���܂߂Ď擾����܂��B
    ;
    ; get_message ���s��A���b�Z�[�W�ϐ� msgval �ɂ͈ȉ��̂悤�ɑ������܂��B
    ;   msgval.0 : ���b�Z�[�W���󂯎�����E�B���h�E�̃n���h��
    ;   msgval.1 : $4E (WM_NOTIFY���b�Z�[�W)
    ;   msgval.2 : (wParam : �R���g���[���h�c)
    ;   msgval.3 : (lParam : NMHDR�\���̂̃A�h���X)
    ;   (����ȍ~ lParam�̎w��NMHDR�\����)
    ;   msgval.4 : �R���g���[���̃E�B���h�E�n���h��
    ;   msgval.5 : �R���g���[�� ID
    ;   msgval.6 : �R���g���[������̒ʒm���b�Z�[�W
    ;
    ; ���ʒm���b�Z�[�W�ɂ���Ă�NMHDR�\���̂̌�ɏ�񂪊܂܂����̂�����܂�
    ;   �������擾����ɂ� n2 �Ɏ擾������̗ʂ��w�肵�܂��B
    ;   get_message ���s��A(n4�~4)�o�C�g���̏�� msgval.7 �ȍ~�ɑ������܂��B
    ;
    ; ���s���stat�̒l
    ;   ���������ꍇ�� 0 �ɂȂ�܂�
    ;   ���s�����ꍇ�� 1 �ɂȂ�܂�
    ;   �E�B���h�E���T�u�N���X������Ă��Ȃ��ꍇ�� 2 �ɂȂ�܂�
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


    #define GM_DATANUM_MAX     32       ; �P�̃��b�Z�[�W�̏���
    dim msgval, GM_DATANUM_MAX          ; �ꍇ�ɂ���Ă͑傫�ȗ̈悪�K�v�Ȃ̂�
    gm_setret msgval,, GM_DATANUM_MAX   ; ���b�Z�[�W�̏����󂯎��ϐ��̐ݒ�

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
    mref p1             ; reset flag (�T�u�N���X���̉����͂��Ȃ�)
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
    mref p1             ; 0:����  1:�L��
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
    ;                    Copyright (C) 2000-2003  ���傭��
    ;                          EOF  [hsgetmsg.as]
    ;===========================================================================
