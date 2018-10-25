module REQUIRED_ENV
  class MissingEnvironmentVariable < StandardError; end

  module_function

  def [](variable)
    ENV[variable] || raise(MissingEnvironmentVariable, "Missing environment variable #{variable.inspect}")
  end
end
