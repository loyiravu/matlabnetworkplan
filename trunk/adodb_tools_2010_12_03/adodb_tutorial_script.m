%% Tutorial for adodb_toolbox Package
% *By Jarek Tuszynski*
%
% Package adodb_toolbox allows communication with different types of 
% databases through Microsoft's  ADO (ActiveX Data Objects) OLEDB component.
% The package was designed to work on Microsoft SQL Server, Oracle, Microsoft 
% Access, MySQL, other databases. 
% 
% This package can connect to dozen different database types, perform wide 
% range of different query types and convert results to MATLAB Struct data  
% structures as well as regular cell tables. Matlab struct output uses 
% similar format as used by xml_io_tools and csv2struct libraries. Reading
% and writing BLOB objects is supported.
%
% This package can be studied, modified, customized, rewritten and used in  
% other packages without any limitations. All code is included and
% documented. Software is distributed under BSD Licence (included).   
%
%% Credit
% Parts of this code were based on or inspired by:
% * Tim Myers oledb*.m functions
% * Martin Furlan's adodb package
% * Joerg Buchholz's myblob package
%
%% Change History
% * 2010-12-03 - original version


%% Licence
% The package is distributed under BSD Licence
format compact; % viewing preference
clear variables;
type('BSD_Licence.txt')

%% Access: Open connection to MS Access file
% See websites below for syntax of the connection strings
%   * http://www.connectionstrings.com/ 
%   * http://www.codeproject.com/KB/database/connectionstrings.aspx
DB = adodb_connect('PROVIDER=Microsoft.Jet.OLEDB.4.0; Data Source=adotest.mdb;');

%% Access: Read single record from DB
record6 = adodb_query(DB, 'select top 1 * from TestTable where office=6');
disp(record6)

%% Access: Read multiple records from DB
[Struct Table] = adodb_query(DB, 'select * from TestTable');
disp('Output in in struct format:')
disp(Struct)
disp('')
disp('Output in in table format:')
disp(Table)

%% Access: Struct output provides more intuitive interface
for i = 1:length(Struct.lastname)
  fprintf('%s, %s, %s, %i\n', Struct.lastname{i}, Struct.firstname{i}, ...
                              Struct.profession{i}, Struct.office{i});
end

%% Access: Delete record and verify that number of records decresed
before = adodb_query(DB, 'select count(*) as num_rec from TestTable');
adodb_query(DB, 'delete from TestTable where office=6');
after  = adodb_query(DB, 'select count(*) as num_rec from TestTable');
fprintf('Number of records before deletion is %i, and after is %i\n', ...
  before.num_rec, after.num_rec);

%% Access: Insert record and verify that number of records incresed
sql = 'INSERT INTO TestTable (LASTNAME, FIRSTNAME, PROFESSION, OFFICE) VALUES (''%s'', ''%s'', ''%s'', %i) ';
sql = sprintf(sql, record6.lastname,   record6.firstname, ...
                   record6.profession, record6.office);
adodb_query(DB, sql);
after  = adodb_query(DB, 'select count(*) as num_rec from TestTable');
fprintf('Number of records after insertion is %i\n', after.num_rec);

%% Access: Struct output default column labels
% In case column labeld can not be deduced from select statement
% adodb_query will use A, B, C, ... convention, similat to Excel
x = adodb_query(DB, 'select count(*), max(office) from TestTable');
disp(x)

%% Access: Close DB connection
DB.release;

%% MS SQL: Initialize MS SQL database 
cn_str = 'PROVIDER=SQLOLEDB; Data Source=TNWG01A-C0006\SFIIntl; initial catalog=SFIANALYSIS; User ID=english; password=poland';
DB = adodb_cn(cn_str, 240);

%% MS SQL: Create TEMP table
sql = ['CREATE TABLE TEMP ( ',...  
         'blob    varbinary(max), ',...
         'name    varchar(64)',...
       ');'];
adodb_query(DB, sql); 

%% MS SQL: Insert two new records 
adodb_query(DB, ['insert into TEMP (name) values (''football''); ',...
                 'insert into TEMP (name) values (''baseball''); ']); 
[~, Table] = adodb_query(DB, 'select * from TEMP');
disp(Table);
 
%% MS SQL: Update one of the records to add a blob          
selectRecordSql = 'SELECT TOP(1) * FROM TEMP WHERE name=''football'''; 
fname = 'football.jpg';
imwrite(imread(fname),fname); % copy file to current directry
adodb_update_blob(DB, selectRecordSql, 'blob', fname);
[~, Table] = adodb_query(DB, 'select * from TEMP');
disp(Table);

%% MS SQL: Read a blob from the database and store it to the hard disk
x = adodb_query(DB, selectRecordSql);
fid = fopen('MyFootball.jpg', 'wb');  
fwrite(fid, x.blob, 'uint8');     % dump the raw binary to the hard disk 
fclose(fid);
I = imread('MyFootball.jpg');     % read it as an image
imshow(I);

%% MS SQL: Run statement with multiple queries 
sql = 'Select count(*) from TEMP;    select * from TEMP';
[Struct Table] = adodb_query(DB, sql);
disp('Output in in struct format:')
disp(Struct)
disp('Output in in table format:')
disp(Table)

%% MS SQL: Run statement with multiple queries with Pref.MultipleQuery = true flag
Pref = []; Pref.MultipleQuery = true;
[Struct Table] = adodb_query(DB, sql, Pref);
disp('Output of query 1 in struct format:')
disp(Struct{1})
disp('Output of query 1 in table format:')
disp(Table{1})
disp('Output of query 2 in struct format:')
disp(Struct{2})
disp('Output of query 2 in table format:')
disp(Table{2})

%% MS SQL: Run multi-query sql with an incorect second statement  
% First correct statement did not modify database
sql = ['Update TEMP set name=''basketball'' where name=''baseball''; ',...
       'select WrongName from TEMP'];
try
  x = adodb_query(DB, sql);
catch ME
  disp(ME.message);
end
[~, TEMP] = adodb_query(DB, 'select * from TEMP');
disp('Output in table format:')
disp(TEMP)

%% MS SQL: Calling Microsoft SQL Server stored procedures 
% Calling build in stored procedure xp_msver
Struct = adodb_query(DB, 'EXEC xp_msver');
for i = 1:11
  fprintf('%20s = %s\n', Struct.name{i}, Struct.character_value{i});
end

%% MS SQL: Delete table TEMP and close DB connection
adodb_query(DB, 'DROP TABLE "TEMP"'); 
DB.release;



