# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # add instaniated Glean Logger
  include Glean
  GLEAN = Glean::GleanEventsLogger.new(
    app_id: 'moso-mastodon-backend',
    app_display_version: Mastodon::Version.to_s,
    app_channel: ENV.fetch('RAILS_ENV', 'development'),
    logger_options: $stdout
  )
  # add glean server side logging for controller calls
  around_action :emit_glean

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Localized
  include UserTrackingConcern
  include SessionTrackingConcern
  include CacheConcern
  include DomainControlHelper
  include DatabaseHelper
  include AuthorizedFetchHelper

  helper_method :current_account
  helper_method :current_session
  helper_method :current_theme
  helper_method :single_user_mode?
  helper_method :use_seamless_external_login?
  helper_method :omniauth_only?
  helper_method :sso_account_settings
  helper_method :limited_federation_mode?
  helper_method :body_class_string
  helper_method :skip_csrf_meta_tags?
  helper_method :sso_redirect

  rescue_from ActionController::ParameterMissing, Paperclip::AdapterRegistry::NoHandlerError, with: :bad_request
  rescue_from Mastodon::NotPermittedError, with: :forbidden
  rescue_from ActionController::RoutingError, ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::UnknownFormat, with: :not_acceptable
  rescue_from ActionController::InvalidAuthenticityToken, with: :unprocessable_entity
  rescue_from Mastodon::RateLimitExceededError, with: :too_many_requests

  rescue_from HTTP::Error, OpenSSL::SSL::SSLError, with: :internal_server_error
  rescue_from Mastodon::RaceConditionError, Stoplight::Error::RedLight, ActiveRecord::SerializationFailure, with: :service_unavailable

  rescue_from Seahorse::Client::NetworkingError do |e|
    Rails.logger.warn "Storage server error: #{e}"
    service_unavailable
  end

  before_action :store_referrer, except: :raise_not_found, if: :devise_controller?
  before_action :require_functional!, if: :user_signed_in?

  before_action :set_cache_control_defaults

  skip_before_action :verify_authenticity_token, only: :raise_not_found

  def raise_not_found
    raise ActionController::RoutingError, "No route matches #{params[:unmatched_route]}"
  end

  private

  def public_fetch_mode?
    !authorized_fetch_mode?
  end

  def store_referrer
    return if request.referer.blank?

    redirect_uri = URI(request.referer)
    return if redirect_uri.path.start_with?('/auth')

    stored_url = redirect_uri.to_s if redirect_uri.host == request.host && redirect_uri.port == request.port

    store_location_for(:user, stored_url)
  end

  def require_functional!
    redirect_to edit_user_registration_path unless current_user.functional?
  end

  def skip_csrf_meta_tags?
    false
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  protected

  def truthy_param?(key)
    ActiveModel::Type::Boolean.new.cast(params[key])
  end

  def forbidden
    respond_with_error(403)
  end

  def not_found
    respond_with_error(404)
  end

  def gone
    respond_with_error(410)
  end

  def unprocessable_entity
    respond_with_error(422)
  end

  def not_acceptable
    respond_with_error(406)
  end

  def bad_request
    respond_with_error(400)
  end

  def internal_server_error
    respond_with_error(500)
  end

  def service_unavailable
    respond_with_error(503)
  end

  def too_many_requests
    respond_with_error(429)
  end

  def single_user_mode?
    @single_user_mode ||= Rails.configuration.x.single_user_mode && Account.where('id > 0').exists?
  end

  def use_seamless_external_login?
    Devise.pam_authentication || Devise.ldap_authentication
  end

  def omniauth_only?
    ENV['OMNIAUTH_ONLY'] == 'true'
  end

  def sso_redirect
    "/auth/auth/#{Devise.omniauth_providers[0]}" if ENV['OMNIAUTH_ONLY'] == 'true' && Devise.omniauth_providers.length == 1
  end

  def sso_account_settings
    ENV.fetch('SSO_ACCOUNT_SETTINGS', nil)
  end

  def current_account
    return @current_account if defined?(@current_account)

    @current_account = current_user&.account
  end

  def current_session
    return @current_session if defined?(@current_session)

    @current_session = SessionActivation.find_by(session_id: cookies.signed['_session_id']) if cookies.signed['_session_id'].present?
  end

  def current_theme
    return Setting.theme unless Themes.instance.names.include? current_user&.setting_theme

    current_user.setting_theme
  end

  def body_class_string
    @body_classes || ''
  end

  def respond_with_error(code)
    respond_to do |format|
      format.any  { render "errors/#{code}", layout: 'error', status: code, formats: [:html] }
      format.json { render json: { error: Rack::Utils::HTTP_STATUS_CODES[code] }, status: code }
    end
  end

  def set_cache_control_defaults
    response.cache_control.replace(private: true, no_store: true)
  end

  private

  def emit_glean
    yield
  ensure
    event = {
      'user_id' => current_user&.id,
      'path' => request.fullpath,
      'controller' => controller_name,
      'method' => request.method,
      'status_code' => response.status,
    }
    username = current_user&.account&.username
    domain = current_user&.account&.domain

    handle = nil
    unless username.nil?
      domain = 'mozilla.social' if domain.nil?
      handle = "#{username}@#{domain}"
    end

    GLEAN.backend_object_update.record(
      user_agent: request.user_agent,
      ip_address: request.ip,
      object_type: 'api_request',
      object_state: event.to_json,
      identifiers_adjust_device_id: nil,
      identifiers_fxa_account_id: nil,
      identifiers_mastodon_account_handle: handle,
      identifiers_mastodon_account_id: current_user&.account&.id,
      identifiers_user_agent: request.user_agent
    )
  end
end
