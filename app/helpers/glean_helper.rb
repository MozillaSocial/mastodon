require 'json'
require 'securerandom'
require 'logger'

GLEAN_EVENT_MOZLOG_TYPE = 'glean-server-event';

module GleanHelper
    class ApiEventsServerEvent
        def initialize(application_id, app_display_version, app_channel, logger_name, user_agent, ip_address, user_id, account_id, path, controller, method, status_code)
           @application_id=application_id
           @app_display_version=app_display_version
           @app_channel=app_channel
           @logger_name=logger_name
           @user_agent=user_agent
           @ip_address=ip_address
           @user_id=user_id
           @account_id=account_id
           @path=path
           @controller=controller
           @method=method
           @status_code=status_code
        end
        def record()
            t = Time.now
            t_utc = t.utc
            event_payload = {
            "client_info" => {
                "telemetry_sdk_build" => 'glean_parser v7.2.2.dev8+g91d4c811',
                "first_run_date" => 'Unknown',
                "os" => 'Unknown',
                "os_version" => 'Unknown',
                "architecture" => 'Unknown',
                "app_build" => 'Unknown',
                "app_display_version" => @app_display_version,
                "app_channel" => @app_channel,
            },
            "ping_info" => {
                "seq" => 0, # this is required, however doesn't seem to be useful in server context
                "start_time" => t_utc,
                "end_time" => t_utc
            },
            "metrics" => {
                        "event" => {
                          "extras" => {
                            "user_id" => @user_id,
                            "account_id" => @account_id,
                            "path"=> @path,
           "controller"=> @controller,
           "method"=> @method,
           "status_code"=> @status_code
                          }
                        },
                      }
                    }
            serialized_event_payload = event_payload.to_json
            ping = {
                "document_namespace" => @application_id,
                "document_type" => 'api-events',
                "document_version" => '1',
                "document_id" => SecureRandom.uuid,
                "user_agent" => @user_agent,
                "ip_address" => @ip_address,
                "payload" => serialized_event_payload,
              }
            logger = Logger.new(STDOUT)
            logger.formatter = proc do |severity, datetime, progname, msg|
              date_format = datetime.to_i
              JSON.dump(Timestamp: "#{date_format}", Logger: "#{@logger_name}", Type: "#{GLEAN_EVENT_MOZLOG_TYPE}", Severity:"#{severity.ljust(5)}", Pid:"#{Process.pid}", Fields: msg) + "\n"
          end
            logger.info(ping)
        end
    end
end

# include GleanHelper

# GleanHelper::ApiEventsServerEvent.new(
#     "test",
#     "0.0.1",
#     "development",
#     "moso-mastodon-server-glean",
#     "test",
#     "127.0.0.1",
#     "test",
#     "test",
#     "test",
#     "test",
#     "test",
#     "test"
# ).record