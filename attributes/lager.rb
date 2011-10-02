default.riak.lager.handlers.lager_console_backend = :info
default.riak.lager.handlers.lager_file_backend = [["/var/log/riak/error.log", :error, 10485760, "$D0", 5],["/var/log/riak/console.log", :info, 10485760, "$D0", 5]]
default.riak.lager.crash_log = "/var/log/riak/crash.log"
default.riak.lager.crash_log_msg_size = 65536
default.riak.lager.crash_log_size = 10485760
default.riak.lager.crash_log_date = "$D0"
default.riak.lager.crash_log_count = 5
default.riak.lager.error_logger_redirect = :true
