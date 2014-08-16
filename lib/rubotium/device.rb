module Rubotium
  class Device
    attr_accessor :testsuite
    attr_reader   :serial, :results
    def initialize(serial, test_runner)
      @runner   = test_runner
      @retry    = 1
      @serial   = serial
      @results  = {}
    end

    def test_runner_name= name
      runner.test_runner = name
    end

    def test_package_name= name
      runner.test_package_name = name
    end

    def run_tests
      raise(NoTestSuiteError, "Please setup test suite before running tests") if testsuite.nil?
      puts "Running tests"
      testsuite.each{|runable_test|
        @results[runable_test.package_name] = []
        puts runable_test.name
        run_count = 0
        puts "TEST: #{runable_test.name}"
        while ((result = runner.run_test(runable_test)) && (result.failed? || result.errored?) && run_count < @retry ) do
            puts "RERUNNING TEST: #{runable_test.name}, STATUS: #{result.status}"
            run_count += 1
          end
        puts "FINISHED with status: #{result.status}"
          @results[runable_test.package_name].push(result)
      }
    end

    private
    attr_reader :runner
  end
end