# frozen_string_literal: true

require 'simplecov'

class CoveragePercentageFormatter
  def format(result)
    File.write(output_file, "#{result.covered_percent.round(2)}%")
  end

  private

  def output_file
    File.join(SimpleCov.coverage_path, 'coverage_percentage.txt')
  end
end

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    CoveragePercentageFormatter,
  ],
)

SimpleCov.start 'rails' do
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/spec/' # for rspec

  enable_coverage :branch
end
