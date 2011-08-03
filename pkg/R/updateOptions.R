
## set properties of a logger or a handler
updateOptions <- function(container, ...)
  UseMethod('updateOptions')

updateOptions.character <- function(container, ...) {
  ## container is really just the name of the container
  updateOptions.environment(getLogger(container), ...)
}

updateOptions.environment <- function(container, ...) {
  ## the container is a logger
  config <- list(...);
  if (! 'level' %in% names(config))
    config[['level']] = loglevels['INFO']
  for (key in names(config))
    if(key != "") container[[key]] <- config[[key]]
  invisible()
}
