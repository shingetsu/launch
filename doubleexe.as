	;���傭�Ɨl�́wHSP�̗��Z�H�H�x(http://yokohama.cool.ne.jp/chokuto/)�́u��d�N����h�~���Ă݂� ACT-1�v�T���v���X�N���v�g�ł��B

	#module "doubleexe";--------���łɋN������Ă��邩�ǂ������擾���郂�W���[��---------

	; �~���[�e�b�N�X�I�u�W�F�N�g�̖��O�̒�`
	; (�A�v���P�[�V�����ŗL�̖��O�ɂ���K�v������܂�)
	#define  MUTEX_NAME  "ShinGETsu_launcher"

	; ���łɋN������Ă��邩�ǂ������擾���閽��
	#deffunc GetDoubleExe
	mref stt, 64				 ; �V�X�e���ϐ� stat

	sdim mutexname, 256
	mutexname = MUTEX_NAME	   ; ��������ʂ̕ϐ��Ɋi�[����

	; �~���[�e�b�N�X�I�u�W�F�N�g�̍쐬
	pm.0 = 0					 ; �Z�L�����e�B�w��(�f�t�H���g�w��)
	pm.1 = 0					 ; ���L���w��t���O
	getptr pm.2, mutexname	   ; ���O��\��������̃|�C���^
	dllproc "CreateMutexA", pm, 3, D_KERNEL@
	hMutex = stat				; �I�u�W�F�N�g�n���h��

	; �I�u�W�F�N�g���쐬����Ă������ǂ����̔���
	geterrcode				   ; GetLastError�֐��ɂ��G���[�R�[�h�擾
	if stat == 183 {			 ; ERROR_ALREADY_EXISTS
		stt = 1				  ; ���łɓ������O�̃I�u�W�F�N�g�����݂���
	} else {
		stt = 0				  ; �I�u�W�F�N�g���V�����쐬���ꂽ
	}
	return

	; �I�u�W�F�N�g�n���h���̃N���[�Y(�I�����Ɏ������s)
	#deffunc QuitDoubleExe  onexit
	if hMutex {
		dllproc "CloseHandle", hMutex, 1, D_KERNEL@
	}
	return

	#global