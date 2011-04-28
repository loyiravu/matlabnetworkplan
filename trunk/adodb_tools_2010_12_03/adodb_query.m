function [Struct Table] = adodb_query(ado_connection, sql, Pref)
% [Struct Table] = adodb_query(cn, sql)
%
% adoledb_query    Executes the sql statement against the connection
%                  ado_connection
%
% Inputs:
%   ado_connection - open connection to ADO OLEDB ActiveX Data Source Control
%   sql            - SQL statement to be executed
%   Pref           - preferentes allowing customization of the function
%     Pref.MultipleQuery - default false - Allow support for multiple queries.
%       If true than results will be stored as a cell array with one call
%       for each nonempty recordset. If false than only first recordset
%       will be returned.
%     DPref.UseTrans - default false - use "Begin Transaction" & "Commit
%       Transaction" to bracket the querry and use Rollback in case of an
%       error. Use this if using multiple queries in a single statement and
%       want to rollback results of an early query in case latter query
%       fails.
%     DPref.NumTries - default 1 - Number of tries to use in case of an
%       error. Works only if DPref.UseTrans = false. pauses for 10 sec in
%       between tries. Usefull in situations with unreliable connection to
%       the database.
%
% Output
%   Struct         - query results in struct (or array of structs) format
%   Table          - query results table (or array of tables) format
%
% Notes: Convert cells to strings using char. Convert cells to numeric
% data using cell2mat() for ints or double(cell2mat()) for floats
%

%% Handle Properties argument
DPref.MultipleQuery = false;
DPref.UseTrans      = false;
DPref.NumTries      = 1;
if (nargin>2)
  if (isfield(Pref, 'MultipleQuery' )), DPref.MultipleQuery = Pref.MultipleQuery;  end
  if (isfield(Pref, 'UseTrans'      )), DPref.UseTrans      = Pref.UseTrans;       end
  if (isfield(Pref, 'NumTries'      )), DPref.NumTries      = Pref.NumTries;       end
end

%% Run Querry
if (DPref.UseTrans)        % Use Transaction for your queries
  ado_connection.BeginTrans;
  try
    ado_recordset = ado_connection.Execute(sql);
    ado_connection.CommitTrans;
  catch ME
    ado_connection.RollbackTrans;
    rethrow(ME);           % After rollback throw an error
  end
elseif (DPref.NumTries==1) % No transactions single try
  ado_recordset = ado_connection.Execute(sql);
else                       % No transactions multiple tries
  OK = 0;                  % Initialize operation as failed
  for iTry = 1:DPref.NumTries
    try
      ado_recordset = ado_connection.Execute(sql);
      OK = 1;              % Mark operation as succesfull ...
      break                % ... and stop trying
    catch ME               % Catch errors
      pause(10);           % 10 second pause and try again
    end
  end
  if (~OK),
    rethrow(ME);           % If operation did not succedded than throw an error
  end
end

%% Parse Recordsat
iSet = 1;
Struct{iSet} = [];                   % initialize space for output
Table {iSet} = [];
while (~isempty(ado_recordset))      % loop through all ado_recordsets
  if (ado_recordset.State && ado_recordset.RecordCount>0)
    table = ado_recordset.GetRows';  % retrieve data from recordset
    result = [];
    Fields = ado_recordset.Fields;   % retrive all Fields with column names
    for col = 1:Fields.Count         % loop through all columns
      ColumnName = Fields.Item(col-1).Name; % get column name
      name = genvarname(lower(ColumnName)); % convert it to a valid MATLAB field name
      ColumnName = regexprep(ColumnName, 'Expr\d\d\d\d', ''); % MS Access uses Expr1000 etc. when column name can not be deduced
      if (isempty(ColumnName)), 
        name = char('A'-1+col);      % if column without name than use A, B, C, ... as column names
      end 
      if (size(table,1)==1)          % is table a vector ?
        Res = table{col};
        if (numel(Res)==0 || strcmpi(Res, 'N/A') || isnan(all(Res))), Res=[]; end
      else                           % is table a matrix?
        Res = table(:,col);
      end
      result.(name) = Res;
    end
    Struct{iSet} = result;
    Table {iSet} = table;
    iSet = iSet+1;
  end
  try
    ado_recordset = ado_recordset.NextRecordset(); % go to the next recordsat
  catch  %#ok<CTCH> % some DB do not support NextRecordset
    break;
  end
end

%% In single query mode return only the first nonempty recordset
if (~DPref.MultipleQuery),
  Struct = Struct{1};
  Table  = Table{1};
end 

