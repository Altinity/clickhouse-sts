-- lua script for outputting wrk results as clickhouse-benchmark compatible json

done = function(summary, latency, requests)

  filename = os.getenv("CHSTS_OUTPUT_JSON")

  if filename == nil then
      return
  end
  file = io.open(filename, 'w')

  file:write(string.format("{\n"))
  -- same format as clickhouse-benchmark
  file:write(string.format("\"statistics\": {\n"))
  file:write(string.format("\"QPS\": %f,\n",         summary["requests"] * 1000000 / summary["duration"] ))
  file:write(string.format("\"num_queries\": %d,\n", summary["requests"] ))
  file:write(string.format("\"MiBPS_result\": %f\n", summary["bytes"] * 1000000 / summary["duration"] )) 
  file:write(string.format("},\n"))
  file:write(string.format("\"query_time_percentiles\": {\n"))
  file:write(string.format("\"0\": %f,\n",    latency:percentile(0)/1000000 ))
  file:write(string.format("\"10\": %f,\n",   latency:percentile(10)/1000000 ))
  file:write(string.format("\"20\": %f,\n",   latency:percentile(20)/1000000 ))
  file:write(string.format("\"30\": %f,\n",   latency:percentile(30)/1000000 ))
  file:write(string.format("\"40\": %f,\n",   latency:percentile(40)/1000000 ))
  file:write(string.format("\"50\": %f,\n",   latency:percentile(50)/1000000 ))
  file:write(string.format("\"60\": %f,\n",   latency:percentile(60)/1000000 ))
  file:write(string.format("\"70\": %f,\n",   latency:percentile(70)/1000000 ))
  file:write(string.format("\"80\": %f,\n",   latency:percentile(80)/1000000 ))
  file:write(string.format("\"90\": %f,\n",   latency:percentile(90)/1000000 ))
  file:write(string.format("\"95\": %f,\n",   latency:percentile(95)/1000000 ))
  file:write(string.format("\"99\": %f,\n",   latency:percentile(99)/1000000 ))
  file:write(string.format("\"99.9\": %f,\n", latency:percentile(99.9)/1000000 ))
  file:write(string.format("\"99.99\": %f\n", latency:percentile(99.99)/1000000 ))
  file:write(string.format("},\n"))

   -- plus some extras provided by wrk
  file:write(string.format("\"summary\": {\n"))
  file:write(string.format("\"duration\": %d,\n", summary["duration"]))
  file:write(string.format("\"requests\": %d,\n", summary["requests"]))
  file:write(string.format("\"errors\": %d,\n", summary["errors"]["connect"] + summary["errors"]["read"] + summary["errors"]["write"] + summary["errors"]["status"] + summary["errors"]["timeout"] ))
  file:write(string.format("\"bytes\": %d\n",     summary["bytes"]))
  file:write(string.format("},\n"))
  file:write(string.format("\"requests\": {\n"))
  file:write(string.format("\"min\": %d,\n",  requests["min"]))
  file:write(string.format("\"max\": %d,\n",  requests["max"]))
  file:write(string.format("\"mean\": %f,\n", requests["mean"]))
  file:write(string.format("\"stdev\": %f\n", requests["stdev"]))
  file:write(string.format("},\n"))
  file:write(string.format("\"latency\": {\n"))
  file:write(string.format("\"min\": %d,\n",  latency["min"]))
  file:write(string.format("\"max\": %d,\n",  latency["max"]))
  file:write(string.format("\"mean\": %f,\n", latency["mean"]))
  file:write(string.format("\"stdev\": %f\n", latency["stdev"]))
  file:write(string.format("},\n"))
  file:write(string.format("\"errors\": {\n"))
  file:write(string.format("\"connect\": %d,\n", summary["errors"]["connect"] ))
  file:write(string.format("\"read\": %d,\n",    summary["errors"]["read"]    ))
  file:write(string.format("\"write\": %d,\n",   summary["errors"]["write"]   ))
  file:write(string.format("\"status\": %d,\n",  summary["errors"]["status"]  ))
  file:write(string.format("\"timeout\": %d\n",  summary["errors"]["timeout"] ))
  file:write(string.format("}\n"))
  file:write(string.format("}\n"))

  file:close()
end
