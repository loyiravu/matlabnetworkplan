function adodb_update_blob (ado_connection, selectRecordSql, column, file)
%ado_update_blob - updates a record in a database with a blob (binary large
% object). Sends a blob (JPG-file, MAT-file, ...) from the file defined 
% by the file name to the specific column of a record defined by select
% statement
% 
% Inputs:
%   ado_connection - open connection to ADO OLEDB ActiveX Data Source Control
%   selectRecordSql - select statement defining a record. For example:
%     "SELECT TOP(1) * FROM TABLE1 WHERE RECORD_ID=11"
%   column - column name where to upload the blob
%   file - filename from current directory or a full path and filename of
%   the blob file.
%

%% Initialize ADO command object
ado_command = actxserver ('ADODB.Command');     % Instantiate ADO command object
ado_command.CommandText      = selectRecordSql; % Communicate the sql command string to the command object
ado_command.ActiveConnection = ado_connection;  % Communicate the connection object to the command object

%% Initialize ADO record set object
ado_recordset = actxserver ('ADODB.Recordset'); % Instantiate ADO record set object
ado_recordset.CursorType = 'adOpenStatic';      % Client-side cursors can only be static
ado_recordset.LockType   = 'adLockOptimistic';  % The lock type must not be read-only, since we want to stream (write) to the record set 
ado_recordset.Open (ado_command);               % Communicate the command object to the record set object and open the record set object

%% Open  ADO stream object
ado_stream = actxserver ('ADODB.Stream');       % Instantiate ADO stream object
ado_stream.Type = 'adTypeBinary';               % The stream transports binary data
ado_stream.Open;                                % Open the stream object
ado_stream.LoadFromFile(file);                  % Load the file content into the stream object

%% Populate the current record with the blob
% Use the stream's read method to populate the specified field of the current record with the blob 
ado_recordset.Fields.Item(column).Value = ado_stream.Read;
ado_recordset.Update                            % Update the record set (write the blob to the database)
 
%% Terminate objects
ado_stream.Close;                               % Close the stream object
ado_recordset.Close;                            % Close record set object