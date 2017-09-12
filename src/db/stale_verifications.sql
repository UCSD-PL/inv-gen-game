-- Output format: stale id|replacement id
-- WARNING: These do not take into account the timeout column.

select verifydata.id, latest_ind.id
from verifydata
left outer join (
  select
    id,
    config,
    json_extract(payload, "$.workers") as workers,
    json_extract(payload, "$.lvls") as lvls,
    max(time) as max_time
  from verifydata
  where json_extract(config, "$.mode") = "individual"
  group by config, workers, lvls
) as latest_ind
on verifydata.config = latest_ind.config
  and json_extract(verifydata.payload, "$.workers") = latest_ind.workers
  and json_extract(verifydata.payload, "$.lvls") = latest_ind.lvls
where verifydata.time < latest_ind.max_time;

select verifydata.id, latest_combined_exp.id
from verifydata
left outer join (
  select
    id,
    config,
    json_extract(payload, "$.lvls") as lvls,
    max(time) as max_time
  from verifydata
  where json_extract(config, "$.mode") = "combined"
    and json_extract(config, "$.tag") like "%-exp-le-%"
  group by config
) as latest_combined_exp
on json_remove(verifydata.config, "$.workers") =
  json_remove(latest_combined_exp.config, "$.workers")
  and json_extract(verifydata.payload, "$.lvls") = latest_combined_exp.lvls
where verifydata.time < latest_combined_exp.max_time;
