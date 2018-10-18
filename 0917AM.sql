--1.用户
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
--2.部门
create table sys_dep(
  depid varchar2(32) primary key,
  depname varchar2(32) not null,
  depcreatetime date not null
);
--3.角色
create table sys_role(
  roleid varchar2(32) primary key,
  rolename varchar2(32) not null,
  rolecreatetime date not null
);
--4.菜单
create table sys_menu(
  menuid varchar2(32) primary key,--菜单id
  menuname varchar2(32) not null,--菜单中文名
  menuParentid varchar2(32) not null,--父节点id
  menuUrl varchar2(1000) not null,--路径或者是全限定类名Class.forName()
  menuIcon varchar2(1000) not null,--图标
  menucreatetime date not null,--创建时间
  menuParam varchar2(1000) not null,--参数
  menuisEnable int not null,--控制菜单是否可用
  menuBase int not null,--菜单的权重，数字越大，菜单越靠前
  menuisLeaf int not null,--是否存在子菜单，当数字为0时，表示还有子元素，1表示没有
  menuState int not null,--逻辑删除，当数字为0时，表示删除
  menuTarget1 varchar2(1000) not null,
  menuTarget2 varchar2(1000) not null,
  menuTarget3 varchar2(1000) not null
);
--5.用户和部门
create table depAneUser(
  dauid  varchar2(32) primary key,
  userid varchar2(32) not null,
  depid varchar2(32) not null
);
--6.用户和角色
create table roleAndUser(
  rauid varchar2(32) primary key,
  userid varchar2(32) not null,
  roleid varchar2(32) not null
);
--7.部门和菜单
create depAndMenu(
  damid varchar2(32) primary key,
  depid varchar2(32) not null,
  menuid varchar2(32) not null
);
--8.角色和菜单
create table roleAndMenu(
  ramid varchar2(32) primary key,
  roleid varchar2(32) not null,
  menuid varchar2(32) not null
);
--如何查询用户的权限
--1.从用户登录，获得用户的Id
--2.查找该用户所在的部门和所拥有的角色
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

--用户表和登录表分开
--新建用户表，如何才能一次性的将数据插入到登录表
--触发器
--什么是触发器：触发器就是某个条件成立时，由数据库自动执行的一段代码。
--因此，触发器不需要人为去掉用。

--触发器分为两种
--1.行级触发器
--2.语句级触发器

--语法：
/*
  create or replace trigger 触发器名 触发时间  触发事件
  on 表名
  [foreach row]
  begin
    pl/sql语句
  end;
  
  触发时间：
    1.before:在动作之前
    2.after：在动作之后
    
  触发事件：指那些数据库的动作会触发
    insert
    update
    delete
    
  foreach row:所有的行级触发器加上foreach row
  
  在触发器中，还有两个临时表
  :new表是一个临时表，当新插入数据时，没有进行提交数据临时存放在:new中除了insert 还有一个操作数据也会保存在:new表中，是update
  :old表是一个临时表，当删除数据时，临时存放在:old表中，还有update语句中的要被覆盖的数据
*/
--行级触发器
select * from student;
delete from student s where s.s_id='0807010101';
create or replace trigger demo_1
  before delete 
  on student
  for each row
begin
  dbms_output.put_line('被删除的人是：' || :old.s_name);
end;
select * from title;
insert into title values (11,'ad发生');
create or replace trigger demo_2
  after insert
  on title
  for each row
   begin
     dbms_output.put_line('新添加的职称名字为：' || :new.title_name);
   end;
   
--语句级触发器
create or replace trigger demo_3
before insert or update or delete
on teacher
begin
  if to_char(sysdate,'DY')='星期一' then
    RAISE_APPLICATION_ERROR(-20600,'星期一不能对Teacher表进行修改');
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

--用户自定义函数function
/*
    语法格式
    
    create or replace function 函数名(参数列表 in/out)
    return Oracle的内置数据类型 as
    定义变量
    begin
      
    end;
    
*/
--比如：根据学号查询学生姓名
create or replace function getStuName (v_id in varchar2)
return varchar2 as
  v_name varchar2(100);
begin
    select s.s_name into v_name from student s where s.s_id=v_id;
    return v_name;
end;

--执行getStuName函数
select * from student;
select getStuName('0807010101') from dual;

select u.text from user_source u where u.name=upper('getStuName');
--创建一个带输入和输出参数的存储函数，
--根据给定的教师号返回教师的姓名、性别和研究方向。
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
李飞
v_gender
---------
男
v_research
---------
软件工程技术，智能算法

*/

--锁
--数据中的锁与生活中的锁是同一个概念
/*
  锁是数据库中用来控制共享资源并发访问的机制
  锁是用来保护被修改的数据
  直到提交或回滚事务之后，其他用户才能更新数据
*/
select * from title;
update title t set t.title_name='兼职' where t.title_id=9;
rollback;

select * from v$lock;
--TM锁：表级锁
--TX锁：行级锁
select * from dba_objects o where o.OBJECT_ID=20057
--锁表
--lock table 表名 in 模式名称 mode
--模式名称5种
/*
    1.行共享锁(ROW SHARE)
    2.行排他锁(ROW EXCLUSIVE)
    3.共享锁(SHARE)
    4.共享行排他锁(SHARE ROW EXCLUSIVE)
    5.排他锁(EXCLUSIVE)
*/

--select for update的使用
select * from title t where t.title_id=1 for update;
rollback;

--锁定全表
select * from title for update;--此种写法，对于插入数据是没有阻拦效果的

select * from title t where t.title_id=3 for update wait 3; 

select * from title t where t.title_id=3 for update nowait;

--死锁
--当两个事务互相等待对方释放资源的时候，会形成死锁
--Oracle会自动检测死锁，并通过结束其中一个事务来解决死锁

--查看死锁的SQL语句是什么
--1.查看是否存在死锁的可能
select v.USERNAME,v.LOCKWAIT,v.STATE,v.MACHINE,v.PROGRAM from v$session v where sid in
(select session_id from v$locked_object);

--2.查看一下被死锁的SQL语句
select v.SQL_TEXT from v$sql v where v.HASH_VALUE in(
select v.SQL_HASH_VALUE from v$session v where v.SID in
(select session_id from v$locked_object));

--3.查看死锁的进程
select s.USERNAME,l.OBJECT_ID,l.SESSION_ID,s.SERIAL#,l.ORACLE_USERNAME,
l.OS_USER_NAME,l.PROCESS from v$locked_object l , v$session s
where l.SESSION_ID=s.SID

--4.kill死锁的进程
alter system kill session '95,175';
alter system kill session '137,195';








