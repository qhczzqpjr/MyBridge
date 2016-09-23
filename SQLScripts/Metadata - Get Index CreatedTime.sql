select crdate, i.name, object_name(o.id)
from sysindexes i
   join sysobjects o ON o.id = i.id
where i.name='IX_BBrg_BackOffice_Corporates_Ticker'
order by crdate desc 