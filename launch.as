;���傭�Ɨl�́wHSP�̗��Z�H�H�x(http://yokohama.cool.ne.jp/chokuto/) ���A�T���v���R�[�h���𒸂��Ă���܂��B

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
	title "�V�� �����`���["
	onexit *gotray

	GetDoubleExe ;��d�N���h�~
	if stat {
		dialog "���łɋN�����Ă��܂��B"
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
	; ���j���[�ȊO���瑗��ꂽ�ꍇ�͉������Ȃ�
	if lprm != 0 : return

	; �I�����ꂽ���j���[�A�C�e��ID
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
	;	dialog "���j���[�쐬�̃e�X�g�ł�", 0, "���b�Z�[�W�\��"
	;}
	return

*lb_tray
	; �^�X�N�g���C���烁�b�Z�[�W������ꂽ�ꍇ�̏���
	;   wParam �p�����[�^�̓^�X�N�g���C�̃A�C�R��ID
	;   lParam �p�����[�^�̓}�E�X���b�Z�[�W(WM_LBUTTONDOWN�Ȃ�)
	if lprm == 0x0202 {		 ; WM_LBUTTONUP
		gsel 0, 1
	}
	if lprm == 0x0205 {		 ; WM_RBUTTONUP
		gsel 0, -1
	}
	return

*lb_quit
	; �I�����̏���(�g���C�A�C�R���̍폜�A�A�C�R���̔j��)
	; NOTIFYICONDATA �\����(cbSize, uID �̂݃Z�b�g)
	dim  nid, 22
	nid.0 = 88				  ; �\���̃T�C�Y(=88)
	nid.1 = hwnd				; �E�B���h�E�n���h��
	nid.2 = 1				   ; �A�C�R��ID(1�ɌŒ�)

	; �^�X�N�g���C����A�C�R�����폜
	pm.0 = 2					; NIM_DELETE
	getptr pm.1, nid			; NOTIFYICONDATA �\���̃A�h���X
	dllproc "Shell_NotifyIconA", pm, 2, D_SHELL

	; �A�C�R���̔j��
	dllproc "DestroyIcon", hicon, 1, D_USER

	end

*gotray
	gsel 0, -1
	goto *mainloop

;*stopshingetsu
;	screen 2,140,75
;	cls 1
;	mes "�@�I����ƒ��ł��B"
	end