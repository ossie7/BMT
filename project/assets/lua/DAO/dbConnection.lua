require "luasql"

--== Initialisation
local sqlite = luasql.sqlite3()
local DB = sqlite:connect( "DB_NAME.sqlite" )

--== Basics
-- assert( DB:execute("create table if not exists TABLE_NAME( field1 varchar(10), field2 smallint, etc )" ))
-- assert( DB:execute("insert into TABLE_NAME values( field1, field2, etc)") )
-- assert( DB:execute("delete from TABLE_NAME where id > 1"))

-- Dump a table to output
local result = DB:execute("select * from TABLE_NAME")
local row = {}
while result:fetch(row) do
    print( table.concat(row, '|') )
end
result:close()
result = nil

--== Clean up
DB:close()
sqlite:close()