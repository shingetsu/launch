	#define WM_COMMAND	0x0111

	; ���j���[�A�C�e��ID���`
	#define CMD_OPENBBS1	   1	  ;�uBBS ���J���v�A�C�e����ID
	;#define CMD_OPENBBS2	   5
	#define CMD_MINI	   2	  ;�u�ŏ����v�A�C�e����ID
	#define CMD_QUIT	   3	  ;�u�I���v�A�C�e����ID
	;#define CMD_MESSAGE	4	  ;�u���b�Z�[�W�\���v�A�C�e����ID

	;---------------�u�t�@�C���v���j���[�̍쐬-------------------
	dllproc "CreatePopupMenu", pm, 0, D_USER
	hmenufile = dllret			; �u�t�@�C���v���j���[�n���h��

	mesbuf = "BBS ���J��(&O)"
	pm = hmenufile, 0, CMD_OPENBBS1
	getptr pm.3, mesbuf
	dllproc "AppendMenuA", pm, 4, D_USER

	;mesbuf = "BBS(8000) ���J��(&0)"
	;pm = hmenufile, 0, CMD_OPENBBS2
	;getptr pm.3, mesbuf
	;dllproc "AppendMenuA", pm, 4, D_USER

	mesbuf = "�ŏ���(&N)"
	pm = hmenufile, 0, CMD_MINI
	getptr pm.3, mesbuf
	dllproc "AppendMenuA", pm, 4, D_USER

	pm = hmenufile, $800, 0, 0	; ��؂�����w��
	dllproc "AppendMenuA", pm, 4, D_USER

	mesbuf = "�I��(&Q)"
	pm = hmenufile, 0, CMD_QUIT
	getptr pm.3, mesbuf
	dllproc "AppendMenuA", pm, 4, D_USER

	;----------------�u�w���v�v���j���[�̍쐬--------------------
	;dllproc "CreatePopupMenu", pm, 0, D_USER
	;hmenuhelp = dllret			; �u�w���v�v���j���[�n���h��

	;mesbuf = "���b�Z�[�W�\��(&M)"
	;pm = hmenuhelp, 0, CMD_MESSAGE
	;getptr pm.3, mesbuf
	;dllproc "AppendMenuA", pm, 4, D_USER

	;-------------------���j���[�o�[�̍쐬-----------------------
	dllproc "CreateMenu", pm, 0, D_USER
	hmenu = dllret				; ���j���[�n���h��

	mesbuf = "�t�@�C��(&F)"
	pm = hmenu, $10, hmenufile	; �u�t�@�C���v���j���[�ǉ�
	getptr pm.3, mesbuf
	dllproc "AppendMenuA", pm, 4, D_USER

	;mesbuf = "�w���v(&H)"
	;pm = hmenu, $10, hmenuhelp	; �u�w���v�v���j���[�ǉ�
	;getptr pm.3, mesbuf
	;dllproc "AppendMenuA", pm, 4, D_USER

	; �E�B���h�E�̃T�u�N���X��
	set_subclass
	hwnd = stat				   ; HSP�E�B���h�E�̃n���h��
	set_message WM_COMMAND		; �擾���b�Z�[�W�ݒ�

	; ���j���[���E�B���h�E�Ɋ��蓖�Ă�
	pm.0 = hwnd				   ; �E�B���h�E�n���h��
	pm.1 = hmenu				  ; ���j���[�n���h��
	dllproc "SetMenu", pm, 2, D_USER

	; ���j���[���ĕ`��
	pm.0 = hwnd				   ; ���j���[�n���h��
	dllproc "DrawMenuBar", pm, 1, D_USER

	; ���b�Z�[�W�p�����[�^�p�ϐ�
	dup msg,  msgval.1			; ���b�Z�[�W���i�[�����ϐ�
	dup wprm, msgval.2			; wParam�p�����[�^���i�[�����ϐ�
	dup lprm, msgval.3			; lParam�p�����[�^���i�[�����ϐ�

