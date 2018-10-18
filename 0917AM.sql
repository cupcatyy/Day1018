--1.�û�
create table sys_user(
  userid varchar2(32) primary key,
  username varchar2(1000) not null  
);

create table sys_login(
  loginid varchar2(32) primary key,
  userid varchar2(32) not null,
  loginname varchar2(1000) not null,
  loginpwd varchar2(30) not null
);
--2.����
create table sys_dep(
  depid varchar2(32) primary key,
  depname varchar2(32) not null,
  depcreatetime date not null
);
--3.��ɫ
create table sys_role(
  roleid varchar2(32) primary key,
  rolename varchar2(32) not null,
  rolecreatetime date not null
);
--4.�˵�
create table sys_menu(
  menuid varchar2(32) primary key,--�˵�id
  menuname varchar2(32) not null,--�˵�������
  menuParentid varchar2(32) not null,--���ڵ�id
  menuUrl varchar2(1000) not null,--·��������ȫ�޶�����Class.forName()
  menuIcon varchar2(1000) not null,--ͼ��
  menucreatetime date not null,--����ʱ��
  menuParam varchar2(1000) not null,--����
  menuisEnable int not null,--���Ʋ˵��Ƿ����
  menuBase int not null,--�˵���Ȩ�أ�����Խ�󣬲˵�Խ��ǰ
  menuisLeaf int not null,--�Ƿ�����Ӳ˵���������Ϊ0ʱ����ʾ������Ԫ�أ�1��ʾû��
  menuState int not null,--�߼�ɾ����������Ϊ0ʱ����ʾɾ��
  menuTarget1 varchar2(1000) not null,
  menuTarget2 varchar2(1000) not null,
  menuTarget3 varchar2(1000) not null
);
--5.�û��Ͳ���
create table depAneUser(
  dauid  varchar2(32) primary key,
  userid varchar2(32) not null,
  depid varchar2(32) not null
);
--6.�û��ͽ�ɫ
create table roleAndUser(
  rauid varchar2(32) primary key,
  userid varchar2(32) not null,
  roleid varchar2(32) not null
);
--7.���źͲ˵�
create depAndMenu(
  damid varchar2(32) primary key,
  depid varchar2(32) not null,
  menuid varchar2(32) not null
);
--8.��ɫ�Ͳ˵�
create table roleAndMenu(
  ramid varchar2(32) primary key,
  roleid varchar2(32) not null,
  menuid varchar2(32) not null
);
--��β�ѯ�û���Ȩ��
--1.���û���¼������û���Id
--2.���Ҹ��û����ڵĲ��ź���ӵ�еĽ�ɫ
create or replace procedure getUserRight(pid in varchar2,menucur out sys_refcursor)
as
begin
select * from sys_menu where 
menuid in
(select menuid from depAndMenu where depid in
(select depid from depAneUser  where userid=pid)
union
select menuid from roleAndMenu where roleid in
(select roleid from roleAndUser where userid=pid));
end;
/

--�û���͵�¼��ֿ�
--�½��û�����β���һ���ԵĽ����ݲ��뵽��¼��
--������
--ʲô�Ǵ�����������������ĳ����������ʱ�������ݿ��Զ�ִ�е�һ�δ��롣
--��ˣ�����������Ҫ��Ϊȥ���á�

--��������Ϊ����
--1.�м�������
--2.��伶������

--�﷨��
/*
  create or replace trigger �������� ����ʱ��  �����¼�
  on ����
  [foreach row]
  begin
    pl/sql���
  end;
  
  ����ʱ�䣺
    1.before:�ڶ���֮ǰ
    2.after���ڶ���֮��
    
  �����¼���ָ��Щ���ݿ�Ķ����ᴥ��
    insert
    update
    delete
    
  foreach row:���е��м�����������foreach row
  
  �ڴ������У�����������ʱ��
  :new����һ����ʱ�����²�������ʱ��û�н����ύ������ʱ�����:new�г���insert ����һ����������Ҳ�ᱣ����:new���У���update
  :old����һ����ʱ����ɾ������ʱ����ʱ�����:old���У�����update����е�Ҫ�����ǵ�����
*/
--�м�������
select * from student;
delete from student s where s.s_id='0807010101';
create or replace trigger demo_1
  before delete 
  on student
  for each row
begin
  dbms_output.put_line('��ɾ�������ǣ�' || :old.s_name);
end;
select * from title;
insert into title values (11,'ad����');
create or replace trigger demo_2
  after insert
  on title
  for each row
   begin
     dbms_output.put_line('����ӵ�ְ������Ϊ��' || :new.title_name);
   end;
   
--��伶������
create or replace trigger demo_3
before insert or update or delete
on teacher
begin
  if to_char(sysdate,'DY')='����һ' then
    RAISE_APPLICATION_ERROR(-20600,'����һ���ܶ�Teacher������޸�');
  end if;
end;

delete from teacher;

create or replace trigger addUser
  after insert 
  on sys_user
  for each row
begin
  --:new
  insert into sys_login values (sys_guid(),:new.userid,:new.username,'111111');
  --commit;
end;
select * from sys_user;
select * from sys_login;

insert into sys_user values (sys_guid(),'bill');
/*
create table sys_user(
  userid varchar2(32) primary key,
  username varchar2(1000) not null  
);

create table sys_login(
  loginid varchar2(32) primary key,
  userid varchar2(32) not null,
  loginname varchar2(1000) not null,
  loginpwd varchar2(30) not null
);
*/

create table demo_4 as select * from student where 1=2;
select * from demo_4;

create or replace procedure getStuname(pid in varchar2,pname out varchar2)
as
begin
  null;
end;

--�û��Զ��庯��function
/*
    �﷨��ʽ
    
    create or replace function ������(�����б� in/out)
    return Oracle�������������� as
    �������
    begin
      
    end;
    
*/
--���磺����ѧ�Ų�ѯѧ������
create or replace function getStuName (v_id in varchar2)
return varchar2 as
  v_name varchar2(100);
begin
    select s.s_name into v_name from student s where s.s_id=v_id;
    return v_name;
end;

--ִ��getStuName����
select * from student;
select getStuName('0807010101') from dual;

select u.text from user_source u where u.name=upper('getStuName');
--����һ�����������������Ĵ洢������
--���ݸ����Ľ�ʦ�ŷ��ؽ�ʦ���������Ա���о�����
create or replace function searchTech1(v_id in teacher.t_id%type,v_GENDER out teacher.t_gender%type,v_RESEARCH out teacher.t_research%type)
return teacher.t_name%type
is
  v_name teacher.t_name%type;
begin
  select t.t_name,t.t_gender,t.t_research into v_name,v_GENDER,v_RESEARCH from teacher t where t.t_id=v_id;
  return v_name;
end;

select * from teacher;
select searchTech1('060001') from dual;

/*
SQL> var v_name varchar2(30);
SQL> var v_gender varchar2(10);
SQL> var v_research varchar2(1000);
SQL> execute :v_name :=searchTech1('060001',:v_gender,:v_research);

PL/SQL procedure successfully completed

v_name
---------
���
v_gender
---------
��
v_research
---------
������̼����������㷨

*/

--��
--�����е����������е�����ͬһ������
/*
  �������ݿ����������ƹ�����Դ�������ʵĻ���
  ���������������޸ĵ�����
  ֱ���ύ��ع�����֮�������û����ܸ�������
*/
select * from title;
update title t set t.title_name='��ְ' where t.title_id=9;
rollback;

select * from v$lock;
--TM��������
--TX�����м���
select * from dba_objects o where o.OBJECT_ID=20057
--����
--lock table ���� in ģʽ���� mode
--ģʽ����5��
/*
    1.�й�����(ROW SHARE)
    2.��������(ROW EXCLUSIVE)
    3.������(SHARE)
    4.������������(SHARE ROW EXCLUSIVE)
    5.������(EXCLUSIVE)
*/

--select for update��ʹ��
select * from title t where t.title_id=1 for update;
rollback;

--����ȫ��
select * from title for update;--����д�������ڲ���������û������Ч����

select * from title t where t.title_id=3 for update wait 3; 

select * from title t where t.title_id=3 for update nowait;

--����
--������������ȴ��Է��ͷ���Դ��ʱ�򣬻��γ�����
--Oracle���Զ������������ͨ����������һ���������������

--�鿴������SQL�����ʲô
--1.�鿴�Ƿ���������Ŀ���
select v.USERNAME,v.LOCKWAIT,v.STATE,v.MACHINE,v.PROGRAM from v$session v where sid in
(select session_id from v$locked_object);

--2.�鿴һ�±�������SQL���
select v.SQL_TEXT from v$sql v where v.HASH_VALUE in(
select v.SQL_HASH_VALUE from v$session v where v.SID in
(select session_id from v$locked_object));

--3.�鿴�����Ľ���
select s.USERNAME,l.OBJECT_ID,l.SESSION_ID,s.SERIAL#,l.ORACLE_USERNAME,
l.OS_USER_NAME,l.PROCESS from v$locked_object l , v$session s
where l.SESSION_ID=s.SID

--4.kill�����Ľ���
alter system kill session '95,175';
alter system kill session '137,195';








