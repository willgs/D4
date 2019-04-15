# frozen_string_literal: true

# Start
require 'simplecov'
require 'simplecov-console'
SimpleCov.formatter = SimpleCov::Formatter::Console
SimpleCov.start
require_relative 'verifier_test'
