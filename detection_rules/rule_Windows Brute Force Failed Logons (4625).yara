
FROM logs-*
| WHERE event.code == "4625"
  AND event.outcome == "failure"
  AND winlog.event_data.LogonType == "3"
| STATS failure_count = COUNT(),
        show_users = VALUES(user.name),
        first_seen = MIN(@timestamp),
        last_seen  = MAX(@timestamp)
  BY source.ip
| WHERE failure_count >= 8
| SORT failure_count DESC