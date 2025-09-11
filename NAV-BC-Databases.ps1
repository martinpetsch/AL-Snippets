# Query all NAV/BC Databases
$server = "server\instance"
$connString = "Server=$server;Database=master;Integrated Security=True;"
$query = "SELECT name, state_desc FROM sys.databases WHERE name LIKE '%NAV%' OR name LIKE '%BC%'"
$conn = New-Object System.Data.SqlClient.SqlConnection $connString
$conn.Open()
$cmd = $conn.CreateCommand()
$cmd.CommandText = $query
$reader = $cmd.ExecuteReader()
$table = New-Object System.Data.DataTable
$table.Load($reader)
$conn.Close()
$table | Format-Table


# Query all NAV/BC Databases including their size
$server = "server\instance"
$connString = "Server=$server;Database=master;Integrated Security=True;"
$query = @"
SELECT d.name,
       d.state_desc,
       CAST(SUM(mf.size) * 8.0 / 1024 AS DECIMAL(18,2)) AS SizeMB
FROM sys.databases d
JOIN sys.master_files mf ON d.database_id = mf.database_id
WHERE d.name LIKE '%NAV%' OR d.name LIKE '%BC%'
GROUP BY d.name, d.state_desc
ORDER BY d.name
"@
$conn = New-Object System.Data.SqlClient.SqlConnection $connString
$conn.Open()
$cmd = $conn.CreateCommand()
$cmd.CommandText = $query
$reader = $cmd.ExecuteReader()
$table = New-Object System.Data.DataTable
$table.Load($reader)
$conn.Close()
$table | Format-Table
