--�����ʦ��ţ���ѯ�ý�ʦ�Ľ�ʦ������
select * from teacher;
create or replace procedure searchTea_1(pid in varchar2,pname out varchar2)
is
begin
  select t.t_name into pname from teacher t where t.t_id=pid;
end;
/

declare
  v_name teacher.t_name%type;
begin
  searchTea_1('060001',v_name);
  dbms_output.put_line(v_name);
end;

--����һ���޲����Ĵ洢���̣������ǰϵͳ��ʱ�䡣
select sysdate from dual;
create or replace procedure printSystTime
is
begin
  dbms_output.put_line(to_char(sysdate,'yyyy-mm-dd'));
end;

begin
    printSystTime();
end;

--execute printSystTime();

--����һ������������Ĵ洢���̣���ָ����ŵĽ�ʦ��ְ�ƽ���һ����
update teacher t set t.t_titleid= t.t_titleid+1 where t.t_id='';
commit;

create or replace procedure upTeacher (pid in char)
is
begin
  update teacher t set t.t_titleid= t.t_titleid+1 where t.t_id=pid;
  commit;
end;

begin
    upTeacher('060001');
end;
--����һ�����������������Ĵ洢���̣�
--���ݸ����Ľ�ʦ�ŷ��ؽ�ʦ���������о�����
select t.t_name,t.t_research from teacher t where t.t_id='060001';

create or replace procedure searchTeacher2 (pid in char,pname out varchar2,preach out varchar2)
is
begin
  select t.t_name,t.t_research into pname,preach from teacher t where t.t_id=pid;
end;

--����
declare
  v_name teacher.t_name%type;
  v_reach teacher.t_research%type;
  v_id char(6) :='060001';
begin
  searchTeacher2(v_id,v_name,v_reach);
  
  dbms_output.put_line('����:' || v_name);
  dbms_output.put_line('�о�����:' || v_reach);
end;

--����һ����������������Ĵ洢���̣�����ĩ�ɼ���70%���㣬�����ء�
create or replace procedure myCalc(pscore in out number)
is
begin
  pscore :=pscore*0.7;
end;
/
declare
  v_score number;
begin
  v_score:=90;
  
  myCalc(v_score);
  
  dbms_output.put_line(v_score);
end;

--ɾ���洢����printSystTime
drop procedure printSystTime;

--�鿴�洢���̵Ĳ�����Ϣ��
--������䲻����SQL��䣬��һ��Oracle��������䣬��˲�����SQL����������
--desc searchteacher2;

--���һ��&id��ʾ���Զ�̬����
begin
  select * from teacher  t where  t.t_id=&tid;
end;
 select * from teacher  t where  t.t_id=&tid;
 
