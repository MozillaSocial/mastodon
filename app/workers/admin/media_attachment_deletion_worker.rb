# frozen_string_literal: true

class Admin::MediaAttachmentDeletionWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'pull', lock: :until_executed, lock_ttl: 1.week.to_i

  def perform(media_attachments)
    AttachmentBatch.new(MediaAttachment, media_attachments).clear
  end
end
