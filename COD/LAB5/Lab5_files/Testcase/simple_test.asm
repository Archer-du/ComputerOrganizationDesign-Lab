# Author: 2023_COD_TA
# Last_edit: 20230503
# ============================== ��ˮ�� CPU ��ȷ�Բ��Գ��� ==============================
# ������Ϊ����������ð�������ð�յĲ���
# �������� CPU ��ȷʵ�֣�ֱ�Ӽ���μĴ���������ɱ�����
# �ڲ��Խ����󣬼Ĵ�����Ӧ���㣺
# x[i] = i ����i = 1,2,3,4,5,6,7,8,9
# ����Ĵ�����Ϊ��ʱ�Ĵ���
# ���в��죬���������С i ��ָʾ����Ĳ���
# !!!!!!!!!!!!!!!! �벻Ҫ�޸ı����Գ���Ĵ��� !!!!!!!!!!!!!!!!!!!!!!!
# ======================================================================================

.text

# TEST 1 addi test
	addi x30, x0, 2
	addi x31, x0, 0
	# addi x31, x0, 0Ϊ�����Ե����ݣ��������ð��
	addi x31, x0, 0
	addi x31, x0, 0
	addi x30, x30, -3
	addi x31, x0, 0
	addi x31, x0, 0
	addi x31, x0, 0
	addi x1, x30, 2

# TEST 2 add test
	addi x30, x0, -3
	addi x29, x0, 4
	addi x31, x0, 0
	addi x31, x0, 0
	addi x31, x0, 0
	add x2, x29, x30
	addi x31, x0, 0
	addi x31, x0, 0
	addi x31, x0, 0
	add x2, x2, x2

# TEST 3 write first test
	addi x30, x0, 2
	addi x31, x0, 0
	addi x31, x0, 0
	addi x3, x30, 1
	
# TEST 4 write first x0 test
	addi x0, x0, 1
	addi x31, x0, 0
	addi x31, x0, 0
	addi x4, x0, 4

# TEST 5 lui test I
	lui x5, 1		# x5 = 4096
	addi x31, x0, 0
	addi x31, x0, 0
	addi x5, x5, -2048	# x5 = 2048
	addi x31, x0, 0
	addi x31, x0, 0
	addi x5, x5, -2043	# x5 = 5
	
# TEST 6 lui test II
	lui x6, -1		# x6 = -4096
	addi x31, x0, 0
	addi x31, x0, 0
	addi x6, x6, 2047	# x6 = -2049
	addi x31, x0, 0
	addi x31, x0, 0
	addi x6, x6, 2047	# x6 = -2
	addi x31, x0, 0
	addi x31, x0, 0
	addi x6, x6, 8		# x6 = 6

# TEST 7 auipc test
	auipc x7, 1		# x7 = 0x000040b0
	lui x30, -4		# x30 = 0xffffc000
	addi x31, x0, 0
	addi x31, x0, 0
	add x7, x7, x30		# x7 = 0x0b0
	addi x31, x0, 0
	addi x31, x0, 0
	addi x7, x7, -169	# x7 = 7
	
# TEST 8 lw sw test I
	addi x30, x0, 8
	addi x31, x0, 0
	addi x31, x0, 0
	sw x30, 4(x0)
	addi x31, x0, 0
	addi x31, x0, 0
	lw x8, -4(x30)
	
# TEST 9 lw sw test II
	addi x30, x0, 8
	addi x31, x0, 0
	sw x30, 12(x0)
	lw x9, 4(x30)
	addi x31, x0, 0
	addi x31, x0, 0
	addi x9, x9, 1