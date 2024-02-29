# frozen_string_literal: true

class Api::V1::Admin::StatusesController < Api::BaseController
  # modeled on api/v1/admin/accounts_controller.rb

  include Authorization
  include AccountableConcern

  before_action -> { authorize_if_got_token! :'admin:read', :'admin:read:statuses' }, only: [:show]
  before_action -> { authorize_if_got_token! :'admin:write', :'admin:write:statuses' }, except: [:show]
  before_action :set_status

  after_action :verify_authorized

  def show
    authorize [:admin, @status], :show?
    render json: @status, serializer: REST::StatusSerializer
  end

  def destroy
    # modeled on handle_delete from status_batch_action.rb
    authorize [:admin, @status], :destroy?
    ApplicationRecord.transaction do
      @status.discard_with_reblogs
      log_action :destroy, @status
      Tombstone.find_or_create_by(uri: @status.uri, account: @status.account, by_moderator: true)

      if @status.with_media?
        # Immediately remove public copy of media instead of waiting for
        # the vacuum_orphaned_records job to take care of it later on
        Admin::MediaAttachmentDeletionWorker.perform_async(@status.media_attachments.map(&:id))
      end
    end

    json = render_to_body json: @status, serializer: REST::StatusSerializer, source_requested: true

    RemovalWorker.perform_async(@status.id, { 'preserve' => @status.account.local?, 'immediate' => !@status.account.local? })

    render json: json
  end

  def unsensitive
    # modeled on undo_mark_statuses_as_sensitive from approve_appeal_service.rb
    authorize [:admin, @status], :update?
    representative_account = Account.representative
    ApplicationRecord.transaction do
      UpdateStatusService.new.call(@status, representative_account.id, sensitive: false) if @status.with_media?
      log_action :unsensitive, @status
    end
    render json: @status, serializer: REST::StatusSerializer
  end

  private

  def set_status
    @status = Status.find(params[:id])
  end
end
