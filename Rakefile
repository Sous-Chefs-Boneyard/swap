require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

desc 'Run all tests'
task test: [:spec, :rubocop]

task default: [:test]
