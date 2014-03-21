site :opscode

metadata

group :integration do
  cookbook "apt"
  cookbook "yum", "~> 3.0"
  cookbook "yum-epel", "~> 0.3"
  cookbook "minitest-handler"

  # TODO: Remove once fix is merged and released upstream.
  cookbook "java", github: "socrata-cookbooks/java", ref: "d78ce8a0480f82b1cb97d3e5fbe2c023f2819099"
end
