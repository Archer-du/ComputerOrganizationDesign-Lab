# Author: 2023_COD_TA
# Last_edit: 20230503
# ============================== ��ˮ�� CPU ��ȷ�Բ��Գ��� ==============================
# ������Ϊֻ��������ð�յĲ���
# ��Ҫ��ͨ����simple test�Ļ����Ͻ���
# �ڲ��Խ����󣬼Ĵ�����Ӧ���㣺
# x[i] = i ����i = 10,11,12,13,14,15,16 (ʮ����)
# ����Ĵ�����Ϊ��ʱ�Ĵ���
# ���в��죬���������С i ��ָʾ����Ĳ���
# !!!!!!!!!!!!!!!! �벻Ҫ�޸ı����Գ���Ĵ��� !!!!!!!!!!!!!!!!!!!!!!!
# ======================================================================================

.text
# TEST 10 MEM forwarding
	addi x30, x0, 2
	addi x31, x0, 0
	addi x10, x30, 8

# TEST 11 WB forwarding
	addi x30, x0, -2
	addi x11, x30, 13
	
# TEST 12 both forwarding
	addi x12, x0, 4
	add x12, x12, x12
	addi x12, x12, 4
	
# TEST 13 more instructions
	lui x30, 1
	sw x30, 4(x0)
	lw x13, 4(x0)
	addi x31, x0, 0
	addi x31, x0, 0
	addi x13, x13, -2048
	addi x13, x13, -2035

# TEST 14 WB load use
	lui x30, 1
	sw x30, 4(x0)
	lw x14, 4(x0)
	lui x31, -1
	add x14, x14, x31
	addi x14, x14, 14
	
# TEST 15 x0 test
	addi x0, x0, 4
	addi x15, x0, 5
	add x15, x0, x15
	addi x15, x15, 10
	
# TEST 16 load use
	addi x30, x0, 12
	sw x30, 0(x30)
	lw x29, 12(x0)
	sw x29, 12(x29)
	lw x16, 24(x0)
	addi x16, x16, 4