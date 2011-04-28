function ado_connection=adodb_connect(connection_str, timeout)
% ado_connection = adodb_connect(connection_str, timeout)
%
% Connects to ADO OLEDB using the Microsoft ActiveX Data Source Control
%
% Inputs:
%  connection_str - string containing information needed for connecting to
%   the database. See examples how to connect to large number of different
%   types see:
%   * http://www.connectionstrings.com/ 
%   * http://www.codeproject.com/KB/database/connectionstrings.aspx
%   and many more. A Few example strings for common databases:
%   * MS SQL Server -  PROVIDER=SQLOLEDB; Data Source=myServerAddress; Initial Catalog=myDataBase; User Id=myUsername; Password=myPassword;
%   * MySQL  - driver=MySQL ODBC 3.51 Driver; Server=myServerAddress; Database=myDataBase; UID=username; PWD=password; 
%   * Access - PROVIDER=Microsoft.Jet.OLEDB.4.0; Data Source=C:\mydatabase.mdb;User Id=myUsername; Password=myPassword;
%   * Access 2007 - PROVIDER=Microsoft.ACE.OLEDB.12.0; Data Source=C:\mydatabase.accdb; Persist Security Info=False;
%   * Oracle - PROVIDER=OraOLEDB.Oracle; Data Source=MyOracleDB; User Id=myUsername; Password=myPassword;
%
%  timeout - CommandTimeout in seconds (default=60 seconds if unspecified)
%
% Output:
%   ado_connection - ADO connection object
%

if nargin<2, timeout = 60; end
ado_connection = actxserver('ADODB.Connection'); % Create activeX control
ado_connection.CursorLocation = 'adUseClient';   % Uses a client-side cursor supplied by a local cursor library
ado_connection.CommandTimeout = timeout;         % Specify connection timeout 
ado_connection.Open(connection_str);             % Open connection



