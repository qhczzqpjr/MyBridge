 SELECT * FROM Table1
  WHERE (ABS(CAST(
  (BINARY_CHECKSUM(*) *
  RAND()) as int)) % 100) < 10