if !jasmine?
  throw new Exception("jasmine not laoded!")

class HeadlessReporterResult
  constructor: (name) ->
    @name = name
    @results = []
  print: ->
    JHW.printName(@name)
    for result in @results
      do (result) =>
        JHW.printResult(result)

class jasmine.HeadlessReporter
  constructor: ->
    @results = []
    @failedCount = 0
    @totalDuration = 0.0
    @length = 0
  reportRunnerResults: (runner) ->
    for result in @results
      do (result) =>
        result.print()

    JHW.finishSuite(@totalDuration, @length, @failedCount)
  reportRunnerStarting: (runner) ->
  reportSpecResults: (spec) ->
    if spec.results().passed()
      JHW.specPassed()
    else
      JHW.specFailed()
      failureResult = new HeadlessReporterResult(spec.getFullName())
      for result in spec.results().getItems()
        do (result) =>
          if result.type == 'expect' and !result.passed_
            @failedCount += 1
            failureResult.results.push(result.message)
      @results.push(failureResult)
  reportSpecStarting: (spec) ->
    # something here
  reportSuiteResults: (suite) ->
    suite.startTime ?= new Date()
    @totalDuration += (new Date() - suite.startTime) / 1000.0;

    @length += suite.specs().length
