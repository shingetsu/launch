	;###################################################################
	; �g���G���[���擾���W���[��  apierr.as
	;###################################################################

	#module "apierr"

	; apierr ���W���[�����������[�`��
	#deffunc _init_apierr
	mref stt, 64		  ; stat
	mref rfst, 65		 ; refstr
	; refstr �̃A�h���X���擾
	getptr pstr, rfst
	; pfn.0 �� GetLastError  �֐��̃A�h���X���擾
	dll_getfunc  pfn.0, "GetLastError", D_KERNEL@
	; pfn.1 �� FormatMessage �֐��̃A�h���X���擾
	dll_getfunc  pfn.1, "FormatMessageA", D_KERNEL@
	return

	;===================================================================
	; geterrcode
	; �X���b�h�G���[�R�[�h�擾�� stat �Ɋi�[
	;===================================================================
	#deffunc geterrcode
	ll_callfnv@  pfn.0
	stt = dllret@		  ; �߂�l�� stat �Ɋi�[
	return

	;===================================================================
	; geterrtext  n1
	;	n1 : �G���[�R�[�h
	; �G���[�R�[�h����G���[�e�L�X�g���擾�� refstr �Ɋi�[
	; stat �͎擾������T�C�Y(stat=0 �̎��G���[)
	;===================================================================
	#deffunc geterrtext int
	mref code			  ; �G���[�R�[�h
	pm = 0x00001000, 0, code, 0, pstr, 4096, 0
	ll_callfunc@  pm, 7, pfn.1
	stt = dllret@		  ; �߂�l�� stat �Ɋi�[
	return

	#global

	_init_apierr		   ; ���W���[���̏�����