// Query: Dim_Date
// Source: Generated (not a source file)
// Purpose: Continuous monthly date dimension, Nov 2024 - May 2026
// Key steps: List.Generate to build full month sequence, add Year and Month name columns
// Note: ensures no gaps in the date axis even where source data is missing

let
    StartDate = #date(2024, 11, 1),
    NumberOfMonths = 19, // Nov 2024 to May 2026 inclusive
    DateList = List.Generate(
        () => StartDate,
        each _ <= #date(2026, 5, 1),
        each Date.AddMonths(_, 1)
    ),
    ToTable = Table.FromList(DateList, Splitter.SplitByNothing(), {"Date"}),
    AddYear = Table.AddColumn(ToTable, "Year", each Date.Year([Date])),
    AddMonth = Table.AddColumn(AddYear, "Month", each Date.MonthName([Date])),
    #"Changed Type" = Table.TransformColumnTypes(AddMonth,{{"Month", type text}, {"Year", Int64.Type}, {"Date", type date}})
in
    #"Changed Type"
