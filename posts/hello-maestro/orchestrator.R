library(maestro)

schedule <- build_schedule()

orch_result <- run_schedule(
  schedule,
  orch_frequency = "1 day"
)
