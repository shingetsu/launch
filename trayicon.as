	; �g���C�A�C�R���p�̃A�C�R��ID
	#define ID_TRAYICON		 1

	; �g���C�A�C�R���p�̃��b�Z�[�W�R�[�h
	#define MYWM_TRAYICON	   0x1000

	mref bmscr, 67				  ; �E�B���h�E��BMSCR�\����
	tooltext = "ShinGETsu Launcher" ; �c�[���`�b�v�e�L�X�g

	; ���g�̎��s�t�@�C�����擾
	sdim exefile, 260		   ; �t�@�C�������i�[����ϐ�
	pm = 0					  ; NULL
	getptr pm.1, exefile		; �o�b�t�@�A�h���X�擾
	pm.2 = 260				  ; �o�b�t�@�T�C�Y
	dllproc "GetModuleFileNameA", pm, 3, D_KERNEL

	; ���s�t�@�C������A�C�R�����擾
	getptr pm.0, exefile		; �t�@�C����
	pm.1 = 0					; �A�C�R���C���f�b�N�X
	pm.2 = 0					; �傫���A�C�R���͎擾���Ȃ�
	getptr pm.3, hicon		  ; �������A�C�R���̃n���h�����i�[����ϐ�
	pm.4 = 1					; �擾���鐔
	dllproc "ExtractIconExA", pm, 5, D_SHELL

	; NOTIFYICONDATA �\����
	dim  nid, 22
	nid.0 = 88				  ; �\���̃T�C�Y
	nid.1 = bmscr.13			; �E�B���h�E�n���h��
	nid.2 = ID_TRAYICON		 ; �A�C�R��ID
	nid.3 = 1 | 2 | 4		   ; NIF_MESSAGE | NIF_ICON | NIF_TIP
	nid.4 = MYWM_TRAYICON	   ; ���b�Z�[�W�R�[�h
	nid.5 = hicon			   ; �A�C�R���n���h��
	poke nid, 24, tooltext	  ; �c�[���`�b�v������

	; �^�X�N�g���C�ɃA�C�R����ǉ�
	pm.0 = 0					; NIM_ADD
	getptr pm.1, nid			; NOTIFYICONDATA �\���̃A�h���X
	dllproc "Shell_NotifyIconA", pm, 2, D_SHELL

	; �g���C�A�C�R���p���b�Z�[�W���擾����悤�ɃZ�b�g
	set_subclass				; �T�u�N���X��
	hwnd = stat				 ; ���C���E�B���h�E�̃n���h��
	set_message MYWM_TRAYICON   ; MYWM_TRAYICON ���擾����悤�ɐݒ�

	; ���b�Z�[�W�p�����[�^�p�ϐ�
	dup msg,  msgval.1		  ; ���b�Z�[�W���i�[�����ϐ�
	dup wprm, msgval.2		  ; wParam�p�����[�^���i�[�����ϐ�
	dup lprm, msgval.3		  ; lParam�p�����[�^���i�[�����ϐ�

