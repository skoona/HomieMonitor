# ##
# File: spec/support/tasks.rb
#
# Ref: https://github.com/eliotsykes/rails-testing-toolbox/blob/master/tasks.rb
#      https://www.eliotsykes.com/test-rails-rake-tasks-with-rspec
#      https://robots.thoughtbot.com/test-rake-tasks-like-a-boss
#
#
# task.execute to run the task
# task.prerequisites to access the tasks that task depends on
# task.invoke to run the task and its prerequisite tasks
# ##

require "rake"

# Task names should be used in the top-level describe, with an optional
# "rake "-prefix for better documentation. Both of these will work:
#
# 1) describe "foo:bar" do ... end
#
# 2) describe "rake foo:bar" do ... end
#
# Favor including "rake "-prefix as in the 2nd example above as it produces
# doc output that makes it clear a rake task is under test and how it is
# invoked.
module TaskExampleGroup

  def self.included(klass)
    klass.class_eval() do
      let(:task_name) { self.class.top_level_description.sub(/\Arake /, "") }
      let(:tasks) { Rake::Task }

      # Make the Rake task available as `task` in your examples:
      subject(:task) { tasks[task_name] }

      # make them ready for use again
      after(:each) do
        task.all_prerequisite_tasks.each { |prerequisite| tasks[prerequisite].reenable }
        task.reenable
      end
    end
  end # end :included

end


RSpec.configure do |config|

  # Tag Rake specs with `:task` metadata or put them in the spec/tasks dir
  config.define_derived_metadata(:file_path => %r{/spec/rakelib/}) do |metadata|
    metadata[:type] = :task
  end

  config.include TaskExampleGroup, type: :task

  config.before(:suite) do
    # Rails.application.load_tasks

    Dir["rakelib/**/*.rake"].each do |task_resource|
      begin
        load task_resource
      rescue LoadError => e
        puts "[RakeLib] Ignoring Exception for: #{e.class} #{e.message} #{e.backtrace}"
      end
    end
  end

end

