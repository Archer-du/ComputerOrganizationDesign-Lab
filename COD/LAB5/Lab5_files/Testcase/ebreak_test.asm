# Author: 2023_COD_TA
# Last_edit: 20230503
# ============================== ��ˮ�� CPU ��ȷ�Բ��Գ��� ==============================
# ������Ϊebreakʵ������Ĳ���
# �ڵ���ϵ�ʱӦ����x1 = 2
# �������쳣�ָ�����һ��ebreak�ָ����ٴε���ϵ�ʱӦ����x1 = 4
# !!!!!!!!!!!!!!!! �벻Ҫ�޸ı����Գ���Ĵ��� !!!!!!!!!!!!!!!!!!!!!!!
# ======================================================================================

.text
addi x1, x0, 1
add x1, x1, x1
ebreak
addi x1, x1, 1
addi x1, x1, 1
ebreak