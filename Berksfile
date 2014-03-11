site :opscode

metadata

group :integration do
  cookbook "apt"
  cookbook "yum", "~> 3.0"
  cookbook "yum-epel", "~> 0.3"
  cookbook "minitest-handler"

  # TODO: Remove once fix is merged and released upstream.
  cookbook "erlang", github: "hectcastro/erlang", branch: "COOK-4422"
end
